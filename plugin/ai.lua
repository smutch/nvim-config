-- TODO: Replace sidekick with opencode.nvim
local gh = require("load").gh

require("load").on_event("InsertEnter", function()
    ---@diagnostic disable-next-line: unused-local
    local rc, system = pcall(require, "system")
    vim.pack.add(gh({ "zbirenbaum/copilot.lua" }))

    require("copilot").setup({
        filetypes = {
            csv = false,
            tsv = false,
            json = false,
            jsonl = false,
            ["*"] = true,
        },
        copilot_node_command = vim.g.node_host_prog,
        suggestion = {
            enabled = true,
            auto_trigger = true,
        },
        panel = { enabled = true },
        ---@diagnostic disable-next-line: unused-local
        should_attach = function(_, bufname)
            if system.enable_copilot then
                return true
            end
            return false
        end,
    })
end)

require("load").later(function()
    local deps = {
        "nvim-lua/plenary.nvim",
        "ravitemer/codecompanion-history.nvim",
    }
    vim.pack.add(gh(vim.list_extend(deps, { "olimorris/codecompanion.nvim" })))

    require("codecompanion").setup({
        interactions = {
            -- cli = {
            --     agent = "pi",
            --     agents = {
            --         pi = {
            --             cmd = "just",
            --             args = { "-f", "/Users/smutch/play/containers/pi/Justfile", "run" },
            --             description = "Pi",
            --             provider = "terminal",
            --         },
            --     },
            -- },
            chat = {
                adapter = "opencode_go",
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
                adapter = "opencode_go",
                -- keymaps = {
                --     accept_change = {
                --         modes = { n = "ga" },
                --         description = "Accept the suggested change",
                --     },
                --     reject_change = {
                --         modes = { n = "gr" },
                --         description = "Reject the suggested change",
                --     },
                -- },
            },
            cmd = {
                adapter = "opencode_go",
            },
        },
        extensions = {
            history = {
                enabled = true,
                picker = "snacks",
            },
        },
        adapters = {
            http = {
                copilot = function()
                    return require("codecompanion.adapters").extend("copilot", {
                        schema = {
                            model = {
                                default = "gpt-5-mini",
                            },
                        },
                    })
                end,
                opencode_go = function()
                    return require("codecompanion.adapters").extend("openai_compatible", {
                        name = "OpenCode Go",
                        env = {
                            url = "https://opencode.ai",
                            api_key = require("system").openai_api_key or nil,
                            chat_url = "/zen/go/v1/chat/completions",
                        },
                        schema = {
                            model = {
                                default = "deepseek-v4-flash", -- Change this to a specific model included in your Go subscription
                                choices = {
                                    "deepseek-v4-flash",
                                    "kimi-k2.6",
                                    "glm-5.2",
                                    "mimo-v2.5",
                                    -- Add any other models supported by OpenCode Go
                                },
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

    vim.keymap.set({ "n", "v" }, "<leader>ca", "<cmd>CodeCompanionActions<cr>", { desc = "Code Companion (a)ctions" })
    vim.keymap.set({ "n", "v" }, "<leader>cc", "<cmd>CodeCompanionChat Toggle<cr>", { desc = "Toggle Code Companion" })
    vim.keymap.set("v", "<leader>ct", "<cmd>CodeCompanionChat Add<cr>", { desc = "Add (t)his to Code Companion chat" })

    -- vim.keymap.set({ "n", "v" }, "<LocalLeader>cp", function()
    --     return require("codecompanion").cli({ prompt = true })
    -- end, { desc = "Prompt the CLI agent" })
    -- vim.keymap.set({ "n", "v" }, "<LocalLeader>ca", function()
    --     return require("codecompanion").cli("#{this}", { focus = false })
    -- end, { desc = "Add context to the CLI agent" })
    -- vim.keymap.set("n", "<LocalLeader>cd", function()
    --     return require("codecompanion").cli("#{diagnostics} Can you fix these?", { focus = false, submit = true })
    -- end, { desc = "Send diagnostics to CLI agent" })
    -- vim.keymap.set("n", "<LocalLeader>ct", function()
    --     return require("codecompanion").cli(
    --         "#{terminal} Sharing the output from the terminal. Can you fix it?",
    --         { focus = false, submit = true }
    --     )
    -- end, { desc = "Send terminal output to CLI agent" })

    vim.cmd([[cab cc CodeCompanion]])
end)
