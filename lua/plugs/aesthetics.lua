return {
    {
        'EdenEast/nightfox.nvim',
        lazy = false,
        priority = 1000,
        config = function()
            require('nightfox').setup {
                options = { dim_inactive = false, styles = { comments = "italic", keywords = "bold", types = "italic,bold" }, inverse = { match_paren = true } },
                groups = {
                    nightfox = {
                        -- As with specs and palettes, a specific style's value will be used over the `all`'s value.
                        VertSplit           = { fg = "sel1" },
                        WinSeparator        = { fg = "sel1" },
                        BufferCurrent       = { bg = "bg2", fg = "fg1" },
                        BufferCurrentIndex  = { bg = "bg2", fg = "diag.info" },
                        BufferCurrentMod    = { bg = "bg2", fg = "diag.warn" },
                        BufferCurrentSign   = { bg = "bg2", fg = "diag.info" },
                        BufferCurrentTarget = { bg = "bg2", fg = "diag.error" },
                        MatchParen          = { bg = "bg3", fg = "diag.error" },
                    },
                },
            }
        end,
        init = function()
            vim.cmd.colorscheme('nightfox')
        end
    },
    {
        'jesseleite/nvim-noirbuddy',
        dependencies = { 'tjdevries/colorbuddy.nvim' },
        lazy = true,
        -- priority = 1000,
        opts = {
            preset = 'minimal',
            styles = {
                italic = true,
                bold = true,
                underline = true,
                undercurl = true,
            },
            colors = {
                background = '#181820',
                primary = '#957FB8',
            },
        },
    },
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { "abeldekat/harpoonline", 'AndreM222/copilot-lualine' },
        lazy = false,
        config = function()
            require 'plugs.config.statusline'
            local augroup = vim.api.nvim_create_augroup("lualine_colors", {})
            vim.api.nvim_create_autocmd("ColorScheme", {
                callback = function() require 'plugs.config.statusline' end,
                group = augroup
            })
        end
    },
    {
        "shellRaining/hlchunk.nvim",
        event = { "UIEnter" },
        config = function()
            local hlchunk = require "hlchunk"
            local ft = require "hlchunk.utils.filetype"
            for _, t in pairs({ "oil", "fugitive" }) do
                ft.exclude_filetypes[t] = true
            end
            hlchunk.setup({
                chunk = {
                    enable = true,
                    use_treesitter = true,
                    chars = {
                        horizontal_line = "━",
                        vertical_line = "┃",
                        left_top = "┏",
                        left_bottom = "┗",
                        right_arrow = "━",
                    },
                },
                blank = {
                    enable = false,
                },
                line_num = {
                    enable = false,
                    use_treesitter = true,
                },
            })
        end
    },
    {
        'rcarriga/nvim-notify',
        config = function()
            require 'notify'.setup { top_down = false }
        end,
        keys = {
            { "<leader><bs>", function() require("notify").dismiss {} end, desc = "Dismiss notification" },
        },
    },
    {
        'folke/noice.nvim',
        depends = { "MunifTanjim/nui.nvim" },
        lazy = false,
        config = function()
            require("noice").setup({
                lsp = {
                    -- override markdown rendering so that **cmp** and other plugs use **Treesitter**
                    override = {
                        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                        ["vim.lsp.util.stylize_markdown"] = true,
                        ["cmp.entry.get_documentation"] = true,
                    },
                },
                -- you can enable a preset for easier configuration
                presets = {
                    bottom_search = true,         -- use a classic bottom cmdline for search
                    command_palette = true,       -- position the cmdline and popupmenu together
                    long_message_to_split = true, -- long messages will be sent to a split
                    inc_rename = false,           -- enables an input dialog for inc-rename.nvim
                    lsp_doc_border = false,       -- add a border to hover docs and signature help
                },
                messages = {
                    view_search = false
                },
                routes = {
                    {
                        filter = { event = "msg_show", kind = "", find = "written$" },
                        opts = { skip = true },
                    },
                    {
                        filter = { event = "msg_show", kind = "", find = "^/" },
                        opts = { skip = true },
                    },
                    {
                        filter = { error = true, find = "E486" },
                        view = "mini"
                    },
                },
                views = {
                    cmdline_popup = {
                        border = {
                            style = "none",
                            padding = { 1, 3 },
                        },
                        filter_options = {},
                        win_options = {
                            winhighlight = {
                                Normal = "NormalFloat",
                                FloatBorder = "FloatBorder",
                            },
                        },
                    },
                    mini = {
                        position = {
                            row = 1,
                            col = "100%",
                        },
                    }
                },
            })
        end
    },
    { 'nvim-tree/nvim-web-devicons', lazy = true },
    {
        "utilyre/barbecue.nvim",
        name = "barbecue",
        dependencies = {
            "SmiteshP/nvim-navic",
            "nvim-tree/nvim-web-devicons",
        },
        opts = {
            theme = {
                basename = { fg = "#baa386", bold = true },
            }
        }
    },
    {
        "folke/todo-comments.nvim",
        event = "VeryLazy",
        config = function()
            require "todo-comments".setup {
                colors = {
                    hint = { "Keyword", "#9d79d6" },
                    warning = { "DiagnosticError", "#c94f6d" },
                    error = { "DiagnosticWarn", "WarningMsg", "FBBF24" }
                },
                gui_style = {
                    fg = "BOLD",
                    bg = "BOLD",
                },
            }
        end
    },
}
