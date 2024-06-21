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
        "jackMort/ChatGPT.nvim",
        event = "VeryLazy",
        config = function()
            vim.env.OPENAI_API_KEY = require "system".openai_api_key
            if vim.env.OPENAI_API_KEY ~= nil then
                vim.env.OPENAI_API_HOST = "api.openai.com"
                require("chatgpt").setup()
            end
        end,
        dependencies = {
            "MunifTanjim/nui.nvim",
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope.nvim"
        }
    },
    {
        'CopilotC-Nvim/CopilotChat.nvim',
        branch = "canary",
        dependencies = {
            { "zbirenbaum/copilot.lua" }, -- or github/copilot.vim
            { "nvim-lua/plenary.nvim" },  -- for curl, log wrapper
            { "hrsh7th/nvim-cmp" },
        },
        config = function()
            require("CopilotChat.integrations.cmp").setup()
            require("CopilotChat").setup {
                context = 'manual',           -- Context to use, 'buffers', 'buffer' or 'manual'
                show_user_selection = true,   -- Shows user selection in chat
                show_folds = true,            -- Shows folds for sections in chat
                clear_chat_on_new_prompt = false, -- Clears chat on every new prompt
                auto_follow_cursor = true,    -- Auto-follow cursor in chat
                -- default prompts
                prompts = {
                    Docs = {
                        prompt =
                        '/COPILOT_GENERATE Write documentation for the selected code. The reply should be a codeblock containing the original code with the documentation added as comments. Use the most appropriate documentation style for the programming language used (e.g. JSDoc for JavaScript, google-style docstrings for Python etc.',
                    },
                },
                -- default window options
                window = {
                    layout = 'vertical', -- 'vertical', 'horizontal', 'float'
                    width = 0.33,    -- Width of the window
                },

                mappings = {
                    complete = {
                        insert = '',
                    },
                    reset = {
                        normal = 'gr'
                    },
                    accept_diff = {
                        normal = 'ga',
                    },
                }
            }
        end,
        event = "VeryLazy",
        keys = {
            {
                "<leader>ah",
                function()
                    local actions = require("CopilotChat.actions")
                    require("CopilotChat.integrations.telescope").pick(actions.help_actions())
                end,
                desc = "CopilotChat - Help actions",
            },
            -- Show prompts actions with telescope
            {
                "<leader>aa",
                function()
                    local actions = require("CopilotChat.actions")
                    require("CopilotChat.integrations.telescope").pick(actions.prompt_actions())
                end,
                desc = "CopilotChat - Prompt actions",
            },
            {
                "<leader>ab",
                function()
                    require("CopilotChat").toggle({ selection = require("CopilotChat.select").buffer })
                end,
                desc = "CopilotChat - buffer",
            },
            {
                "<leader>as",
                function()
                    require("CopilotChat").toggle()
                end,
                desc = "CopilotChat - selection / current line",
            },
            {
                "<leader>aq",
                function()
                    local input = vim.fn.input("Chat: ")
                    if input ~= "" then
                        vim.cmd("CopilotChat " .. input)
                    end
                end,
                desc = "CopilotChat - Ask with no context",
            },
            {
                "<leader>al",
                function()
                    vim.fn.setreg("C", require("CopilotChat").response(), { "l" })
                end,
                desc = "CopilotChat - Yank last response to \"C",
            },
            { "<leader>at", "<cmd>CopilotChatToggle<cr>", desc = "CopilotChat - Toggle window" },
        },
    },
}
