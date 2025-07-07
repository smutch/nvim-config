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
        "copilotlsp-nvim/copilot-lsp",
        enabled = function()
            local rc, system = pcall(require, "system")
            if rc then
                return system.enable_copilot or false and true
            else
                return false
            end
        end,
        init = function()
            vim.g.copilot_nes_debounce = 500
            -- c.f. https://github.com/copilotlsp-nvim/copilot-lsp/issues/8#issuecomment-2822027212
            vim.lsp.config("copilot_ls", {
                on_init = function(client)
                    vim.api.nvim_set_hl(0, "NesAdd", { link = "DiffAdd", default = true })
                    vim.api.nvim_set_hl(0, "NesDelete", { link = "DiffDelete", default = true })
                    vim.api.nvim_set_hl(0, "NesApply", { link = "DiffText", default = true })

                    local au = vim.api.nvim_create_augroup("copilot-language-server", { clear = true })

                    --NOTE: didFocus
                    vim.api.nvim_create_autocmd("BufEnter", {
                        callback = function()
                            local td_params = vim.lsp.util.make_text_document_params()
                            client:notify("textDocument/didFocus", {
                                textDocument = {
                                    uri = td_params.uri,
                                },
                            })
                        end,
                        group = au,
                    })

                    vim.keymap.set("n", "<tab>", function()
                        local state = vim.b[vim.api.nvim_get_current_buf()].nes_state
                        if not state then
                            require("copilot-lsp.nes").request_nes(client)
                            vim.notify("Requesting Copilot LSP suggestions...")
                        else
                            local _ = require("copilot-lsp.nes").apply_pending_nes()
                                and require("copilot-lsp.nes").walk_cursor_end_edit()
                        end
                    end)
                end,
            })
            vim.lsp.enable("copilot_ls")
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
