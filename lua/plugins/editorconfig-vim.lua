local M = {}

function M.config()
    vim.g.EditorConfig_exclude_patterns = { 'fugitive://.*' }
end

return M

