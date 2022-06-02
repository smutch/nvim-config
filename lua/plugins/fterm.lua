local M = {}

function M.config()
    vim.keymap.set('n', '<leader>tt', '<CMD>lua require("FTerm").toggle()<CR>')
    vim.keymap.set('n', '<leader>gl', '<CMD>lua require("FTerm").scratch({ cmd = "lazygit" })<CR>')
end

return M

