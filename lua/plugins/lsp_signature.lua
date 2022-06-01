local M = {}

M.config = function()
    require 'lsp_signature'.setup { fix_pos = true, hint_enable = false, hint_prefix = " " }
    vim.cmd([[hi link LspSignatureActiveParameter SpellBad]])
end

return M
