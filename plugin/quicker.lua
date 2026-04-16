vim.pack.add(require("load").gh({ "stevearc/quicker.nvim" }))

require("load").on_event("FileType~qf", function()
    require("quicker").setup({
        keys = {
            {
                ">",
                function()
                    require("quicker").expand({ before = 2, after = 2, add_to_existing = true })
                end,
                desc = "Expand quickfix context",
            },
            {
                "<",
                function()
                    require("quicker").collapse()
                end,
                desc = "Collapse quickfix context",
            },
        },
    })
    vim.keymap.set("n", "<leader>Q", function()
        require("quicker").toggle()
    end, { desc = "Toggle quickfix" })

    vim.keymap.set("n", "<leader>L", function()
        require("quicker").toggle({ loclist = true })
    end, { desc = "Toggle loclist" })
end)
