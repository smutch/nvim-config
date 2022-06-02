local M = {}

function M.config()
    vim.api.nvim_set_keymap('n', 'git', ':Git', { noremap = true })
    vim.api.nvim_set_keymap('n', '<leader>gs', ':Git<CR>', { noremap = true })
    vim.api.nvim_set_keymap('n', '<leader>ga', ':Git commit -a<CR>', { noremap = true })
    vim.api.nvim_set_keymap('n', '<leader>gd', ':Git diff<CR>', { noremap = true })
    vim.api.nvim_set_keymap('n', '<leader>gP', ':Git pull<CR>', { noremap = true })
    vim.api.nvim_set_keymap('n', '<leader>gp', ':Git push<CR>', { noremap = true })
    vim.api.nvim_set_keymap('n', '<leader>g/', ':Git grep<CR>', { noremap = true })
end

return M

