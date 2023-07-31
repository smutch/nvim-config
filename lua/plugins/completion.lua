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
        event = { "InsertEnter" },
        config = function()
            local enable = require"system".enable_copilot
            if enable == nil then enable = false end
            require("copilot").setup({
                filetypes = {
                    ["*"] = enable
                },
                copilot_node_command = vim.g.node_host_prog,
                suggestion = { enabled = false },
                panel = { enabled = false },
            })
        end
    },
    -- {
    --     'huggingface/hfcc.nvim',
    --     opts = {
    --         api_token = require"system".hf_api_token,
    --         model = "bigcode/starcoder", -- can be a model ID or an http endpoint
    --     }
    -- },
    { "zbirenbaum/copilot-cmp", config = true },
    {
        -- 'hrsh7th/nvim-cmp',

        -- TODO: Temporary fix for ghost text
        -- https://github.com/hrsh7th/nvim-cmp/issues/1565
        'soifou/nvim-cmp',
        branch = 'ghost-text-fix',

        config = function()
            vim.o.completeopt = 'menu,menuone,noselect'
            local cmp = require 'cmp'

            local has_words_before = function()
                if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then return false end
                local line, col = unpack(vim.api.nvim_win_get_cursor(0))
                return col ~= 0 and vim.api.nvim_buf_get_text(0, line-1, 0, line-1, col, {})[1]:match("^%s*$") == nil
            end

            local default_sources = {
                { name = 'path', group_index = 1  },
                { name = 'nvim_lsp', group_index = 1  },
                { name = 'luasnip', group_index = 1  },
                { name = 'treesitter', group_index = 1  },
                { name = 'copilot', group_index = 1  },
                -- { name = 'calc', group_index = 2  },
                -- { name = 'emoji', group_index = 2  },
                { name = 'buffer', keyword_length = 5, group_index = 1 },
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
                formatting = {
                    format = require 'lspkind'.cmp_format(
                        {
                            mode = 'symbol_text',
                            maxwidth = 50,
                            symbol_map = { Copilot = "" }
                        }
                    )
                },
                experimental = { native_menu = false, ghost_text = true },
                sorting = {
                    priority_weight = 2,
                    comparators = {
                        cmp.config.compare.offset,
                        -- cmp.config.compare.scopes, --this is commented in nvim-cmp too
                        cmp.config.compare.exact,
                        require("copilot_cmp.comparators").prioritize,
                        cmp.config.compare.score,
                        cmp.config.compare.recently_used,
                        cmp.config.compare.locality,
                        require "cmp-under-comparator".under,
                        cmp.config.compare.kind,
                        cmp.config.compare.sort_text,
                        cmp.config.compare.length,
                        cmp.config.compare.order,
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
