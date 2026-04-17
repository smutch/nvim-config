local load = require("load")

load.later(function()
    vim.pack.add(load.gh({ "folke/which-key.nvim" }))
    require("which-key").setup({})
    vim.keymap.set("n", "<leader>?", function()
        require("which-key").show({ global = false })
    end, { desc = "Buffer local keymaps (which-key)" })
end)
