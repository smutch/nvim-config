-- LSP

local M = {}

local lspconfig = require('lspconfig')
-- local util = require('lspconfig/util')
local configs = require('lspconfig/configs')

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
    if vim.g.diagnostic_enable_virtual_text == 1 then
        vim.g.diagnostic_enable_virtual_text = 0
    else
        vim.g.diagnostic_enable_virtual_text = 1
    end
    vim.cmd("edit")
end
vim.cmd("command ToggleVirtualText :lua require 'lsp'.toggle_virtual_text()<CR>")

-- vim.o.updatetime = 500
-- vim.api.nvim_command('autocmd CursorHold * lua vim.lsp.diagnostic.show_line_diagnostics()')


local on_attach = function(client, bufnr)
  -- Keybindings for LSPs
  -- Note these are in on_attach so that they don't override bindings in a non-LSP setting
  vim.fn.nvim_set_keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", {noremap = true, silent = true})
  vim.fn.nvim_set_keymap("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", {noremap = true, silent = true})
  vim.fn.nvim_set_keymap("n", "gD", "<cmd>lua vim.lsp.buf.implementation()<CR>", {noremap = true, silent = true})
  vim.fn.nvim_set_keymap("n", "gh", "<cmd>lua vim.lsp.buf.signature_help()<CR>", {noremap = true, silent = true})
  vim.fn.nvim_set_keymap("n", "1gD", "<cmd>lua vim.lsp.buf.type_definition()<CR>", {noremap = true, silent = true})
  vim.fn.nvim_set_keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", {noremap = true, silent = true})
  vim.fn.nvim_set_keymap("n", "g0", "<cmd>lua vim.lsp.buf.document_symbol()<CR>", {noremap = true, silent = true})
  vim.fn.nvim_set_keymap("n", "gW", "<cmd>lua vim.lsp.buf.workspace_symbol()<CR>", {noremap = true, silent = true})
  vim.fn.nvim_set_keymap("n", "]d", "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>", {noremap = true, silent = true})
  vim.fn.nvim_set_keymap("n", "[d", "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>", {noremap = true, silent = true})
  vim.fn.nvim_set_keymap("n", "<localleader>D", "<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>", {noremap = true, silent = true})
  vim.fn.nvim_set_keymap("n", "<localleader>d", "<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>", {noremap = true, silent = true})
  vim.fn.nvim_set_keymap("n", "<localleader>f", "<cmd>lua vim.lsp.buf.formatting_sync()<CR>", {noremap = true, silent = true})

  vim.api.nvim_command('call sign_define("LspDiagnosticsSignError", {"text" : "", "texthl" : "LspDiagnosticsVirtualTextError"})')
  vim.api.nvim_command('call sign_define("LspDiagnosticsSignWarning", {"text" : "", "texthl" : "LspDiagnosticsVirtualTextWarning"})')
  vim.api.nvim_command('call sign_define("LspDiagnosticsSignInformation", {"text" : "", "texthl" : "LspDiagnosticsVirtualTextInformation"})')
  vim.api.nvim_command('call sign_define("LspDiagnosticsSignHint", {"text" : "", "texthl" : "LspDiagnosticsVirtualTextHint"})')
end

local conda_prefix = "/usr"
if vim.env.CONDA_PREFIX then
    conda_prefix = vim.env.CONDA_PREFIX
end

local interpreter_path = conda_prefix .. "/bin/python"
lspconfig.pyls_ms.setup{
    on_attach = on_attach,
    root_dir = function(fname)
      return vim.fn.getcwd()
    end,
    InterpreterPath = interpreter_path,
    init_options={
        interpreter={
            properties={
                InterpreterPath = interpreter_path,
                Version = "3.8"
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
    clangd_bin = "/usr/local/Cellar/llvm/10.0.1_1/bin/clangd"
    cmake_langserver_bin = "/Users/smutch/miniconda3/envs/global/bin/cmake-language-server"
else
    os = "Linux"
    if string.match('farnarkle', hostname) or string.match('ozstar', hostname) then
        clangd_bin = "/fred/oz013/smutch/conda_envs/nvim/bin/clangd"
        cmake_langserver_bin = "/fred/oz013/smutch/conda_envs/nvim/bin/cmake-language-server"
    end
end

lspconfig.sumneko_lua.setup{
  on_attach = on_attach,
  cmd = {
      vim.env.HOME .. "/.cache/nvim/lspconfig/sumneko_lua/lua-language-server/bin/" .. os .. "/lua-language-server",
      "-E",
      vim.env.HOME .. "/.cache/nvim/lspconfig/sumneko_lua/lua-language-server/main.lua"
  }
}

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
