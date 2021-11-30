-- LSP
local M = {}

local lsp_status = require 'lsp-status'
local Path = require 'plenary.path'
local h = require 'helpers'
lsp_status.register_progress()
-- vim.lsp.set_log_level("debug")

vim.cmd("hi LspDiagnosticsVirtualTextWarning guifg=#7d5500")
vim.cmd("hi! link SignColumn Normal")

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
    underline = true,
    virtual_text ={ spacing = 4 },
    signs = true,
    update_in_insert = false,
    severity_sort = true
})

-- ripped from runtime/lua/vim/lsp/buf.lua
local function select_client(method)
  local clients = vim.tbl_values(vim.lsp.buf_get_clients());
  clients = vim.tbl_filter(function (client)
    return client.supports_method(method)
  end, clients)
  -- better UX when choices are always in the same order (between restarts)
  table.sort(clients, function (a, b) return a.name < b.name end)

  if #clients > 1 then
    local choices = {}
    for k,v in pairs(clients) do
      table.insert(choices, string.format("%d %s", k, v.name))
    end
    local user_choice = vim.fn.confirm(
      "Select a language server:",
      table.concat(choices, "\n"),
      0,
      "Question"
    )
    if user_choice == 0 then return nil end
    return clients[user_choice]
  elseif #clients < 1 then
    return nil
  else
    return clients[1]
  end
end

-- ripped from runtime/lua/vim/lsp/buf.lua with extra notify call upon success
function M.formatting_sync(options, timeout_ms)
  local client = select_client("textDocument/formatting")
  if client == nil then return end

  local params = vim.lsp.util.make_formatting_params(options)
  local result, err = client.request_sync("textDocument/formatting", params, timeout_ms, vim.api.nvim_get_current_buf())
  if result and result.result then
    vim.lsp.util.apply_text_edits(result.result)
    vim.notify("vim.lsp.buf.formatting_sync: Complete", vim.log.levels.INFO)
  elseif err then
    vim.notify("vim.lsp.buf.formatting_sync: " .. err, vim.log.levels.WARN)
  end
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
    bnoremap("n", "]d", "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>", { silent = true })
    bnoremap("n", "[d", "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>", { silent = true })
    bnoremap("n", "<localleader>D", "<cmd>LspTroubleToggle<cr>", { silent = true })
    bnoremap("n", "<localleader>d", "<cmd>Trouble lsp_document_diagnostics<cr>", { silent = true })
    bnoremap("n", "<localleader>i", "<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>", { silent = true })
    bnoremap("n", "<localleader>f", "<cmd>lua require'lsp'.formatting_sync()<CR>", { silent = true })  -- WARNING: lsp (this module) NOT vim.lsp.buf
    bnoremap("n", "ga", "<cmd>Telescope lsp_code_actions theme=cursor<CR>", { silent = true })

    vim.api.nvim_command(
        'call sign_define("DiagnosticSignError", {"text" : "", "texthl" : "DiagnosticVirtualTextError"})')
    vim.api.nvim_command(
        'call sign_define("DiagnosticSignWarning", {"text" : "", "texthl" : "DiagnosticVirtualTextWarning"})')
    vim.api.nvim_command(
        'call sign_define("DiagnosticSignInformation", {"text" : "", "texthl" : "DiagnosticVirtualTextInformation"})')
    vim.api.nvim_command(
        'call sign_define("DiagnosticSignHint", {"text" : "", "texthl" : "DiagnosticVirtualTextHint"})')

    vim.g.lsp_diagnositc_sign_priority = 100

    lsp_status.on_attach(client)
end

local python_prefix = "/usr"
if vim.env.VIRTUAL_ENV then
    python_prefix = vim.env.VIRTUAL_ENV
elseif Path:new("./poetry.lock"):exists() then
    python_prefix = string.sub(vim.fn.system('poetry env info --path'), 0, -2)
elseif vim.env.CONDA_PREFIX then
    python_prefix = vim.env.CONDA_PREFIX
elseif Path:new(vim.env.HOME .. "/.pyenv/shims/python"):exists() then
    python_prefix = "/Users/smutch/.pyenv/shims/python"
end

local interpreter_path = python_prefix .. "/bin/python"
if python_prefix:sub(-#"python") == "python" then
    interpreter_path = python_prefix
end

print("Set LSP python interpreter to: " .. interpreter_path)

-- Use LspInstall to set up automatically installed servers
local lsp_installer = require("nvim-lsp-installer")
lsp_installer.on_server_ready(function(server)
    local opts = {
        on_attach = on_attach,
        capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities()),
        flags = {
            debounce_text_changes = 150,
        }
    }

    -- Customize the options passed to the server
    if server.name == "pyright" then
        opts.settings = {
            python = {
                pythonPath = interpreter_path,
                analysis = {
                    autoSearchPaths = true,
                    useLibraryCodeForTypes = true,
                    extraPaths = { vim.env.PYTHONPATH }
                }
            }
        }
    elseif server.name == "sumneko_lua" then
        opts.settings = { Lua = { diagnostics = { globals = { 'vim' } }, workspace = { preloadFileSize = 500 } } }
    elseif server.name == "efm" then
        opts.filetypes = { 'python', 'lua' }
        opts.init_options = { documentFormatting = true }
        opts.settings = {
            rootMarkers = { ".git/" },
            languages = {
                lua = {
                    {
                        formatCommand = "lua-format --column-limit=120 --spaces-inside-table-braces -i",
                        formatStdin = true
                    }
                },
                python = {
                    {
                        formatCommand = 'if [ -e pyproject.toml ]; then '.. python_prefix ..'/bin/isort --quiet --profile black - | '.. python_prefix ..'/bin/black --quiet -; else isort --quiet -l 120 - | black --quiet -l 120 -; fi',
                        formatStdin = true
                    }
                }
            }
        }
    elseif server.name == "rust_analyzer" then
        opts.settings = {
            ['rust-analyzer'] = {
                checkOnSave = {
                    allFeatures = true,
                    overrideCommand = {
                        'cargo', 'clippy', '--workspace', '--message-format=json', '--all-targets',
                        '--all-features'
                    }
                }
            }
        }
    elseif server.name == "clangd" then
        -- This is for systems (like OzSTAR) where glibc is too old to be compatible
        -- with binary releases of clangd...
        if vim.g.clangd_bin then
            opts.cmd = { vim.g.clangd_bin, "--background-index" }
        end
    end

    -- This setup() function is exactly the same as lspconfig's setup function (:help lspconfig-quickstart)
    server:setup(opts)
    vim.cmd [[ do User LspAttachBuffers ]]
end)

return M
