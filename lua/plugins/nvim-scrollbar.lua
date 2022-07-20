local M = {}

function M.config()
    require("scrollbar").setup {
        handle = { color = "#4C566A" },
        excluded_filetypes = {
        "prompt",
        "TelescopePrompt",
        "tex"
    }, }
    require("hlslens").setup({
        require("scrollbar.handlers.search").setup()
    })

    vim.cmd([[
    augroup scrollbar_search_hide
    autocmd!
    autocmd CmdlineLeave : lua require('scrollbar.handlers.search').handler.hide()
    augroup END
    ]])
end

return M
