local cmp = require("blink.cmp")

cmp.setup({
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
        ["<CR>"] = { "accept", "fallback" },
        ["<S-Tab>"] = { "select_prev", "fallback" },
        ["<Up>"] = { "select_prev", "fallback" },
        ["<Down>"] = { "select_next", "fallback" },
        ["<C-b>"] = { "scroll_documentation_up", "fallback" },
        ["<C-f>"] = { "scroll_documentation_down", "fallback" },
    },

    appearance = {
        -- Sets the fallback highlight groups to nvim-cmp's highlight groups
        -- Useful for when your theme doesn't support blink.cmp
        -- will be removed in a future release
        use_nvim_cmp_as_default = true,
    },

    snippets = {
        preset = "luasnip",
    },

    sources = {
        default = { "lazydev", "lsp", "path", "snippets", "copilot", "buffer" },
        providers = {
            copilot = {
                name = "copilot",
                module = "blink-copilot",
                score_offset = 100,
                async = true,
            },
            lazydev = {
                name = "LazyDev",
                module = "lazydev.integrations.blink",
                -- make lazydev completions top priority (see `:h blink.cmp`)
                score_offset = 100,
            },
        },
    },

    -- experimental
    -- signature = { enabled = true },

    completion = {
        list = {
            selection = {
                preselect = false,
                auto_insert = false,
                -- preselect = function(ctx)
                --     return ctx.mode ~= "cmdline"
                -- end,
                -- auto_insert = function(ctx)
                --     return ctx.mode ~= "cmdline"
                -- end,
            },
        },
        documentation = { auto_show = true, auto_show_delay_ms = 500 },
        menu = {
            -- auto_show = function(ctx)
            --     return ctx.mode ~= "cmdline"
            -- end,
            -- nvim-cmp style menu
            draw = {
                columns = {
                    { "label", "label_description", gap = 1 },
                    { "kind_icon", "kind" },
                },
            },
        },
    },
})
