return {
    {
        'AlexvZyl/nordic.nvim',
        lazy = false,
        priority = 1000,
        config = function()
            -- require 'nordic'.load()
            require 'nordic'.setup {
                bold_keywords = true,
                bright_border = true,
                reduced_blue = true,
                -- swap_backgrounds = true,
                cursorline = { theme = 'light', blend = 1.0, },
            }
            vim.api.nvim_set_hl(0, "SpellBad", { cterm = { undercurl = true }, undercurl = true, bg = "#c5727a" })
        end
    },
    {
        'EdenEast/nightfox.nvim',
        lazy = false,
        priority = 1000,
        opts = {
            options = { dim_inactive = true, styles = { comments = "italic", keywords = "bold", types = "italic,bold" } },
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
                },
            },
        }
    },
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { "abeldekat/harpoonline", version = "*" },
        lazy = false,
        config = require 'plugins.config.lualine'.config,
    },
    {
        "shellRaining/hlchunk.nvim",
        event = { "UIEnter" },
        config = function()
            local hlchunk = require "hlchunk"
            local ft = require "hlchunk.utils.filetype"
            local exclude_filetypes = vim.list_extend(ft.exclude_filetypes, { oil = true })
            hlchunk.setup({
                chunk = {
                    enable = true,
                    use_treesitter = true,
                    exclude_filetypes = exclude_filetypes,
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
        'petertriho/nvim-scrollbar',
        dependencies = { 'kevinhwang91/nvim-hlslens' },
        config = function()
            require("scrollbar").setup {
                handle = { color = "#4C566A" },
                excluded_filetypes = {
                    "prompt",
                    "TelescopePrompt",
                    "tex"
                },
            }

            require("hlslens").setup({
                require("scrollbar.handlers.search").setup()
            })

            vim.cmd([[
            augroup scrollbar_search_hide
            autocmd!
            autocmd CmdlineLeave : lua require('scrollbar.handlers.search').handler.hide()
            augroup END
            ]])
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
                    -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
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
        'SmiteshP/nvim-navic',
        lazy = true,
        opts = { depth_limit = 3 }
    },
    {
        'b0o/incline.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons', 'SmiteshP/nvim-navic' },
        config = function()
            local helpers = require 'incline.helpers'
            local devicons = require 'nvim-web-devicons'
            local navic = require 'nvim-navic'

            require('incline').setup {
                window = {
                    padding = 0,
                    margin = { horizontal = 0, vertical = 0 },
                },
                render = function(props)
                    local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ':t')
                    if filename == '' then
                        filename = '[No Name]'
                    end
                    local ft_icon, ft_color = devicons.get_icon_color(filename)
                    local modified = vim.bo[props.buf].modified

                    local res = {
                        ft_icon and { ' ', ft_icon, ' ', guibg = ft_color, guifg = helpers.contrast_color(ft_color) } or
                        '',
                        ' ',
                        { filename, gui = modified and 'bold,italic' or 'bold' },
                        guibg = '#0d1326',
                    }
                    if props.focused then
                        for ii, item in ipairs(navic.get_data(props.buf) or {}) do
                            if ii == 4 then
                                table.insert(res, {
                                    { ' ... ', group = 'NavicSeparator' },
                                })
                                break
                            end
                            table.insert(res, {
                                { ' > ',     group = 'NavicSeparator' },
                                { item.icon, group = 'NavicIcons' .. item.type },
                                { item.name, group = 'NavicText' },
                            })
                        end
                    end
                    table.insert(res,
                        { ' │  ' .. vim.api.nvim_win_get_number(props.win) .. ' ', group = 'DevIconWindows' })

                    return res
                end,
            }
        end
    }
}
