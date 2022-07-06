local M = {}

function M.config()
    require 'nvim-treesitter.configs'.setup {
        highlight = {
            enable = true, -- false will disable the whole extension
            -- disable = { "c", "rust" },  -- list of language that will be disabled
            custom_captures = { ["variable"] = "Normal" },
            additional_vim_regex_highlighting = false
        },
        ensure_installed = { "c", "python", "lua", "bash", "make", "cmake", "toml", "yaml", "cpp", "cuda", "json", "rust", "vim", "html", "css", "bibtex", "latex", "markdown", "rst", "comment" },
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
        local ft_to_parser = require('nvim-treesitter.parsers').filetype_to_parsername
        ft_to_parser.astro = "tsx"

        -- if vim.loop.os_uname().sysname == "Darwin" then
        --     require'nvim-treesitter.install'.compilers = { "gcc-11" }
        -- end
        -- require("nvim-treesitter.parsers").get_parser_configs().just = {
        -- install_info = {
        --         url = "https://github.com/IndianBoy42/tree-sitter-just", -- local path or git repo
        --         files = { "src/parser.c", "src/scanner.cc" },
        --         branch = "main"
        --     },
        --     maintainers = { "@IndianBoy42" }
        -- }
    end

return M

