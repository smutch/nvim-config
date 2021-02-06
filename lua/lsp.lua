-- LSP

local M = {}

local lspconfig = require('lspconfig')
-- local util = require('lspconfig/util')
local configs = require('lspconfig/configs')
local lsp_status = require('lsp-status')
lsp_status.register_progress()
vim.lsp.set_log_level("debug")

-- require('lspfuzzy').setup {}
require'compe'.setup {
    enabled = true;
    debug = false;
    min_length = 1;
    -- preselect = 'enable' || 'disable' || 'always';
    -- throttle_time = ... number ...;
    -- source_timeout = ... number ...;
    -- incomplete_delay = ... number ...;
    -- allow_prefix_unmatch = false;

    source = {
        nvim_lsp = true;
        ultisnips = true;
        path = true;
        buffer = true;
        nvim_lua = true;
        -- tags = true;
        -- nvim_lua = { ... overwrite source configuration ... };
    };
}

require'lspsaga'.init_lsp_saga()


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
              prefix = '⇏',
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
  vim.fn.nvim_set_keymap("n", "gd", "<cmd>lua require'lspsaga.provider'.preview_definition()<CR>", {noremap = true, silent = true})
  vim.fn.nvim_set_keymap("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", {noremap = true, silent = true})
  vim.fn.nvim_set_keymap("n", "gD", "<cmd>lua vim.lsp.buf.implementation()<CR>", {noremap = true, silent = true})
  vim.fn.nvim_set_keymap("n", "gk", "<cmd>lua require('lspsaga.signaturehelp').signature_help()<CR>", {noremap = true, silent = true})
  vim.fn.nvim_set_keymap("n", "ga", "<cmd>lua require('lspsaga.codeaction').code_action()<CR>", {noremap = true, silent = true})
  vim.fn.nvim_set_keymap("v", "ga", "<cmd>'<,'>lua require('lspsaga.codeaction').range_code_action()<CR>", {noremap = true, silent = true})
  vim.fn.nvim_set_keymap("n", "1gD", "<cmd>lua vim.lsp.buf.type_definition()<CR>", {noremap = true, silent = true})
  vim.fn.nvim_set_keymap("n", "gr", "<cmd>lua require'lspsaga.provider'.lsp_finder()<CR>", {noremap = true, silent = true})
  vim.fn.nvim_set_keymap("n", "]d", "<cmd>lua require'lspsaga.diagnostic'.lsp_jump_diagnostic_next()<CR>", {noremap = true, silent = true})
  vim.fn.nvim_set_keymap("n", "[d", "<cmd>lua require'lspsaga.diagnostic'.lsp_jump_diagnostic_prev()<CR>", {noremap = true, silent = true})
  vim.fn.nvim_set_keymap("n", "<localleader>D", "<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>", {noremap = true, silent = true})
  vim.fn.nvim_set_keymap("n", "<localleader>d", "<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>", {noremap = true, silent = true})
  vim.fn.nvim_set_keymap("n", "<localleader>f", "<cmd>lua vim.lsp.buf.formatting_sync()<CR>", {noremap = true, silent = true})

  vim.api.nvim_command('call sign_define("LspDiagnosticsSignError", {"text" : "", "texthl" : "LspDiagnosticsVirtualTextError"})')
  vim.api.nvim_command('call sign_define("LspDiagnosticsSignWarning", {"text" : "", "texthl" : "LspDiagnosticsVirtualTextWarning"})')
  vim.api.nvim_command('call sign_define("LspDiagnosticsSignInformation", {"text" : "", "texthl" : "LspDiagnosticsVirtualTextInformation"})')
  vim.api.nvim_command('call sign_define("LspDiagnosticsSignHint", {"text" : "", "texthl" : "LspDiagnosticsVirtualTextHint"})')

  vim.g.lsp_diagnositc_sign_priority = 80

  lsp_status.on_attach(client)
end

local conda_prefix = "/usr"
if vim.env.CONDA_PREFIX then
    conda_prefix = vim.env.CONDA_PREFIX
end

local interpreter_path = conda_prefix .. "/bin/python"
lspconfig.pyright.setup{
    on_attach = on_attach;
    cmd = {"/fred/oz013/smutch/conda_envs/nvim/bin/pyright-langserver", "--stdio"};
    settings = {
        python = {
            analysis = {
                autoSearchPaths = true;
                useLibraryCodeForTypes = true;
                venvPath = string.match(conda_prefix, "^(.*)/.*$");
                venv = string.match(conda_prefix, "^.*/(.*)$");
            }
        }
    }
}

local os
local clangd_bin = "clangd"
local cmake_langserver_bin = "cmake"
local hostname = vim.fn.system('hostname')
if vim.fn.has('osx') == 1 then
    os = "MacOS"
    clangd_bin = "/usr/local/Cellar/llvm/11.0.0/bin/clangd"
    cmake_langserver_bin = "/Users/smutch/miniconda3/envs/global/bin/cmake-language-server"
else
    os = "Linux"
    if string.match('farnarkle', hostname) or string.match('ozstar', hostname) then
        clangd_bin = "/fred/oz013/smutch/conda_envs/nvim/bin/clangd"
        cmake_langserver_bin = "/fred/oz013/smutch/conda_envs/nvim/bin/cmake-language-server"
    end
end

-- lspconfig.vimls.setup{
--   on_attach = on_attach
-- }
lspconfig.clangd.setup{
  on_attach = on_attach,
  cmd = {clangd_bin, "--background-index"}
}
lspconfig.rls.setup{
  on_attach = on_attach
}
lspconfig.cmake.setup{
  on_attach = on_attach,
  cmd = {cmake_langserver_bin}
}
-- lspconfig.jsonls.setup{
--   on_attach = on_attach
-- }


return M
