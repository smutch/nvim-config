local gh = require("load").gh

require("load").later(function()
    vim.pack.add(gh({
        "tpope/vim-repeat",
        "andymass/vim-matchup",
        "chrisbra/unicode.vim",
        "andymass/vim-matchup",
        "yorickpeterse/nvim-jump.git",
    }))

    require("match-up").setup({})

    vim.keymap.set({ "n", "x", "o" }, "s", require("jump").start, { desc = "Jump" })
end)

require("load").on_event("InsertEnter", function()
    vim.pack.add(gh({
        "tpope/vim-rsi",
        "tpope/vim-surround",
    }))
end)
