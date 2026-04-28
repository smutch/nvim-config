local gh = require("load").gh
local prev_laststatus = vim.o.laststatus

local deps = {
    "mini.nvim/mini.colors",
}
vim.pack.add(gh(vim.list_extend(deps, { "rose-pine/neovim" })))
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
vim.api.nvim_set_hl(0, "TermNormal", {
    bg = require("mini.colors").modify_channel(
        string.format("#%06x", vim.api.nvim_get_hl(0, { name = "Normal" }).bg),
        "chroma",
        function(v) ---@diagnostic disable-line: unused-local
            return 3
        end
    ),
})

-- vim.pack.add(gh({ "EdenEast/nightfox.nvim" }))
-- vim.cmd.colorscheme("nightfox")

-- vim.pack.add(gh({ "rrebelot/kanagawa.nvim" }))
-- require("kanagawa").setup({
--     colors = {
--         theme = {
--             all = {
--                 ui = {
--                     bg_gutter = "none",
--                 },
--             },
--         },
--     },
--     overrides = function(colors)
--         local theme = colors.theme
--         return {
--             WinSeparator = { fg = colors.palette.waveBlue2 },
--             FloatBorder = { fg = "none", bg = "none" },
--             FloatTitle = { bg = "none" },
--             -- NormalFloat = { bg = "none" },
--             TermNormal = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m3 }
--         }
--     end,
-- })
-- vim.cmd.colorscheme("kanagawa-wave")

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
