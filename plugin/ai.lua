-- TODO: Replace sidekick with opencode.nvim
local gh = require("load").gh

require("load").on_event("InsertEnter", function()
    local rc, system = pcall(require, "system")
    if rc and system.enable_copilot then
        vim.pack.add(gh({ "zbirenbaum/copilot.lua" }))

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
    end
end)

require("load").later(function()
    local deps = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
        "ravitemer/codecompanion-history.nvim",
        -- "ravitemer/mcphub.nvim",
    }
    vim.pack.add(gh(vim.list_extend(deps, { "olimorris/codecompanion.nvim" })))

    require("codecompanion").setup({
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
            -- inline = {
            --     adapter = "copilot",
            --     keymaps = {
            --         accept_change = {
            --             modes = { n = "ga" },
            --             description = "Accept the suggested change",
            --         },
            --         reject_change = {
            --             modes = { n = "gr" },
            --             description = "Reject the suggested change",
            --         },
            --     },
            -- },
            cmd = {
                adapter = "copilot",
            },
        },
        extensions = {
            -- mcphub = {
            --     callback = "mcphub.extensions.codecompanion",
            --     opts = {
            --         show_result_in_chat = true, -- Show the mcp tool result in the chat buffer
            --         make_vars = true, -- make chat #variables from MCP server resources
            --         make_slash_commands = true, -- make /slash_commands from MCP server prompts
            --     },
            -- },
            history = {
                enabled = true,
                picker = "snacks",
            },
        },
        adapters = {
            http = {
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
                                default = "gpt-5-mini",
                            },
                        },
                    })
                end,
            },
        },
        display = {
            chat = {
                window = {
                    layout = "vertical",
                    position = "right",
                },
            },
        },
    })

    vim.keymap.set({ "n", "v" }, "<M-c>", "<cmd>CodeCompanionActions<cr>", { desc = "Code Companion actions" })
    vim.keymap.set(
        { "n", "v" },
        "<localleader>c",
        "<cmd>CodeCompanionChat Toggle<cr>",
        { desc = "Toggle Code Companion" }
    )
    vim.keymap.set("v", "<localleader>a", "<cmd>CodeCompanionChat Add<cr>", { desc = "Add to Code Companion chat" })

    vim.cmd([[cab cc CodeCompanion]])
end)
