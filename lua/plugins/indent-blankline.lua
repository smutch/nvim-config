local M = {}

function M.config()
    require("indent_blankline").setup {
        char = '│',
        show_current_context = true,
        buftype_exclude = { "terminal" }
    }
    vim.cmd [[highlight! link IndentBlanklineChar VertSplit]]
end

return M

