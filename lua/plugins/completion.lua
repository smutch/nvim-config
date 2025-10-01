return {
    {
        "saghen/blink.cmp",
        lazy = false, -- lazy loading handled internally
        -- optional: provides snippets for the snippet source
        dependencies = { "rafamadriz/friendly-snippets", "echasnovski/mini.icons", "Kaiser-Yang/blink-cmp-git" },

        -- use a release tag to download pre-built binaries
        version = "v0.*",

        opts = {
            -- 'default' for mappings similar to built-in completion
            -- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
            -- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
            -- see the "default configuration" section below for full documentation on how to define
            -- your own keymap.
            keymap = {
                ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
                ["<C-e>"] = { "hide", "fallback" },
                ["<Tab>"] = {
                    "select_next",
                    "fallback",
                },
                ["<M-j>"] = {
                    "snippet_forward",
                    function(cmp)
                        cmp.show_and_insert({ providers = { "snippets" } })
                    end,
                    "fallback",
                },
                ["<M-k>"] = { "snippet_backward", "fallback" },
                ["<CR>"] = { "accept", "fallback" },
                ["<S-Tab>"] = { "select_prev", "fallback" },
                ["<Up>"] = { "select_prev", "fallback" },
                ["<Down>"] = { "select_next", "fallback" },
                ["<C-b>"] = { "scroll_documentation_up", "fallback" },
                ["<C-f>"] = { "scroll_documentation_down", "fallback" },
            },

            sources = {
                default = { "lazydev", "git", "lsp", "path", "snippets", "buffer" },
                providers = {
                    lazydev = {
                        name = "LazyDev",
                        module = "lazydev.integrations.blink",
                        -- make lazydev completions top priority (see `:h blink.cmp`)
                        score_offset = 100,
                    },
                    snippets = {
                        opts = {
                            search_paths = { vim.fn.stdpath("config") .. "/snippets" },
                        },
                    },
                    git = {
                        module = "blink-cmp-git",
                        name = "Git",
                        opts = {
                            -- options for the blink-cmp-git
                        },
                    },
                },
                per_filetype = {
                    codecompanion = { "codecompanion" },
                },
            },

            -- experimental
            -- signature = { enabled = true },

            completion = {
                list = {
                    selection = {
                        preselect = false,
                        auto_insert = false,
                    },
                },
                documentation = { auto_show = true, auto_show_delay_ms = 500 },
                menu = {
                    draw = {
                        components = {
                            kind_icon = {
                                text = function(ctx)
                                    local kind_icon, _, _ = require("mini.icons").get("lsp", ctx.kind)
                                    return kind_icon
                                end,
                            },
                        },
                    },
                },
            },
        },
    },
}
