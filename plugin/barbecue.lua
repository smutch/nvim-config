vim.schedule(function()
    local gh = require("load").gh

    local deps = { "SmiteshP/nvim-navic", "echasnovski/mini.icons" }
    vim.pack.add(gh(vim.tbl_extend("error", deps, { "utilyre/barbecue.nvim" })))

    vim.g.navic_silence = true

    require("barbecue").setup({
        theme = {
            basename = { fg = "#baa386", bold = true },
        },
    })
end)
