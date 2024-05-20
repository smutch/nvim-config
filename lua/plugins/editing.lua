return {
    {
        'windwp/nvim-autopairs',
        config = function()
            local autopairs = require 'nvim-autopairs'
            local cond = require 'nvim-autopairs.conds'
            autopairs.setup {}
            -- autopairs.get_rule('"'):with_pair(cond.not_before_regex('"', 1))
        end
    },
    { 'tpope/vim-rsi' },
    {
        "folke/flash.nvim",
        event = "VeryLazy",
        ---@type Flash.Config
        opts = {
            modes = {
                search = { enabled = false }
            }
        },
        keys = {
            {
                "s",
                mode = { "n", "x", "o" },
                function()
                    require("flash").jump()
                end,
                desc = "Flash",
            },
            {
                "S",
                mode = { "n" },
                function()
                    require("flash").treesitter()
                end,
                desc = "Flash Treesitter",
            },
            {
                "|",
                mode = { "o", "x" },
                function()
                    require("flash").treesitter()
                end,
                desc = "Flash Treesitter",
            },
            {
                "r",
                mode = "o",
                function()
                    require("flash").remote()
                end,
                desc = "Remote Flash",
            },
            {
                "R",
                mode = { "o", "x" },
                function()
                    require("flash").treesitter_search()
                end,
                desc = "Flash Treesitter Search",
            },
            {
                "<c-s>",
                mode = { "c" },
                function()
                    require("flash").toggle()
                end,
                desc = "Toggle Flash Search",
            },
        },
    },
    { 'tpope/vim-repeat' },
    {
        'numToStr/Comment.nvim',
        config = function()
            local utils = require("Comment.utils")
            local api = require("Comment.api")
            local map = vim.keymap.set

            require('Comment').setup { ignore = '^$' }

            vim.api.nvim_set_keymap('n', '<leader><leader>', 'gcc', { desc = 'Toggle comments linewise' })
            vim.api.nvim_set_keymap('v', '<leader><leader>', 'gc', { desc = 'Toggle comments in selection' })

            -- extended mappings (https://github.com/numToStr/Comment.nvim/wiki/Extended-Keybindings)
            map('n', 'g>', api.call('comment.linewise', 'g@'), { expr = true, desc = 'Comment region linewise' })
            map('n', 'g>c', api.call('comment.linewise.current', 'g@$'), { expr = true, desc = 'Comment current line' })
            map('n', 'g>b', api.call('comment.blockwise.current', 'g@$'), { expr = true, desc = 'Comment current block' })

            map('n', 'g<', api.call('uncomment.linewise', 'g@'), { expr = true, desc = 'Uncomment region linewise' })
            map('n', 'g<c', api.call('uncomment.linewise.current', 'g@$'),
                { expr = true, desc = 'Uncomment current line' })
            map('n', 'g<b', api.call('uncomment.blockwise.current', 'g@$'),
                { expr = true, desc = 'Uncomment current block' })

            local esc = vim.api.nvim_replace_termcodes('<ESC>', true, false, true)

            map('x', 'g>', function()
                vim.api.nvim_feedkeys(esc, 'nx', false)
                api.locked('comment.linewise')(vim.fn.visualmode())
            end, { desc = 'Comment region linewise (visual)' })

            map('x', 'g<', function()
                vim.api.nvim_feedkeys(esc, 'nx', false)
                api.locked('uncomment.linewise')(vim.fn.visualmode())
            end, { desc = 'Uncomment region linewise (visual)' })
        end
    },
    {
        'echasnovski/mini.align',
        config = function()
            require('mini.align').setup({
                mappings = {
                    start = 'gA',
                    start_with_preview = '1gA',
                },
            })
        end
    },
    { 'michaeljsmith/vim-indent-object' },
    { 'tpope/vim-surround' },
    { 'jeffkreeftmeijer/vim-numbertoggle' },
    { 'chrisbra/unicode.vim' },
    { 'wellle/targets.vim' },
    { 'NMAC427/guess-indent.nvim',        opts = {} },
    { 'andymass/vim-matchup',             opts = {} },
    {
        'Wansmer/treesj',
        dependencies = { 'nvim-treesitter/nvim-treesitter' },
        opts = { use_default_keymaps = false, },
        keys = { { '<leader>j', function() require('treesj').toggle() end, desc = "toggle join/merge" } },
    }
}
