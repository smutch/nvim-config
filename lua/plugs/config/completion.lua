vim.opt.completeopt = { "menu", "menuone", "noselect" }
vim.opt.shortmess:append("c")

local lspkind = require("lspkind")

local cmp = require("cmp")

local has_words_before = function()
    if vim.api.nvim_get_option_value("buftype", { buf = 0 }) == "prompt" then
        return false
    end
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]:match("^%s*$") == nil
end

local common_sources = {
    { name = "path" },
    { name = "nvim_lsp" },
    { name = "lazydev", group = 0 },
    { name = "conjure" },
    { name = "otter" },
    { name = "luasnip" },
    { name = "treesitter" },
    { name = "buffer", keyword_length = 5 },
}

cmp.setup({ ---@diagnostic disable-line: redundant-parameter
    snippet = {
        expand = function(args)
            require("luasnip").lsp_expand(args.body)
        end,
    },
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
    mapping = {
        ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-4)),
        ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4)),
        ["<C-Space>"] = cmp.mapping(cmp.mapping.complete()),
        ["<C-e>"] = cmp.mapping.abort(),

        ["<CR>"] = cmp.mapping(function(fallback)
            if cmp.visible() and cmp.get_active_entry() then
                cmp.confirm()
            else
                fallback()
            end
        end),

        ["<Down>"] = cmp.mapping(cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }), { "i" }),
        ["<Up>"] = cmp.mapping(cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }), { "i" }),

        ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
            elseif has_words_before() then
                cmp.complete()
            else
                fallback()
            end
        end, { "i", "s" }),

        ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            else
                fallback()
            end
        end, { "i", "s" }),
    },
    sources = common_sources,
    experimental = { native_menu = false, ghost_text = false },
    sorting = {
        priority_weight = 2,
        comparators = {
            cmp.config.compare.offset,
            cmp.config.compare.exact,
            cmp.config.compare.score,
            cmp.config.compare.recently_used,
            cmp.config.compare.locality,
            require("cmp-under-comparator").under,
            cmp.config.compare.kind,
            cmp.config.compare.sort_text,
            cmp.config.compare.length,
            cmp.config.compare.order,
        },
    },
    formatting = { ---@diagnostic disable-line: missing-fields
        format = lspkind.cmp_format({}),
    },
})

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline("/", { mapping = cmp.mapping.preset.cmdline(), sources = { { name = "buffer" } } })

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(":", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources(
        { { name = "path" } },
        { { name = "cmdline" }, matching = { disallow_symbol_nonprefix_matching = false } }
    ),
})

local augrp = vim.api.nvim_create_augroup("Completion", {})
vim.api.nvim_create_autocmd("FileType", {
    group = augrp,
    pattern = { "lua" },
    callback = function()
        local sources = { { name = "nvim_lua" } }
        vim.list_extend(sources, common_sources)
        cmp.setup.buffer({ sources = sources })
    end,
})
vim.api.nvim_create_autocmd("FileType", {
    group = augrp,
    pattern = { "toml" },
    callback = function()
        local sources = { { name = "crates" } }
        vim.list_extend(sources, common_sources)
        cmp.setup.buffer({ sources = sources })
    end,
})
vim.api.nvim_create_autocmd("FileType", {
    group = augrp,
    pattern = { "tex" },
    callback = function()
        local sources = { { name = "omni" }, { name = "latex_symbols" } }
        vim.list_extend(sources, common_sources)
        cmp.setup.buffer({ sources = sources })
    end,
})
