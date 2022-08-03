local M = {}

function M.config()
    vim.o.completeopt = 'menu,menuone,noselect'
    local cmp = require 'cmp'

    local has_words_before = function()
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and
        vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") ==
        nil
    end

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
        sources = cmp.config.sources({
            { name = 'calc' }, { name = 'path' }, { name = 'nvim_lsp' }, { name = 'luasnip' },
            { name = 'treesitter' }, { name = 'emoji' }, { name = 'buffer', keyword_length = 5 }
        }),
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

        vim.cmd(
        [[autocmd FileType lua lua require'cmp'.setup.buffer {sources = { { name = 'nvim_lua' } } }]])
        vim.cmd([[autocmd FileType toml lua require'cmp'.setup.buffer {sources = { { name = 'crates' } } }]])
        vim.cmd(
        [[autocmd FileType tex lua require'cmp'.setup.buffer {sources = { { name = 'omni' } }, { name = 'latex_symbols'} }]])

        vim.cmd [[autocmd CursorHold,CursorHoldI * lua require'nvim-lightbulb'.update_lightbulb()]]
        vim.fn.sign_define('LightBulbSign', { text = "ﯧ", texthl = "", linehl = "", numhl = "" })

        vim.cmd(
        [[autocmd InsertLeave,BufEnter,BufWinEnter,TabEnter,BufWritePost *.rs :lua require'lsp_extensions'.inlay_hints{ prefix = ' 﫢 ', highlight = "NonText", only_current_line = true, enabled = {"TypeHint", "ChainingHint", "ParameterHint"}}]])
end

return M
