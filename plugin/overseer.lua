require("load").later(function()
    vim.pack.add(require("load").gh({ "stevearc/overseer.nvim" }))
    require("overseer").setup({
        task_list = {
            bindings = {
                ["<C-l>"] = false,
                ["<C-h>"] = false,
                ["L"] = "IncreaseDetail",
                ["H"] = "DecreaseDetail",
                ["gL"] = "IncreaseAllDetail",
                ["gH"] = "DecreaseAllDetail",
                ["<C-k>"] = false,
                ["<C-j>"] = false,
                ["<C-u>"] = "ScrollOutputUp",
                ["<C-d>"] = "ScrollOutputDown",
            },
        },
    })
    vim.keymap.set("n", "<leader>ot", "<CMD>OverseerToggle<CR>", { desc = "Overseer - toggle" })
    vim.keymap.set("n", "<leader>or", "<CMD>OverseerRun<CR>", { desc = "Overseer - run" })
    vim.keymap.set("n", "<leader>oo", function()
        require("overseer").list_tasks()[1]:restart(true)
    end, { desc = "Overseer - restart" })
    vim.keymap.set("n", "<leader>ob", "<CMD>OverseerLoadBundle<CR>", { desc = "Overseer - load bundle" })
end)
