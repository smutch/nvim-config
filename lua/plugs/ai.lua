return {
    {
        "zbirenbaum/copilot.lua",
        event = { "InsertEnter" },
        enabled = function()
            return require("system").enable_copilot or false and true
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
            return require("system").enable_copilot or false and true
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
            "hrsh7th/nvim-cmp", -- Optional: For using slash commands and variables in the chat buffer
            "nvim-telescope/telescope.nvim", -- Optional: For using slash commands
            { "stevearc/dressing.nvim", opts = {} }, -- Optional: Improves `vim.ui.select`
        },
        init = function()
            vim.cmd([[cab cc CodeCompanion]])
        end,
        opts = {
            strategies = {
                chat = {
                    adapter = "copilot",
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
                                default = "claude-3.7-sonnet",
                            },
                        },
                    })
                end,
            },
        },
        keys = {
            { "<M-c>", "<cmd>CodeCompanionActions<cr>", mode = { "n", "v" } },
            { "<LocalLeader>c", "<cmd>CodeCompanionChat Toggle<cr>", mode = { "n", "v" } },
            { "<LocalLeader>a", "<cmd>CodeCompanionChat Add<cr>", mode = "v" },
        },
    },
}
