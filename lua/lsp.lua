-- LSP
local M = {}

local h = require 'helpers'
-- vim.lsp.set_log_level("debug")

vim.cmd("hi LspDiagnosticsVirtualTextWarning guifg=#7d5500")
vim.cmd("hi! link SignColumn Normal")

vim.diagnostic.config({
    underline = true,
    -- virtual_text = { spacing = 4 },
    virtual_text = false,
    signs = true,
    update_in_insert = false,
    severity_sort = true
})

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
    bnoremap("n", "<localleader>d", "<cmd>Trouble document_diagnostics<cr>", { silent = true })
    bnoremap("n", "<localleader>i", "<cmd>lua vim.diagnostic.open_float()<CR>", { silent = true })
    bnoremap("n", "<localleader>f", "<cmd>lua vim.lsp.buf.format()<CR>", { silent = true }) -- WARNING: lsp (this module) NOT vim.lsp.buf
    bnoremap("n", "ga", "<cmd>lua vim.lsp.buf.code_action()<CR>", { silent = true })

    vim.api.nvim_command(
        'call sign_define("DiagnosticSignError", {"text" : "", "texthl" : "DiagnosticVirtualTextError"})')
    vim.api.nvim_command(
        'call sign_define("DiagnosticSignWarning", {"text" : "", "texthl" : "DiagnosticVirtualTextWarning"})')
    vim.api.nvim_command(
        'call sign_define("DiagnosticSignInformation", {"text" : "", "texthl" : "DiagnosticVirtualTextInformation"})')
    vim.api.nvim_command(
        'call sign_define("DiagnosticSignHint", {"text" : "", "texthl" : "DiagnosticVirtualTextHint"})')

    vim.g.lsp_diagnostic_sign_priority = 100

    -- require('nvim-navic').attach(client, bufnr)
end

-- nvim-ufo
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.foldingRange = { dynamicRegistration = false, lineFoldingOnly = true }

local base_opts = {
    on_attach = on_attach,
    capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities),
    flags = { debounce_text_changes = 250 },

    settings = {
        python = {
            pythonPath = h.python_interpreter_path,
            analysis = { autoSearchPaths = true, useLibraryCodeForTypes = true, extraPaths = { vim.env.PYTHONPATH } }
        },
        pylsp = {
            plugins = { pycodestyle = { maxLineLength = 120 }, jedi = { environment = h.python_interpreter_path } }
        },
        ['rust-analyzer'] = {
            checkOnSave = {
                allFeatures = true,
                overrideCommand = {
                    'cargo', 'clippy', '--workspace', '--message-format=json', '--all-targets', '--all-features'
                }
            }
        },
        Lua = {
            diagnostics = { globals = { 'vim' } },
            workspace = { preloadFileSize = 500 },
            format = { enable = false }
        }
        -- ltex = { language = "en", additionalRules = { enablePickyRules = true }, disabledRules = {  } },
    }

}

-- Use mason to set up automatically installed servers
require"mason-lspconfig".setup_handlers({
    function(server_name) -- default handler (optional)
        require("lspconfig")[server_name].setup(base_opts)
    end,
    -- Customize the options passed to the server
    ["clangd"] = function()
        if vim.g.clangd_bin then
            -- This is for systems (like OzSTAR) where glibc is too old to be compatible
            -- with binary releases of clangd...
            local opts = vim.deepcopy(base_opts)
            opts.cmd = { vim.g.clangd_bin, "--background-index" }
            require"lspconfig".clangd.setup(opts)
        end
    end,
    ["rust_analyzer"] = function()
        require"rust-tools".setup({ server = base_opts, tools = { inlay_hints = { max_len_align = true, max_len_align_padding = 2 } } })
    end
})

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
        }), null_ls.builtins.formatting.nimpretty, null_ls.builtins.diagnostics.chktex
    },
    debounce = base_opts.flags.debounce_text_changes,
    on_attach = on_attach
}

require'lspconfig'.nimls.setup(base_opts)

local julia_opts = vim.deepcopy(base_opts)
julia_opts.julia = { environmentPath = "./" }
require'lspconfig'.julials.setup(julia_opts)

-- local ltex_opts = vim.deepcopy(base_opts)
-- ltex_opts.on_attach = function(client, buffer)
--     on_attach(client, buffer)
--     require("ltex_extra").setup {
--         load_langs = { "en-AU" },
--         init_check = true,
--         path = ".ltex",
--     }
-- end
-- ltex_opts.filetypes = {"tex"}
-- require 'lspconfig'.ltex.setup(ltex_opts)

return M
