require("load").later(function()
    vim.pack.add(require("load").gh({ "shortcuts/no-neck-pain.nvim" }))
    require("no-neck-pain").setup({
        width = 120,
    })
end)
