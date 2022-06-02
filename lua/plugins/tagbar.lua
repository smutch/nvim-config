local M = {}

function M.config()
    vim.api.nvim_set_keymap('n', '<leader>T', ':TagbarToggle<CR>', {})
end

return M

