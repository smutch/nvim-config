---@diagnostic disable: missing-fields

require("nvim-treesitter.install").compilers = { "gcc" }
require("nvim-treesitter.configs").setup({
    highlight = {
        enable = (function()
            if vim.g.vscode then
                return false
            else
                return true
            end
        end)(), -- false will disable the whole extension
        -- disable = { "c", "rust" },  -- list of language that will be disabled
        -- custom_captures = { ["variable"] = "Normal" },
    },
    ensure_installed = {
        "c",
        "python",
        "lua",
        "bash",
        "make",
        "cmake",
        "toml",
        "yaml",
        "cpp",
        "cuda",
        "json",
        "rust",
        "vim",
        "html",
        "css",
        "bibtex",
        "markdown",
        "rst",
        "comment",
        "diff",
        "markdown_inline",
        "regex",
        "sql",
        "typst",
    },
    incremental_selection = { enable = false },
    matchup = {
        enable = true, -- mandatory, false will disable the whole extension
        -- disable = { "c", "ruby" }, -- optional, list of language that will be disabled
        -- [options]
    },
})

require("nvim-treesitter-textobjects").setup({
    move = {
        set_jumps = true,
    },
})

local move = require("nvim-treesitter-textobjects.move")
local select = require("nvim-treesitter-textobjects.select")
local swap = require("nvim-treesitter-textobjects.swap")
local ts_repeat_move = require("nvim-treesitter-textobjects.repeatable_move")

vim.keymap.set({ "x", "o" }, "af", function()
    select.select_textobject("@function.outer", "textobjects")
end)
vim.keymap.set({ "x", "o" }, "if", function()
    select.select_textobject("@function.inner", "textobjects")
end)
vim.keymap.set({ "x", "o" }, "ac", function()
    select.select_textobject("@class.outer", "textobjects")
end)
vim.keymap.set({ "x", "o" }, "ic", function()
    select.select_textobject("@class.inner", "textobjects")
end)
vim.keymap.set({ "x", "o" }, "ap", function()
    select.select_textobject("@parameter.outer", "textobjects")
end)
vim.keymap.set({ "x", "o" }, "ip", function()
    select.select_textobject("@parameter.inner", "textobjects")
end)
vim.keymap.set({ "x", "o" }, "a/", function()
    select.select_textobject("@comment.outer", "textobjects")
end)
vim.keymap.set({ "x", "o" }, "i/", function()
    select.select_textobject("@comment.inner", "textobjects")
end)
vim.keymap.set("n", "]p", function()
    swap.swap_next("@parameter.inner")
end)
vim.keymap.set("n", "[p", function()
    swap.swap_previous("@parameter.outer")
end)
vim.keymap.set({ "n", "x", "o" }, "]m", function()
    move.goto_next_start("@function.outer", "textobjects")
end)
vim.keymap.set({ "n", "x", "o" }, "]]", function()
    move.goto_next_start("@class.outer", "textobjects")
end)
vim.keymap.set({ "n", "x", "o" }, "]o", function()
    move.goto_next_start({ "@loop.inner", "@loop.outer" }, "textobjects")
end)
vim.keymap.set({ "n", "x", "o" }, "]s", function()
    move.goto_next_start("@local.scope", "locals")
end)
vim.keymap.set({ "n", "x", "o" }, "]z", function()
    move.goto_next_start("@fold", "folds")
end)
vim.keymap.set({ "n", "x", "o" }, "]M", function()
    move.goto_next_end("@function.outer", "textobjects")
end)
vim.keymap.set({ "n", "x", "o" }, "][", function()
    move.goto_next_end("@class.outer", "textobjects")
end)
vim.keymap.set({ "n", "x", "o" }, "[m", function()
    move.goto_previous_start("@function.outer", "textobjects")
end)
vim.keymap.set({ "n", "x", "o" }, "[[", function()
    move.goto_previous_start("@class.outer", "textobjects")
end)
vim.keymap.set({ "n", "x", "o" }, "[M", function()
    move.goto_previous_end("@function.outer", "textobjects")
end)
vim.keymap.set({ "n", "x", "o" }, "[]", function()
    move.goto_previous_end("@class.outer", "textobjects")
end)

-- Repeat movement with ; and ,
vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move)
vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_opposite)

vim.treesitter.language.register("astro", "tsx")
vim.treesitter.language.register("markdown", "mdx")
