-- LSP

local M = {}

local lspconfig = require('lspconfig')
-- local util = require('lspconfig/util')
-- local configs = require('lspconfig/configs')
local lsp_status = require('lsp-status')
local Path = require('plenary.path')
lsp_status.register_progress()
vim.lsp.set_log_level("debug")

require'lsp_signature'.on_attach({
    fix_pos=true,
    hint_enable = false,
    hint_prefix = " ",
})

-- require('lspfuzzy').setup {}
require'compe'.setup {
    enabled = true;
    debug = false;
    min_length = 1;

    source = {
        nvim_lsp = true,
        ultisnips = true,
        path = true,
        buffer = true,
        nvim_lua = true,
        emoji = true,
        -- tags = true;
        -- nvim_lua = { ... overwrite source configuration ... };
    };
}

vim.cmd("hi LspDiagnosticsVirtualTextWarning guifg=#7d5500")
vim.cmd("hi! link SignColumn Normal")

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    -- Enable underline, use default values
    underline = true,
    virtual_text = function(bufnr, client_id)
      local ok, result = pcall(vim.api.nvim_buf_get_var, bufnr, 'diagnostic_enable_virtual_text')
      -- No buffer local variable set, so just disable by default
      if not ok then
        return false
      end

      if result then
          return {
              spacing = 4,
              -- prefix = '⇏',
          }
      end

      return result
    end,
    signs = true,
    -- Disable a feature
    update_in_insert = false,
  }
)

M.toggle_virtual_text = function()
    if vim.b.diagnostic_enable_virtual_text == 1 then
        vim.b.diagnostic_enable_virtual_text = 0
    else
        vim.b.diagnostic_enable_virtual_text = 1
    end
    vim.cmd("edit")
end
vim.cmd("command ToggleVirtualText :lua require 'lsp'.toggle_virtual_text()<CR>")

-- vim.o.updatetime = 500
-- vim.api.nvim_command('autocmd CursorHold * lua vim.lsp.diagnostic.show_line_diagnostics()')

local on_attach = function(client, bufnr)
  -- Keybindings for LSPs
  -- Note these are in on_attach so that they don't override bindings in a non-LSP setting
  vim.api.nvim_set_keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", {noremap = true, silent = true})
  vim.api.nvim_set_keymap("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", {noremap = true, silent = true})
  vim.api.nvim_set_keymap("n", "gD", "<cmd>lua vim.lsp.buf.implementation()<CR>", {noremap = true, silent = true})
  vim.api.nvim_set_keymap("n", "gk", "<cmd>lua vim.lsp.buf.signature_help()<CR>", {noremap = true, silent = true})
  vim.api.nvim_set_keymap("n", "1gD", "<cmd>lua vim.lsp.buf.type_definition()<CR>", {noremap = true, silent = true})
  -- vim.api.nvim_set_keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", {noremap = true, silent = true})
  vim.api.nvim_set_keymap("n", "gR", "<cmd>lua vim.lsp.buf.rename()<CR>", {silent = true, noremap = true})
  vim.api.nvim_set_keymap("n", "gr", "<cmd>Trouble lsp_references<CR>", {silent = true, noremap = true})
  vim.api.nvim_set_keymap("n", "g0", "<cmd>lua vim.lsp.buf.document_symbol()<CR>", {noremap = true, silent = true})
  vim.api.nvim_set_keymap("n", "g\\", "<cmd>lua vim.lsp.buf.workspace_symbol()<CR>", {noremap = true, silent = true})
  vim.api.nvim_set_keymap("n", "]d", "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>", {noremap = true, silent = true})
  vim.api.nvim_set_keymap("n", "[d", "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>", {noremap = true, silent = true})
  -- vim.api.nvim_set_keymap("n", "<localleader>D", "<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>", {noremap = true, silent = true})
  vim.api.nvim_set_keymap("n", "<localleader>D", "<cmd>LspTroubleToggle<cr>", {silent = true, noremap = true})
  vim.api.nvim_set_keymap("n", "<localleader>d", "<cmd>Trouble lsp_document_diagnostics<cr>", {silent = true, noremap = true})
  vim.api.nvim_set_keymap("n", "<localleader>i", "<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>", {noremap = true, silent = true})
  vim.api.nvim_set_keymap("n", "<localleader>f", "<cmd>lua vim.lsp.buf.formatting_sync()<CR>", {noremap = true, silent = true})
  vim.api.nvim_set_keymap("n", "ga", "<cmd>lua vim.lsp.buf.code_action()<CR>", {noremap = true, silent = true})

  vim.api.nvim_command('call sign_define("LspDiagnosticsSignError", {"text" : "", "texthl" : "LspDiagnosticsVirtualTextError"})')
  vim.api.nvim_command('call sign_define("LspDiagnosticsSignWarning", {"text" : "", "texthl" : "LspDiagnosticsVirtualTextWarning"})')
  vim.api.nvim_command('call sign_define("LspDiagnosticsSignInformation", {"text" : "", "texthl" : "LspDiagnosticsVirtualTextInformation"})')
  vim.api.nvim_command('call sign_define("LspDiagnosticsSignHint", {"text" : "", "texthl" : "LspDiagnosticsVirtualTextHint"})')

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
end
local interpreter_path = python_prefix .. "/bin/python"
print("Set LSP python interpreter to: " .. interpreter_path)

-- Us LspInstall to set up automatically installed servers
local function setup_servers()
  require'lspinstall'.setup()
  local servers = require'lspinstall'.installed_servers()
  for _, server in pairs(servers) do
      if server == 'python' then
          require 'lspconfig'[server].setup{
              on_attach = on_attach,
              settings = {
                  python = {
                      pythonPath = interpreter_path;
                      analysis = {
                          autoSearchPaths = true;
                          useLibraryCodeForTypes = true;
                          extraPaths = {vim.env.PYTHONPATH};
                      }
                  }
              }
          }
      elseif server == 'lua' then
          require 'lspconfig'[server].setup{
              on_attach = on_attach,
              settings = {
                  Lua = {
                      diagnostics = {
                          globals = { 'vim' }
                      },
                      workspace = {
                          preloadFileSize = 500
                      }
                  }
              }
          }
      else
          require'lspconfig'[server].setup{on_attach = on_attach}
      end
  end
end

setup_servers()

-- This is for systems (like OzSTAR) where glibc is too old to be compatible
-- with binary releases of clangd...
if vim.g.clangd_bin then
    lspconfig.clangd.setup{
        on_attach = on_attach,
        cmd = {vim.g.clangd_bin, "--background-index"}
    }
end

-- Automatically reload after `:LspInstall <server>` so we don't have to restart neovim
require'lspinstall'.post_install_hook = function ()
  setup_servers() -- reload installed servers
  vim.cmd("bufdo e") -- this triggers the FileType autocmd that starts the server
end

return M
