-- LSP

local diagnostic = require('diagnostic')
local nvim_lsp = require('nvim_lsp')
-- local configs = require('nvim_lsp/configs')

vim.g.diagnostic_insert_delay = 1
vim.g.diagnostic_auto_popup_while_jump = 1

local on_attach = function(client, bufnr)
  diagnostic.on_attach(client, bufnr)

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
  vim.fn.nvim_set_keymap("n", "<localleader>]", "<cmd>lua diagnostic.jumpLoc.jumpNextLocationCycle()<CR>", {noremap = true, silent = true})
  vim.fn.nvim_set_keymap("n", "<localleader>[", "<cmd>lua diagnostic.jumpLoc.jumpPrevLocationCycle()<CR>", {noremap = true, silent = true})
  vim.fn.nvim_set_keymap("n", "<localleader>d", "<cmd>lua diagnostic.jumpLoc.openDiagnostics()<CR>", {noremap = true, silent = true})

  vim.api.nvim_command('call sign_define("LspDiagnosticsErrorSign", {"text" : "", "texthl" : "LspDiagnosticsError"})')
  vim.api.nvim_command('call sign_define("LspDiagnosticsWarningSign", {"text" : "", "texthl" : "LspDiagnosticsWarning"})')
  vim.api.nvim_command('call sign_define("LspDiagnosticsInformationSign", {"text" : "", "texthl" : "LspDiagnosticsInformation"})')
  vim.api.nvim_command('call sign_define("LspDiagnosticsHintSign", {"text" : "", "texthl" : "LspDiagnosticsHint"})')
end

nvim_lsp.pyls_ms.setup{
    on_attach = on_attach
}
nvim_lsp.sumneko_lua.setup{
  on_attach = on_attach,
  cmd = {
      "/Users/smutch/.cache/nvim/nvim_lsp/sumneko_lua/lua-language-server/bin/macOS/lua-language-server",
      "-E",
      "/Users/smutch/.cache/nvim/nvim_lsp/sumneko_lua/lua-language-server/main.lua"
  }
}
-- nvim_lsp.vimls.setup{
  -- on_attach = on_attach
-- }
nvim_lsp.clangd.setup{
  on_attach = on_attach
}
nvim_lsp.rls.setup{
  on_attach = on_attach
}
nvim_lsp.cmake.setup{
  on_attach = on_attach
}
-- nvim_lsp.jsonls.setup{
  -- on_attach = on_attach
-- }
