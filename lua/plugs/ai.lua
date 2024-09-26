return {
    {
        "zbirenbaum/copilot.lua",
        event = { "InsertEnter" },
        config = function()
            local enable = require "system".enable_copilot
            if enable == nil then enable = false end
            require("copilot").setup({
                filetypes = {
                    ["*"] = enable
                },
                copilot_node_command = vim.g.node_host_prog,
                suggestion = {
                    enabled = true,
                    auto_trigger = true,
                },
                panel = { enabled = true },
            })
        end
    },
    {
        "yetone/avante.nvim",
        -- event = "VeryLazy",
        cmd = "AvanteAsk",
        build = "make",
        opts = {
            provider = (function()
                local provider = require "system".avante_provider
                if provider == nil then provider = "copilot" end
                return provider
            end)(),
        },
        dependencies = {
            "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
            "stevearc/dressing.nvim",
            "nvim-lua/plenary.nvim",
            "MunifTanjim/nui.nvim",
        },
    },
}
