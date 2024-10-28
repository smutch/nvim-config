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
    -- {
    --     "yetone/avante.nvim",
    --     event = "VeryLazy",
    --     cmd = "AvanteAsk",
    --     build = "make",
    --     opts = {
    --         provider = (function()
    --             local provider = require "system".avante_provider
    --             if provider == nil then provider = "copilot" end
    --             return provider
    --         end)(),
    --     },
    --     dependencies = {
    --         "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
    --         "stevearc/dressing.nvim",
    --         "nvim-lua/plenary.nvim",
    --         "MunifTanjim/nui.nvim",
    --     },
    -- },
    {
        "olimorris/codecompanion.nvim",
        event = "VeryLazy",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
            "hrsh7th/nvim-cmp",                      -- Optional: For using slash commands and variables in the chat buffer
            "nvim-telescope/telescope.nvim",         -- Optional: For using slash commands
            { "stevearc/dressing.nvim", opts = {} }, -- Optional: Improves `vim.ui.select`
        },
        config = function()
            require "codecompanion".setup {
                strategies = {
                    chat = {
                        adapter = "copilot",
                    },
                    inline = {
                        adapter = "copilot",
                    },
                },
            }
            vim.cmd([[cab cc CodeCompanion]])
        end,
        keys = {
            { "<M-a>",          "<cmd>CodeCompanionActions<cr>",     mode = "n" },
            { "<M-a>",          "<cmd>CodeCompanionActions<cr>",     mode = "v" },
            { "<LocalLeader>a", "<cmd>CodeCompanionChat Toggle<cr>", mode = "n" },
            { "<LocalLeader>a", "<cmd>CodeCompanionChat Toggle<cr>", mode = "v" },
            { "ga",             "<cmd>CodeCompanionChat Add<cr>",    mode = "v" },
        }
    }
}
