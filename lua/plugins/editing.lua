return {
    { "tpope/vim-rsi" },
    {
        "folke/flash.nvim",
        event = "VeryLazy",
        ---@type Flash.Config
        ---@diagnostic disable-next-line: missing-fields
        opts = {
            modes = {
                search = { enabled = false },
            },
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
    { "tpope/vim-repeat" },
    {
        "numToStr/Comment.nvim",
        config = function()
            ---@diagnostic disable-next-line: missing-fields
            require("Comment").setup({ ignore = "^$" })

            vim.api.nvim_set_keymap("n", "<leader><leader>", "gcc", { desc = "Toggle comments linewise" })
            vim.api.nvim_set_keymap("v", "<leader><leader>", "gc", { desc = "Toggle comments in selection" })
        end,
    },
    {
        "echasnovski/mini.align",
        config = function()
            require("mini.align").setup({
                mappings = {
                    start = "gA",
                    start_with_preview = "1gA",
                },
            })
        end,
    },
    { "michaeljsmith/vim-indent-object" },
    { "tpope/vim-surround" },
    { "jeffkreeftmeijer/vim-numbertoggle" },
    {
        "chrisbra/unicode.vim",
        init = function()
            vim.g.Unicode_no_default_mappings = 1
        end,
    },
    {
        "wellle/targets.vim",
        config = function()
            vim.cmd([[
            autocmd User targets#mappings#user call targets#mappings#extend({
                \ 'B': {},
                \ })
            ]])
        end,
    },
    { "NMAC427/guess-indent.nvim", opts = {} },
    { "andymass/vim-matchup", opts = {} },
    {
        "Wansmer/treesj",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        opts = { use_default_keymaps = false },
        keys = {
            {
                "gj",
                function()
                    require("treesj").toggle()
                end,
                desc = "toggle join/merge",
            },
        },
    },
    {
        "jake-stewart/multicursor.nvim",
        branch = "1.0",
        config = function()
            local mc = require("multicursor-nvim")

            mc.setup()

            local set = vim.keymap.set

            -- Add or skip cursor above/below the main cursor.
            set({ "n", "v" }, "g<up>", function()
                mc.lineAddCursor(-1)
            end, { desc = "Add cursor above" })
            set({ "n", "v" }, "g<down>", function()
                mc.lineAddCursor(1)
            end, { desc = "Add cursor below" })
            set({ "n", "v" }, "g<S-up>", function()
                mc.lineSkipCursor(-1)
            end, { desc = "Skip cursor above" })
            set({ "n", "v" }, "g<S-down>", function()
                mc.lineSkipCursor(1)
            end, { desc = "Skip cursor below" })

            -- Add or skip adding a new cursor by matching word/selection
            set({ "n", "v" }, "<M-d>", function()
                mc.matchAddCursor(1)
            end, { desc = "Add cursor by matching forward" })
            set({ "n", "v" }, "gl", function()
                mc.matchAddCursor(1)
            end, { desc = "Add cursor by matching forward" })
            set({ "n", "v" }, "<M->>", function()
                mc.matchSkipCursor(1)
            end, { desc = "Skip cursor by matching forward" })
            set({ "n", "v" }, "g>", function()
                mc.matchSkipCursor(1)
            end, { desc = "Skip cursor by matching forward" })
            set({ "n", "v" }, "<M-S-d>", function()
                mc.matchAddCursor(-1)
            end, { desc = "Add cursor by matching backwards" })
            set({ "n", "v" }, "gL", function()
                mc.matchAddCursor(-1)
            end, { desc = "Add cursor by matching backwards" })
            set({ "n", "v" }, "<M-<>", function()
                mc.matchSkipCursor(-1)
            end, { desc = "Skip cursor by matching backwards" })
            set({ "n", "v" }, "g<", function()
                mc.matchSkipCursor(-1)
            end, { desc = "Skip cursor by matching backwards" })
            set({ "n", "v" }, "<M-*>", function()
                mc.matchAllAddCursors()
            end, { desc = "Add all cursors by matching" })
            set({ "n", "v" }, "ga", function()
                mc.matchAllAddCursors()
            end, { desc = "Add all cursors by matching" })

            -- You can also add cursors with any motion you prefer:
            -- set("n", "<right>", function()
            --     mc.addCursor("w")
            -- end)
            -- set("n", "<leader><right>", function()
            --     mc.skipCursor("w")
            -- end)

            -- Rotate the main cursor.
            set({ "n", "v" }, "g<left>", mc.nextCursor, { desc = "Rotate main cursor left" })
            set({ "n", "v" }, "g<right>", mc.prevCursor, { desc = "Rotate main cursor right" })

            -- Delete the main cursor.
            set({ "n", "v" }, "<leader>mx", mc.deleteCursor, { desc = "Delete main cursor" })

            -- Add and remove cursors with control + left click.
            set("n", "<c-leftmouse>", mc.handleMouse)

            set({ "n", "v" }, "<leader>mq", function()
                if mc.cursorsEnabled() then
                    -- Stop other cursors from moving.
                    -- This allows you to reposition the main cursor.
                    mc.disableCursors()
                else
                    mc.addCursor()
                end
            end, { desc = "Cancel multi cursor" })

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
            set("v", "<leader>ma", mc.alignCursors, { desc = "Align cursor columns" })

            -- Split visual selections by regex.
            -- set("v", "S", mc.splitCursors)

            -- Append/insert for each line of visual selections.
            set("v", "I", mc.insertVisual)
            set("v", "A", mc.appendVisual)

            -- match new cursors within visual selections by regex.
            set("v", "<leader>m/", mc.matchCursors, { desc = "Match cursors by regex" })

            -- -- Rotate visual selection contents.
            -- set("v", "<leader>{",
            --     function() mc.transposeCursors(-1) end)
            -- set("v", "<leader>}",
            --     function() mc.transposeCursors(1) end)

            -- Customize how cursors look.
            local hl = vim.api.nvim_set_hl
            hl(0, "MultiCursorCursor", { reverse = true })
            hl(0, "MultiCursorVisual", { link = "Visual" })
            hl(0, "MultiCursorSign", { link = "SignColumn" })
            hl(0, "MultiCursorDisabledCursor", { reverse = true })
            hl(0, "MultiCursorDisabledVisual", { link = "Visual" })
            hl(0, "MultiCursorDisabledSign", { link = "SignColumn" })
        end,
    },
    {
      'saghen/blink.pairs',
      version = '*', -- (recommended) only required with prebuilt binaries
      dependencies = 'saghen/blink.download',

      --- @module 'blink.pairs'
      --- @type blink.pairs.Config
      opts = {
        mappings = {
          -- you can call require("blink.pairs.mappings").enable() and require("blink.pairs.mappings").disable() to enable/disable mappings at runtime
          enabled = true,
          disabled_filetypes = {},
          -- see the defaults: https://github.com/Saghen/blink.pairs/blob/main/lua/blink/pairs/config/mappings.lua#L12
          pairs = {},
        },
        highlights = {
          enabled = false,
          groups = {
            'BlinkPairsOrange',
            'BlinkPairsPurple',
            'BlinkPairsBlue',
          },
          matchparen = {
            enabled = true,
            group = 'MatchParen',
          },
        },
        debug = false,
      }
  }
}
