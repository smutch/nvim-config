local M = {}

function M.config()
    vim.g.taboo_tab_format = " %I %f%m "
    vim.g.taboo_renamed_tab_format = " %I %l%m "
end

return M
