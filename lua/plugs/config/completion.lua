local cmp = require("blink.cmp")
local luasnip = require("luasnip")

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
        nerd_font_variant = "mono",
    },

    snippets = {
        expand = function(snippet)
            luasnip.lsp_expand(snippet)
        end,
        active = function(filter)
            if filter and filter.direction then
                return luasnip.jumpable(filter.direction)
            end
            return luasnip.in_snippet()
        end,
        jump = function(direction)
            luasnip.jump(direction)
        end,
    },

    sources = {
        default = { "lsp", "path", "luasnip", "buffer" },
    },

    -- experimental
    -- signature = { enabled = true },
    completion = {
        accept = {
            -- experimental
            auto_brackets = { enabled = true },
        },
        list = { selection = "auto_insert" },
    },

    -- allows extending the providers array elsewhere in your config
    -- without having to redefine it
    opts_extend = { "sources.default" },
})
