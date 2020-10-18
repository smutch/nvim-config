-- LSP

local M = {}

local diagnostic = require('diagnostic')
-- local diagnostic_util = require('diagnostic/util')
local nvim_lsp = require('nvim_lsp')
-- local util = require('nvim_lsp/util')
-- local configs = require('nvim_lsp/configs')

vim.g.diagnostic_insert_delay = 1
vim.g.diagnostic_auto_popup_while_jump = 1
vim.g.diagnostic_enable_virtual_text = 0
vim.g.space_before_virtual_text = 10
vim.g.diagnostic_show_sign = 1
vim.cmd("hi LspDiagnosticsWarning guifg=#7d5500")
vim.cmd("hi! link SignColumn Normal")
-- vim.o.updatetime = 500
-- vim.api.nvim_command('autocmd CursorHold * lua vim.lsp.util.show_line_diagnostics()')

M.toggle_virtual_text = function()
    if vim.g.diagnostic_enable_virtual_text == 1 then
        vim.g.diagnostic_enable_virtual_text = 0
    else
        vim.g.diagnostic_enable_virtual_text = 1
    end
    vim.cmd("edit")
end
vim.cmd("command ToggleVirtualText :lua require 'lsp'.toggle_virtual_text()<CR>")

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
  vim.fn.nvim_set_keymap("n", "]d", "<cmd>lua require 'jumpLoc'.jumpNextLocationCycle()<CR>", {noremap = true, silent = true})
  vim.fn.nvim_set_keymap("n", "[d", "<cmd>lua require 'jumpLoc'.jumpPrevLocationCycle()<CR>", {noremap = true, silent = true})
  vim.fn.nvim_set_keymap("n", "<localleader>D", "<cmd>lua require 'jumpLoc'.openDiagnostics()<CR>", {noremap = true, silent = true})
  vim.fn.nvim_set_keymap("n", "<localleader>d", "<cmd>lua vim.lsp.util.show_line_diagnostics()<CR>", {noremap = true, silent = true})
  vim.fn.nvim_set_keymap("n", "<localleader>f", "<cmd>lua vim.lsp.buf.formatting_sync()<CR>", {noremap = true, silent = true})

  vim.api.nvim_command('call sign_define("LspDiagnosticsErrorSign", {"text" : "", "texthl" : "LspDiagnosticsError"})')
  vim.api.nvim_command('call sign_define("LspDiagnosticsWarningSign", {"text" : "", "texthl" : "LspDiagnosticsWarning"})')
  vim.api.nvim_command('call sign_define("LspDiagnosticsInformationSign", {"text" : "", "texthl" : "LspDiagnosticsInformation"})')
  vim.api.nvim_command('call sign_define("LspDiagnosticsHintSign", {"text" : "", "texthl" : "LspDiagnosticsHint"})')
end

local conda_prefix = "/usr"
if vim.env.CONDA_PREFIX then
    conda_prefix = vim.env.CONDA_PREFIX
end

local interpreter_path = conda_prefix .. "/bin/python"
nvim_lsp.pyls_ms.setup{
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

-- function diagnostic.diagnostics_loclist(local_result)
--   if local_result then
--     for _, v in ipairs(local_result) do
--       v.uri = v.uri
--       v.lnum = v.range.start.line + 1
--       v.col = v.range.start.character + 1
--       v.text = v.message
--     end
--   end
--   vim.lsp.util.set_loclist(diagnostic_util.locations_to_items(local_result))
-- end

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

nvim_lsp.sumneko_lua.setup{
  on_attach = on_attach,
  cmd = {
      vim.env.HOME .. "/.cache/nvim/nvim_lsp/sumneko_lua/lua-language-server/bin/" .. os .. "/lua-language-server",
      "-E",
      vim.env.HOME .. "/.cache/nvim/nvim_lsp/sumneko_lua/lua-language-server/main.lua"
  }
}

-- nvim_lsp.vimls.setup{
--   on_attach = on_attach
-- }
nvim_lsp.clangd.setup{
  on_attach = on_attach,
  cmd = {clangd_bin, "--background-index"}
}
nvim_lsp.rls.setup{
  on_attach = on_attach
}
nvim_lsp.cmake.setup{
  on_attach = on_attach,
  cmd = {cmake_langserver_bin}
}
-- nvim_lsp.jsonls.setup{
--   on_attach = on_attach
-- }

--- This is a copy of the builtin function with the filetype of the floating -
--- buffer changed from `markdown` to that of the parent filetype (see the
--- `ownsyntax` call).
function vim.lsp.util.fancy_floating_markdown(contents, opts)
  vim.validate {
    contents = { contents, 't' };
    opts = { opts, 't', true };
  }
  opts = opts or {}

  local stripped = {}
  local highlights = {}
  do
    local i = 1
    while i <= #contents do
      local line = contents[i]
      -- TODO(ashkan): use a more strict regex for filetype?
      local ft = line:match("^```([a-zA-Z0-9_]*)$")
      -- local ft = line:match("^```(.*)$")
      -- TODO(ashkan): validate the filetype here.
      if ft then
        local start = #stripped
        i = i + 1
        while i <= #contents do
          line = contents[i]
          if line == "```" then
            i = i + 1
            break
          end
          table.insert(stripped, line)
          i = i + 1
        end
        table.insert(highlights, {
          ft = ft;
          start = start + 1;
          finish = #stripped + 1 - 1;
        })
      else
        table.insert(stripped, line)
        i = i + 1
      end
    end
  end
  -- Clean up and add padding
  stripped = vim.lsp.util._trim_and_pad(stripped, opts)

  -- Compute size of float needed to show (wrapped) lines
  opts.wrap_at = opts.wrap_at or (vim.wo["wrap"] and vim.api.nvim_win_get_width(0))
  local width, height = vim.lsp.util._make_floating_popup_size(stripped, opts)

  -- Insert blank line separator after code block
  local insert_separator = opts.separator
  if insert_separator == nil then insert_separator = true end
  if insert_separator then
    for i, h in ipairs(highlights) do
      h.start = h.start + i - 1
      h.finish = h.finish + i - 1
      if h.finish + 1 <= #stripped then
        table.insert(stripped, h.finish + 1, string.rep("─", math.min(width, opts.wrap_at)))
        height = height + 1
      end
    end
  end

  -- Make the floating window.
  local bufnr = vim.api.nvim_create_buf(false, true)
  local winnr = vim.api.nvim_open_win(bufnr, false, vim.lsp.util.make_floating_popup_options(width, height, opts))
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, stripped)
  vim.api.nvim_buf_set_option(bufnr, 'modifiable', false)

  -- Switch to the floating window to apply the syntax highlighting.
  -- This is because the syntax command doesn't accept a target.
  local cwin = vim.api.nvim_get_current_win()
  local cft = vim.api.nvim_buf_get_option(0, "filetype")
  vim.api.nvim_set_current_win(winnr)

  vim.cmd("ownsyntax " .. cft)
  local idx = 1
  --@private
  local function apply_syntax_to_region(ft, start, finish)
    if ft == '' then ft = cft end
    local name = ft..idx
    idx = idx + 1
    local lang = "@"..ft:upper()
    -- TODO(ashkan): better validation before this.
    if not pcall(vim.cmd, string.format("syntax include %s syntax/%s.vim", lang, ft)) then
      return
    end
    vim.cmd(string.format("syntax region %s start=+\\%%%dl+ end=+\\%%%dl+ contains=%s", name, start, finish + 1, lang))
  end
  -- Previous highlight region.
  -- TODO(ashkan): this wasn't working for some reason, but I would like to
  -- make sure that regions between code blocks are definitely markdown.
  -- local ph = {start = 0; finish = 1;}
  for _, h in ipairs(highlights) do
    -- apply_syntax_to_region('markdown', ph.finish, h.start)
    apply_syntax_to_region(h.ft, h.start, h.finish)
    -- ph = h
  end

  vim.api.nvim_set_current_win(cwin)
  return bufnr, winnr
end

return M
