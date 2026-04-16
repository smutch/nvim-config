local gh = require("load").gh

-- icons
vim.pack.add(gh({ "nvim-mini/mini.icons" }))
local mini_icons = require("mini.icons")
mini_icons.setup()
mini_icons.mock_nvim_web_devicons()

require("load").later(function()
    vim.pack.add(gh({ "nvim-mini/mini.hipatterns", "nvim-mini/mini.cursorword", "nvim-mini/mini.clue", "nvim-mini/mini.splitjoin" }))

    -- hipatterns
    local hipatterns = require("mini.hipatterns")
    hipatterns.setup({
        highlighters = {
            -- Highlight standalone 'FIXME', 'HACK', 'TODO', 'NOTE'
            fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
            hack = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
            todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
            note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },

            -- Highlight hex color strings (`#rrggbb`) using that color
            hex_color = hipatterns.gen_highlighter.hex_color(),
        },
    })

    -- cursorword
    require("mini.cursorword").setup({})

    -- clue
    local miniclue = require("mini.clue")
    miniclue.setup({
        triggers = {
            -- Leader triggers
            { mode = { "n", "x" }, keys = "<Leader>" },

            -- `[` and `]` keys
            { mode = "n", keys = "[" },
            { mode = "n", keys = "]" },

            -- Built-in completion
            { mode = "i", keys = "<C-x>" },

            -- `g` key
            { mode = { "n", "x" }, keys = "g" },

            -- Marks
            { mode = { "n", "x" }, keys = "'" },
            { mode = { "n", "x" }, keys = "`" },

            -- Registers
            { mode = { "n", "x" }, keys = '"' },
            { mode = { "i", "c" }, keys = "<C-r>" },

            -- Window commands
            { mode = "n", keys = "<C-w>" },

            -- `z` key
            { mode = { "n", "x" }, keys = "z" },
        },

        clues = {
            -- Enhance this by adding descriptions for <Leader> mapping groups
            miniclue.gen_clues.square_brackets(),
            miniclue.gen_clues.builtin_completion(),
            miniclue.gen_clues.g(),
            miniclue.gen_clues.marks(),
            miniclue.gen_clues.registers(),
            miniclue.gen_clues.windows(),
            miniclue.gen_clues.z(),
        },
    })

    -- splitjoin
    require("mini.splitjoin").setup({})
end)

require("load").on_event("InsertEnter", function()
    -- align
    vim.pack.add(gh({ "nvim-mini/mini.align" }))
    require("mini.align").setup({
        mappings = {
            start = "gA",
            start_with_preview = "1gA",
        },
    })
end)
