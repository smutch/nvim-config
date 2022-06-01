local M = {}

function M.setup()
    vim.api.nvim_set_keymap('i', [[<C-j>]], [[copilot#Accept("<CR>")]], { silent = true, script = true, expr = true })
    vim.g.copilot_no_tab_map = true
end

return M
