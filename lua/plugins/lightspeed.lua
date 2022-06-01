local M = {}

function M.config()
    -- These dummy mappings prevent lightspeed from implementing multi-line f/F/t/F
    -- jumps and breaking ; and ,
    vim.api.nvim_set_keymap('n', 'f', 'f', {})
    vim.api.nvim_set_keymap('n', 'F', 'F', {})
    vim.api.nvim_set_keymap('n', 't', 't', {})
    vim.api.nvim_set_keymap('n', 'T', 'T', {})
    vim.api.nvim_set_keymap('n', ';', ';', {})
    vim.api.nvim_set_keymap('n', ',', ',', {})
end

return M
