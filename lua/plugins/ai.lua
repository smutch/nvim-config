return {
    {
        "zbirenbaum/copilot.lua",
        event = { "InsertEnter" },
        enabled = function()
            local rc, system = pcall(require, "system")
            if rc then
                return system.enable_copilot or false and true
            else
                return false
            end
        end,
        config = function()
            require("copilot").setup({
                filetypes = {
                    ["*"] = true,
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
            "ravitemer/codecompanion-history.nvim",
            "ravitemer/mcphub.nvim",
        },
        init = function()
            vim.cmd([[cab cc CodeCompanion]])
        end,
        opts = {
            strategies = {
                chat = {
                    adapter = "copilot",
                    tools = {
                        groups = {
                            ["search_and_read"] = {
                                description = "Access buffer, grep, and read files",
                                tools = {
                                    "buffer",
                                    "grep_search",
                                    "read_file",
                                },
                                opts = {
                                    collapse_tools = true, -- When true, show as a single group reference instead of individual tools
                                },
                            },
                        },
                    },
                },
                inline = {
                    adapter = "copilot",
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
                cmd = {
                    adapter = "copilot",
                },
            },
            extensions = {
                mcphub = {
                    callback = "mcphub.extensions.codecompanion",
                    opts = {
                        show_result_in_chat = true, -- Show the mcp tool result in the chat buffer
                        make_vars = true, -- make chat #variables from MCP server resources
                        make_slash_commands = true, -- make /slash_commands from MCP server prompts
                    },
                },
                history = {
                    enabled = true,
                    picker = "snacks",
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
                copilot = function()
                    return require("codecompanion.adapters").extend("copilot", {
                        schema = {
                            model = {
                                default = "claude-sonnet-4",
                            },
                        },
                    })
                end,
            },
            display = {
                chat = {
                    window = {
                        layout = "vertical",
                        position = "right",
                    },
                },
            },
        },
        keys = {
            { "<M-c>", "<cmd>CodeCompanionActions<cr>", mode = { "n", "v" } },
            { "<LocalLeader>c", "<cmd>CodeCompanionChat Toggle<cr>", mode = { "n", "v" } },
            { "<LocalLeader>a", "<cmd>CodeCompanionChat Add<cr>", mode = "v" },
        },
    },
    {
        "ravitemer/mcphub.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim", -- Required for Job and HTTP requests
        },
        cmd = "MCPHub", -- lazy load
        build = "npm install -g mcp-hub@latest", -- Installs required mcp-hub npm module
        opts = {},
    },
}
