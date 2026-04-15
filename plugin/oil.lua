vim.pack.add(require("load").gh({ "stevearc/oil.nvim", "refractalize/oil-git-status.nvim" }))

require("oil").setup({
    -- Id is automatically added at the beginning, and name at the end
    columns = {
        "icon",
        "permissions",
        "size",
        "mtime",
    },
    -- Buffer-local options to use for oil buffers
    buf_options = {
        buflisted = false,
        modifiable = false,
        swapfile = false,
    },
    -- Window-local options to use for oil buffers
    win_options = {
        signcolumn = "auto:2",
    },
})

vim.keymap.set("n", "-", require("oil").open, { desc = "Open parent directory" })

require("oil-git-status").setup({})
