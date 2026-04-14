require("load").later(function()
    local gh = require("load").gh

    local deps = { "SmiteshP/nvim-navic", "echasnovski/mini.icons" }
    vim.pack.add(gh(vim.list_extend(deps, { "utilyre/barbecue.nvim" })))

    vim.g.navic_silence = true

    require("barbecue").setup({
        theme = {
            basename = { fg = "#baa386", bold = true },
        },
    })
end)
