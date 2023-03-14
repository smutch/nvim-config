return {
    {
        'nvim-treesitter/nvim-treesitter',
        config = function()
            require 'nvim-treesitter.configs'.setup {
                highlight = {
                    enable = true, -- false will disable the whole extension
                    -- disable = { "c", "rust" },  -- list of language that will be disabled
                    custom_captures = { ["variable"] = "Normal" },
                    additional_vim_regex_highlighting = false -- WARNING: Must be set to false for spellsitter plugin
                },
                ensure_installed = { "c", "python", "lua", "bash", "make", "cmake", "toml", "yaml", "cpp", "cuda", "json", "rust", "vim", "html", "css", "bibtex", "markdown", "rst", "comment" },
                incremental_selection = { enable = false },
                refactor = {
                    highlight_definitions = { enable = true },
                    highlight_current_scope = { enable = true },
                    smart_rename = { enable = true, keymaps = { smart_rename = "gR" } }
                },
                textobjects = {
                    select = {
                        enable = true,

                        -- Automatically jump forward to textobj, similar to targets.vim
                        lookahead = true,

                        keymaps = {
                            -- You can use the capture groups defined in textobjects.scm
                            ["af"] = "@function.outer",
                            ["if"] = "@function.inner",
                            ["ac"] = "@class.outer",
                            ["ic"] = "@class.inner",
                            ["aP"] = "@parameter.outer",
                            ["iP"] = "@parameter.inner",
                            ["aC"] = "@comment.outer",
                            ["aB"] = "@block.outer",
                            ["iB"] = "@block.inner"

                            -- -- Or you can define your own textobjects like this
                            -- ["iF"] = {
                                --     python = "(function_definition) @function",
                                --     cpp = "(function_definition) @function",
                                --     c = "(function_definition) @function",
                                --     java = "(method_declaration) @function",
                                -- },
                            }
                        },
                        swap = {
                            enable = true,
                            swap_next = { ["<leader>a"] = "@parameter.inner" },
                            swap_previous = { ["<leader>A"] = "@parameter.inner" }
                        },
                        lsp_interop = {
                            enable = true,
                            border = 'none',
                            peek_definition_code = { ["<leader>df"] = "@function.outer", ["<leader>dF"] = "@class.outer" }
                        },
                        move = {
                            enable = true,
                            set_jumps = false, -- whether to set jumps in the jumplist
                            goto_next_start = {
                                ["]m"] = "@function.outer",
                                ["]]"] = "@class.outer",
                            },
                            goto_next_end = {
                                ["]M"] = "@function.outer",
                                ["]["] = "@class.outer",
                            },
                            goto_previous_start = {
                                ["[m"] = "@function.outer",
                                ["[["] = "@class.outer",
                            },
                            goto_previous_end = {
                                ["[M"] = "@function.outer",
                                ["[]"] = "@class.outer",
                            },
                        },
                    },
                }
                vim.treesitter.language.register("astro", "tsx")
        end
    },
    { 'nvim-treesitter/nvim-treesitter-context' },
    { 'nvim-treesitter/nvim-treesitter-textobjects' },
    { 'nvim-treesitter/playground' },
    {
        'tpope/vim-dispatch',
        config = function()
            vim.g.dispatch_compilers = { python = 'python %' }
            -- remove iterm from the list of handlers (don't like it removing focus when run)
            vim.g.dispatch_handlers = { 'tmux', 'screen', 'windows', 'x11', 'headless' }
        end
    },
}
