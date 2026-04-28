local gh = require("load").gh

-- icons
vim.pack.add(gh({ "nvim-mini/mini.icons" }))
local mini_icons = require("mini.icons")
mini_icons.setup()
mini_icons.mock_nvim_web_devicons()

require("load").later(function()
    vim.pack.add(
        gh({
            "nvim-mini/mini.hipatterns",
            "nvim-mini/mini.cursorword",
            "nvim-mini/mini.splitjoin",
            "nvim-mini/mini.bracketed",
            'nvim-mini/mini.colors'
        })
    )

    -- hipatterns
    local hipatterns = require("mini.hipatterns")
    hipatterns.setup({
        highlighters = {
            -- Highlight standalone 'FIXME', 'HACK', 'TODO', 'NOTE'
            fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
            hack = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
            todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
            note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },
            warning = { pattern = "%f[%w]()WARNING()%f[%W]", group = "@comment.error" },

            -- Highlight hex color strings (`#rrggbb`) using that color
            -- NOTE: we currently use Ccc for this
            -- hex_color = hipatterns.gen_highlighter.hex_color(),
        },
    })

    -- cursorword
    require("mini.cursorword").setup({})

    -- splitjoin
    require("mini.splitjoin").setup({})

    -- bracketed
    require("mini.bracketed").setup({})
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
