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
    textobjects = {
        select = {
            enable = true,

            -- Automatically jump forward to textobj, similar to targets.vim
            lookahead = true,

            keymaps = {
                -- You can use the capture groups defined in textobjects.scm
                ["aF"] = "@function.outer",
                ["if"] = "@function.inner",
                ["aC"] = "@class.outer",
                ["ic"] = "@class.inner",
                ["aP"] = "@parameter.outer",
                ["ip"] = "@parameter.inner",
                ["a#"] = "@comment.outer",
                ["aB"] = "@block.outer",
                ["ib"] = "@block.inner",

                -- -- Or you can define your own textobjects like this
                -- ["iF"] = {
                --     python = "(function_definition) @function",
                --     cpp = "(function_definition) @function",
                --     c = "(function_definition) @function",
                --     java = "(method_declaration) @function",
                -- },
            },
        },
        swap = {
            enable = true,
            swap_next = { ["gs"] = "@parameter.inner" },
            swap_previous = { ["gS"] = "@parameter.inner" },
        },
        lsp_interop = {
            enable = true,
            peek_definition_code = { ["grp"] = "@function.outer", ["grP"] = "@class.outer" },
        },
        move = {
            enable = true,
            set_jumps = false, -- whether to set jumps in the jumplist
            goto_next_start = {
                ["]f"] = "@function.outer",
                ["]]"] = "@class.outer",
            },
            goto_next_end = {
                ["]F"] = "@function.outer",
                ["]["] = "@class.outer",
            },
            goto_previous_start = {
                ["[f"] = "@function.outer",
                ["[["] = "@class.outer",
            },
            goto_previous_end = {
                ["[F"] = "@function.outer",
                ["[]"] = "@class.outer",
            },
        },
    },
    matchup = {
        enable = true, -- mandatory, false will disable the whole extension
        -- disable = { "c", "ruby" }, -- optional, list of language that will be disabled
        -- [options]
    },
})
vim.treesitter.language.register("astro", "tsx")
vim.treesitter.language.register("markdown", "mdx")
