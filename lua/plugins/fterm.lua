local M = {}

function M.config()
    vim.keymap.set('n', [[<M-\>]], '<CMD>lua require("FTerm").toggle()<CR>', {noremap = true})
    vim.keymap.set('t', [[<M-\>]], '<CMD>lua require("FTerm").toggle()<CR>', {noremap = true})
    vim.keymap.set('n', '<leader>gl', '<CMD>lua require("FTerm").scratch({ cmd = "lazygit" })<CR>')
end

return M

