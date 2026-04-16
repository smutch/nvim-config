require("load").later(function()
    vim.pack.add(require("load").gh({
        "rcarriga/neotest-python",
        "rouge8/neotest-rust",
        "nvim-neotest/nvim-nio",
        "rcarriga/neotest",
    }))

    require("neotest").setup({ ---@diagnostic disable-line:missing-fields
        adapters = {
            require("neotest-python"),
            require("neotest-rust"),
        },
    })
    vim.keymap.set("n", "<localleader>tr", function()
        require("neotest").run.run()
    end, { desc = "Run nearest test" })

    vim.keymap.set("n", "<localleader>tR", function()
        require("neotest").run.run(vim.fn.expand("%"))
    end, { desc = "Run all tests in file" })

    vim.keymap.set("n", "<localleader>tc", function()
        require("neotest").run.stop()
    end, { desc = "Stop test run" })

    vim.keymap.set("n", "<localleader>ts", function()
        require("neotest").summary.toggle()
    end, { desc = "Toggle test summary" })

    vim.keymap.set("n", "[t", function()
        require("neotest").jump.prev({ status = "failed" })
    end, { desc = "Jump to previous failed test" })

    vim.keymap.set("n", "]t", function()
        require("neotest").jump.next({ status = "failed" })
    end, { desc = "Jump to next failed test" })
end)
