-- LSP
local M = {}

local h = require 'helpers'
-- vim.lsp.set_log_level("debug")

vim.cmd("hi LspDiagnosticsVirtualTextWarning guifg=#7d5500")
vim.cmd("hi! link SignColumn Normal")

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
    underline = true,
    -- virtual_text = { spacing = 4 },
    virtual_text = false,
    signs = true,
    update_in_insert = false,
    severity_sort = true
})

-- ripped from runtime/lua/vim/lsp/buf.lua
local function select_client(method, on_choice)
    vim.validate { on_choice = { on_choice, 'function', false } }
    local clients = vim.tbl_values(vim.lsp.buf_get_clients())
    clients = vim.tbl_filter(function(client) return client.supports_method(method) end, clients)
    -- better UX when choices are always in the same order (between restarts)
    table.sort(clients, function(a, b) return a.name < b.name end)

    if #clients > 1 then
        vim.ui.select(clients,
                      { prompt = 'Select a language server:', format_item = function(client) return client.name end },
                      on_choice)
    elseif #clients < 1 then
        on_choice(nil)
    else
        on_choice(clients[1])
    end
end

-- ripped from runtime/lua/vim/lsp/buf.lua with extra notify call upon success
function M.formatting_sync(options, timeout_ms)
    local params = require('vim.lsp.util').make_formatting_params(options)
    local bufnr = vim.api.nvim_get_current_buf()
    select_client('textDocument/formatting', function(client)
        if client == nil then return end

        local result, err = client.request_sync('textDocument/formatting', params, timeout_ms, bufnr)
        if result and result.result then
            require('vim.lsp.util').apply_text_edits(result.result, bufnr, client.offset_encoding)
            vim.notify("vim.lsp.buf.formatting_sync: Complete", vim.log.levels.INFO)
        elseif err then
            vim.notify('vim.lsp.buf.formatting_sync: ' .. err, vim.log.levels.WARN)
        elseif client.name == "null-ls" then
            vim.notify("vim.lsp.buf.formatting_sync: Complete", vim.log.levels.INFO)
        end
    end)
end

local on_attach = function(client, bufnr)
    -- Keybindings for LSPs
    -- Note these are in on_attach so that they don't override bindings in a non-LSP setting
    local function bnoremap(...) h.bnoremap(bufnr, ...) end
    bnoremap("n", "gd", "<cmd>Telescope lsp_definitions<CR>", { silent = true })
    bnoremap("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", { silent = true })
    bnoremap("n", "gD", "<cmd>Telescope lsp_implementations<CR>", { silent = true })
    bnoremap("n", "gk", "<cmd>lua vim.lsp.buf.signature_help()<CR>", { silent = true })
    bnoremap("n", "1gD", "<cmd>Telescope lsp_type_definitions<CR>", { silent = true })
    bnoremap("n", "gR", "<cmd>lua vim.lsp.buf.rename()<CR>", { silent = true })
    bnoremap("n", "gr", "<cmd>Telescope lsp_references<CR>", { silent = true })
    bnoremap("n", "1g/", "<cmd>Telescope lsp_document_symbols<CR>", { silent = true })
    bnoremap("n", "g/", "<cmd>Telescope lsp_workspace_symbols<CR>", { silent = true })
    bnoremap("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>", { silent = true })
    bnoremap("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>", { silent = true })
    bnoremap("n", "<localleader>D", "<cmd>LspTroubleToggle<cr>", { silent = true })
    bnoremap("n", "<localleader>d", "<cmd>Trouble lsp_document_diagnostics<cr>", { silent = true })
    bnoremap("n", "<localleader>i", "<cmd>lua vim.diagnostic.open_float()<CR>", { silent = true })
    bnoremap("n", "<localleader>f", "<cmd>lua require'lsp'.formatting_sync()<CR>", { silent = true }) -- WARNING: lsp (this module) NOT vim.lsp.buf
    bnoremap("n", "ga", "<cmd>Telescope lsp_code_actions theme=cursor<CR>", { silent = true })

    vim.api.nvim_command(
        'call sign_define("DiagnosticSignError", {"text" : "", "texthl" : "DiagnosticVirtualTextError"})')
    vim.api.nvim_command(
        'call sign_define("DiagnosticSignWarning", {"text" : "", "texthl" : "DiagnosticVirtualTextWarning"})')
    vim.api.nvim_command(
        'call sign_define("DiagnosticSignInformation", {"text" : "", "texthl" : "DiagnosticVirtualTextInformation"})')
    vim.api.nvim_command(
        'call sign_define("DiagnosticSignHint", {"text" : "", "texthl" : "DiagnosticVirtualTextHint"})')

    vim.g.lsp_diagnostic_sign_priority = 100

    require('nvim-navic').attach(client, bufnr)
end

-- Use LspInstall to set up automatically installed servers
local lsp_installer = require("nvim-lsp-installer")
local base_opts = {
    on_attach = on_attach,
    capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities()),
    flags = { debounce_text_changes = 250 }
}
lsp_installer.on_server_ready(function(server)
    -- Customize the options passed to the server
    local opts = base_opts
    if server.name == "pyright" then
        opts.settings = {
            python = {
                pythonPath = h.python_interpreter_path,
                analysis = { autoSearchPaths = true, useLibraryCodeForTypes = true, extraPaths = { vim.env.PYTHONPATH } }
            }
        }
    elseif server.name == "pylsp" then
        opts.settings = {
            pylsp = { plugins = { pycodestyle = { maxLineLength = 120 }, jedi = { environment = h.python_interpreter_path } } }
        }
    elseif server.name == "sumneko_lua" then
        opts.settings = { Lua = { diagnostics = { globals = { 'vim' } }, workspace = { preloadFileSize = 500 } } }
    elseif server.name == "rust_analyzer" then
        opts.settings = {
            ['rust-analyzer'] = {
                checkOnSave = {
                    allFeatures = true,
                    overrideCommand = {
                        'cargo', 'clippy', '--workspace', '--message-format=json', '--all-targets', '--all-features'
                    }
                }
                -- cargo = {
                --     allFeatures = true
                -- }
            }
        }
    elseif server.name == "clangd" then
        -- This is for systems (like OzSTAR) where glibc is too old to be compatible
        -- with binary releases of clangd...
        if vim.g.clangd_bin then opts.cmd = { vim.g.clangd_bin, "--background-index" } end
    end

    -- This setup() function is exactly the same as lspconfig's setup function (:help lspconfig-quickstart)
    server:setup(opts)
    vim.cmd [[ do User LspAttachBuffers ]]
end)

local null_ls = require("null-ls")
null_ls.setup {
    sources = {
        null_ls.builtins.formatting.black.with {
            -- command = h.python_prefix .. 'black',
            command = 'black',
            extra_args = function(params)
                if not h.file_exists('pyproject.toml') then
                    return { "-l", "120" }
                else
                    return {}
                end
            end
        }, null_ls.builtins.formatting.isort.with {
            -- command = h.python_prefix .. '/bin/isort'
            command = 'isort'
        },
        null_ls.builtins.formatting.lua_format
            .with { args = { "--column-limit=120", "--spaces-inside-table-braces", "-i" } },
        null_ls.builtins.formatting.prettier.with({
            filetypes = { "html", "json", "yaml", "markdown" },
            args = { "--print-width=1000" }
        }), null_ls.builtins.formatting.nimpretty
    },
    debounce = base_opts.flags.debounce_text_changes
}

require'lspconfig'.nimls.setup(base_opts)

local julia_opts = base_opts
julia_opts.julia = { environmentPath = "./" }
require'lspconfig'.julials.setup(julia_opts)

return M
