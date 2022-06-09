local M = {}

function M.config()
    vim.keymap.set('n', '<tab>', '<CMD>lua require("FTerm").toggle()<CR>', {noremap = true})
    vim.keymap.set('n', '<leader>gl', '<CMD>lua require("FTerm").scratch({ cmd = "lazygit" })<CR>')
end

return M

