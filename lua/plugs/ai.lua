return {
    {
        "zbirenbaum/copilot.lua",
        event = { "InsertEnter" },
        config = function()
            local enable = require("system").enable_copilot
            if enable == nil then
                enable = false
            end
            require("copilot").setup({
                filetypes = {
                    ["*"] = enable,
                },
                copilot_node_command = vim.g.node_host_prog,
                suggestion = {
                    enabled = true,
                    auto_trigger = true,
                },
                panel = { enabled = true },
            })
        end,
    },
    {
        "olimorris/codecompanion.nvim",
        event = "VeryLazy",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
            "hrsh7th/nvim-cmp", -- Optional: For using slash commands and variables in the chat buffer
            "nvim-telescope/telescope.nvim", -- Optional: For using slash commands
            { "stevearc/dressing.nvim", opts = {} }, -- Optional: Improves `vim.ui.select`
        },
        config = function()
            require("codecompanion").setup({
                strategies = {
                    chat = {
                        adapter = "copilot", -- copilot defaults to claude-sonent now! 🎉
                    },
                    inline = {
                        adapter = "copilot",
                    },
                    strategies = {
                        inline = {
                            keymaps = {
                                accept_change = {
                                    modes = { n = "ga" },
                                    description = "Accept the suggested change",
                                },
                                reject_change = {
                                    modes = { n = "gr" },
                                    description = "Reject the suggested change",
                                },
                            },
                        },
                    },
                },
                adapters = {
                    anthropic = function()
                        return require("codecompanion.adapters").extend("anthropic", {
                            env = {
                                api_key = require("system").anthropic_api_key,
                            },
                        })
                    end,
                },
            })
            vim.cmd([[cab cc CodeCompanion]])
        end,
        keys = {
            { "<M-c>", "<cmd>CodeCompanionActions<cr>", mode = "n" },
            { "<M-c>", "<cmd>CodeCompanionActions<cr>", mode = "v" },
            { "<LocalLeader>c", "<cmd>CodeCompanionChat Toggle<cr>", mode = "n" },
            { "<LocalLeader>c", "<cmd>CodeCompanionChat Toggle<cr>", mode = "v" },
            { "<LocalLeader>a", "<cmd>CodeCompanionChat Add<cr>", mode = "v" },
        },
    },
}
