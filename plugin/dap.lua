local gh = require("load").gh

require("load").later(function()
    vim.pack.add(gh({
        "mfussenegger/nvim-dap",
        "mfussenegger/nvim-dap-python",
        "igorlfs/nvim-dap-view",
    }))

    require("dap-python").setup("uv")
    require("dap-view").setup()

    vim.keymap.set("n", "<leader>db", function()
        require("dap").toggle_breakpoint()
    end, { desc = "Toggle breakpoint" })
    vim.keymap.set("n", "<leader>dc", function()
        require("dap").continue()
    end, { desc = "Continue" })
    vim.keymap.set("n", "<leader>dv", function()
        require("dap-view").toggle()
    end, { desc = "Toggle DAP view" })
    vim.keymap.set("n", "<leader>do", function()
        require("dap").step_over()
    end, { desc = "Step over" })
    vim.keymap.set("n", "<leader>di", function()
        require("dap").step_into()
    end, { desc = "Step into" })
    vim.keymap.set({ "n", "v" }, "<Leader>dh", function()
        require("dap.ui.widgets").hover()
    end, { desc = "DAP hover" })
    vim.keymap.set("n", "<leader>dp", function()
        require("dap").pause()
    end, { desc = "Pause" })
    vim.keymap.set("n", "<leader>dq", function()
        require("dap").close()
    end, { desc = "Quit DAP" })
end)
