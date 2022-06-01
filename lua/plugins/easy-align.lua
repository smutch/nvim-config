local M = {}

function M.config()
    vim.api.nvim_set_keymap('v', '<Enter>', '<Plug>(EasyAlign)', {})
    vim.api.nvim_set_keymap('n', 'gA', '<Plug>(EasyAlign)', {})
end

return M
