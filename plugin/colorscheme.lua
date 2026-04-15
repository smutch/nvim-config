local gh = require("load").gh
vim.pack.add(gh({ "rose-pine/neovim" }))

local prev_laststatus = vim.o.laststatus

require("rose-pine").setup({
    styles = {
        bold = true,
        italic = false,
        transparency = false,
    },
    ---@diagnostic disable-next-line: unused-local
    before_highlight = function(group, highlight, palette)
        -- print(group, highlight, palette)
        if string.match(string.lower(group), "comment") then
            highlight.italic = true
        end
    end,
})
vim.cmd.colorscheme("rose-pine-moon")

-- for some reason rose-pine sets this and we want it back to what it was before!
vim.o.laststatus = prev_laststatus

require("load").later(function()
    vim.pack.add(gh({ "uga-rosa/ccc.nvim" }))

    require("ccc").setup({
        highlighter = {
            auto_enable = true,
            lsp = true,
        },
    })
end)
