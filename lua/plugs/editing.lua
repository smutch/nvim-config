return {
    {
        'windwp/nvim-autopairs',
        config = function()
            local autopairs = require 'nvim-autopairs'
            autopairs.setup {
                disable_filetype = { "TelescopePrompt", "vim", "clojure", "fennel", "racket", "janet" }
            }
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
    },
    {
        "jake-stewart/multicursor.nvim",
        branch = "1.0",
        config = function()
            local mc = require("multicursor-nvim")

            mc.setup()

            local set = vim.keymap.set

            -- Add or skip cursor above/below the main cursor.
            set({ "n", "v" }, "<S-up>", function() mc.lineAddCursor(-1) end)
            set({ "n", "v" }, "<S-down>", function() mc.lineAddCursor(1) end)
            set({ "n", "v" }, "<up>", function() mc.lineSkipCursor(-1) end)
            set({ "n", "v" }, "<down>", function() mc.lineSkipCursor(1) end)

            -- Add or skip adding a new cursor by matching word/selection
            set({ "n", "v" }, "<M-d>", function() mc.matchAddCursor(1) end)
            set({ "n", "v" }, "<M-s>", function() mc.matchSkipCursor(1) end)
            set({ "n", "v" }, "<M-D>", function() mc.matchAddCursor(-1) end)
            set({ "n", "v" }, "<M-S>", function() mc.matchSkipCursor(-1) end)

            -- You can also add cursors with any motion you prefer:
            -- set("n", "<right>", function()
            --     mc.addCursor("w")
            -- end)
            -- set("n", "<leader><right>", function()
            --     mc.skipCursor("w")
            -- end)

            -- Rotate the main cursor.
            set({ "n", "v" }, "<S-left>", mc.nextCursor)
            set({ "n", "v" }, "<S-right>", mc.prevCursor)

            -- Delete the main cursor.
            set({ "n", "v" }, "<S-x>", mc.deleteCursor)

            -- Add and remove cursors with control + left click.
            set("n", "<c-leftmouse>", mc.handleMouse)

            set({ "n", "v" }, "<c-q>", function()
                if mc.cursorsEnabled() then
                    -- Stop other cursors from moving.
                    -- This allows you to reposition the main cursor.
                    mc.disableCursors()
                else
                    mc.addCursor()
                end
            end)

            -- -- clone every cursor and disable the originals
            -- set({"n", "v"}, "<leader><c-q>", mc.duplicateCursors)

            set("n", "<esc>", function()
                if not mc.cursorsEnabled() then
                    mc.enableCursors()
                elseif mc.hasCursors() then
                    mc.clearCursors()
                else
                    -- Default <esc> handler.
                end
            end)

            -- Align cursor columns.
            set("v", "<leader>a", mc.alignCursors)

            -- Split visual selections by regex.
            -- set("v", "S", mc.splitCursors)

            -- Append/insert for each line of visual selections.
            set("v", "I", mc.insertVisual)
            set("v", "A", mc.appendVisual)

            -- match new cursors within visual selections by regex.
            set("v", "M", mc.matchCursors)

            -- -- Rotate visual selection contents.
            -- set("v", "<leader>{",
            --     function() mc.transposeCursors(-1) end)
            -- set("v", "<leader>}",
            --     function() mc.transposeCursors(1) end)

            -- Customize how cursors look.
            local hl = vim.api.nvim_set_hl
            hl(0  , "MultiCursorCursor"          , { link = "Cursor" })
            hl(0  , "MultiCursorVisual"          , { link = "Visual" })
            hl(0  , "MultiCursorSign"            , { link = "SignColumn" })
            hl(0  , "MultiCursorDisabledCursor"  , { link = "Visual" })
            hl(0  , "MultiCursorDisabledVisual"  , { link = "Visual" })
            hl(0  , "MultiCursorDisabledSign"    , { link = "SignColumn" })
        end
    }
}
