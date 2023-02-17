return {
     { 'hrsh7th/cmp-nvim-lsp' },
     { 'hrsh7th/cmp-buffer' },
     { 'Saecki/crates.nvim', config = true },
     { 'hrsh7th/cmp-path' },
     { 'hrsh7th/cmp-nvim-lua' },
     { 'kdheepak/cmp-latex-symbols' },
     { 'f3fora/cmp-spell' },
     { 'hrsh7th/cmp-calc' },
     { 'ray-x/cmp-treesitter' },
     { 'hrsh7th/cmp-emoji' },
     { 'hrsh7th/cmp-omni' },
     { 'hrsh7th/cmp-cmdline' },
     { 'lukas-reineke/cmp-under-comparator' },
     { 'saadparwaiz1/cmp_luasnip' },

     {
        "zbirenbaum/copilot.lua",
        event = { "VimEnter" },
        config = function()
            vim.defer_fn(function()
                require("copilot").setup({
                    filetypes = {
                        ["*"] = false -- disable for all non-listed filetypes in this table
                    }
                })
            end, 100)
        end
    },
    { "zbirenbaum/copilot-cmp", config = true },

    {
        "dense-analysis/neural",
        config = function()
            require('neural').setup({
                open_ai = {
                    api_key = require"system".openai_api_key
                },
            })
        end,
        depends = {
            'MunifTanjim/nui.nvim',
            'ElPiloto/significant.nvim'
        },
        cmd = 'NeuralPrompt'
    },

    {
        'hrsh7th/nvim-cmp',
        config = function()
            vim.o.completeopt = 'menu,menuone,noselect'
            local cmp = require 'cmp'

            local has_words_before = function()
                local line, col = unpack(vim.api.nvim_win_get_cursor(0))
                return col ~= 0 and
                vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") ==
                nil
            end

            local default_sources = {
                { name = 'calc', group_index = 1  },
                { name = 'path', group_index = 1  },
                { name = 'nvim_lsp', group_index = 1  },
                { name = 'luasnip', group_index = 1  },
                { name = 'treesitter', group_index = 1  },
                { name = 'emoji', group_index = 2  },
                { name = 'buffer', keyword_length = 5, group_index = 2 },
                { name = 'copilot', group_index = 1  },
            }

            cmp.setup({
                snippet = { expand = function(args)
                    require('luasnip').lsp_expand(args.body)
                end },
                mapping = {
                    ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
                    ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
                    ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
                    ['<C-e>'] = cmp.mapping({ i = cmp.mapping.abort(), c = cmp.mapping.close() }),
                    ['<CR>'] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false }),

                    ['<Down>'] = cmp.mapping(cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }), {'i'}),
                    ['<Up>'] = cmp.mapping(cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }), {'i'}),

                    ["<Tab>"] = cmp.mapping(function(fallback)
                        local luasnip = require 'luasnip'
                        if cmp.visible() then
                            cmp.select_next_item()
                        elseif luasnip.expandable() then
                            luasnip.expand()
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
                    end, { "i", "s" })
                },
                sources = default_sources,
                formatting = { format = require 'lspkind'.cmp_format({ with_text = true, maxwidth = 50 }) },
                experimental = { native_menu = false, ghost_text = true },
                sorting = {
                    comparators = {
                        cmp.config.compare.offset, cmp.config.compare.exact, cmp.config.compare.score,
                        require "cmp-under-comparator".under, cmp.config.compare.kind,
                        cmp.config.compare.sort_text, cmp.config.compare.length, cmp.config.compare.order
                    }
                }
            })

            -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
            cmp.setup.cmdline('/', { mapping = cmp.mapping.preset.cmdline(), sources = { { name = 'buffer' } } })

            -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
            cmp.setup.cmdline(':', {
                mapping = cmp.mapping.preset.cmdline(),
                sources = cmp.config.sources({ { name = 'path' } }, { { name = 'cmdline' } })
            })

            local cmp_autopairs = require 'nvim-autopairs.completion.cmp'
            cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done({ map_char = { tex = '{' } }))

            local augrp = vim.api.nvim_create_augroup("Projects", {})
            vim.api.nvim_create_autocmd("FileType", {
                group = augrp,
                pattern = { "lua" },
                callback = function()
                    local sources = { { name = 'nvim_lua', group_index = 1 } }
                    vim.list_extend(sources, default_sources)
                    cmp.setup.buffer { sources = sources }
                end
            })
            vim.api.nvim_create_autocmd("FileType", {
                group = augrp,
                pattern = { "toml" },
                callback = function()
                    local sources = { { name = 'crates', group_index = 1 } }
                    vim.list_extend(sources, default_sources)
                    cmp.setup.buffer { sources = sources }
                end
            })
            vim.api.nvim_create_autocmd("FileType", {
                group = augrp,
                pattern = { "tex" },
                callback = function()
                    local sources = { { name = 'omni', group_index = 1 } , { name = 'latex_symbols', group_index = 1 } }
                    vim.list_extend(sources, default_sources)
                    cmp.setup.buffer { sources = sources }
                end
            })
        end
    },
}
