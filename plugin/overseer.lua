require("load").later(function()
    vim.pack.add(require("load").gh({ "stevearc/overseer.nvim" }))
    local overseer = require("overseer")
    overseer.setup({
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
        overseer.list_tasks()[1]:restart(true)
    end, { desc = "Overseer - restart" })

    overseer.register_template({
        name = "Typst watch",
        builder = function()
            return {
                cmd = { "typst", "watch", vim.fn.expand("%") },
            }
        end,
        condition = {
            filetype = { "typst" },
        },
    })
    overseer.register_template({
        name = "Preview with Skim",
        builder = function()
            return {
                -- note we use a string here instead of a table so that we use the shell and can use `open`.
                cmd = "open -a skim " .. string.gsub(vim.fn.expand("%"), "%.typ$", ".pdf", 1),
            }
        end,
        condition = {
            filetype = { "typst" },
        },
    })
end)
