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
        end
    },
    {
        'EdenEast/nightfox.nvim',
        lazy = true,
        config = function()
            require 'nightfox'.setup {
                options = { styles = { comments = "italic", keywords = "bold", types = "italic,bold" } },
                groups = {
                    nightfox = {
                        -- As with specs and palettes, a specific style's value will be used over the `all`'s value.
                        VertSplit           = { fg = "sel1" },
                        BufferCurrent       = { bg = "bg2", fg = "fg1" },
                        BufferCurrentIndex  = { bg = "bg2", fg = "diag.info" },
                        BufferCurrentMod    = { bg = "bg2", fg = "diag.warn" },
                        BufferCurrentSign   = { bg = "bg2", fg = "diag.info" },
                        BufferCurrentTarget = { bg = "bg2", fg = "diag.error" },
                    },
                },
            }
        end
    },
    {
        'nvim-lualine/lualine.nvim',
        lazy = false,
        config = require 'plugins.config.lualine'.config,
    },
    {
        'lukas-reineke/indent-blankline.nvim',
        config = function()
            require("ibl").setup {
                indent = { char = '│' },
                scope = { enabled = true, show_start = false, show_end = false, highlight = { "Structure" } },
                exclude = { buftypes = { "terminal" } }
            }
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
                },
            })
        end
    },
    { 'nvim-tree/nvim-web-devicons', lazy = true },
    {
        'nanozuki/tabby.nvim',
        config = function()
            local function tabline(line)
                local ll_theme = require 'lualine.themes.auto'
                local theme = {
                    fill = ll_theme.normal.c,
                    head = ll_theme.visual.a,
                    current_tab = ll_theme.normal.a,
                    tab = ll_theme.normal.b,
                    win = ll_theme.normal.b,
                    tail = ll_theme.normal.b,
                }

                return {
                    {
                        { ' 󰯉 ', hl = theme.head },
                        line.sep('', theme.head, theme.fill),
                    },
                    line.tabs().foreach(function(tab)
                        local hl = tab.is_current() and theme.current_tab or theme.tab
                        return {
                            line.sep('', hl, theme.fill),
                            tab.is_current() and '' or '󰆣',
                            tab.number(),
                            tab.name(),
                            tab.close_btn(''),
                            line.sep('', hl, theme.fill),
                            hl = hl,
                            margin = ' ',
                        }
                    end),
                    line.spacer(),
                    line.wins_in_tab(line.api.get_current_tab()).foreach(function(win)
                        if win.buf().type() == 'nofile' then
                            return ''
                        end
                        return {
                            line.sep('', theme.win, theme.fill),
                            win.is_current() and '' or '',
                            win.buf_name(),
                            line.sep('', theme.win, theme.fill),
                            hl = theme.win,
                            margin = ' ',
                        }
                    end),
                    {
                        line.sep('', theme.tail, theme.fill),
                    },
                    hl = theme.fill,
                }
            end

            require('tabby.tabline').set(tabline)
            vim.opt.showtabline = 2


            -- This doesn't do anything for some reason. Will need to work this out at a later date!
            -- local augroup = vim.api.nvim_create_augroup("MyTabby", {})
            -- vim.api.nvim_create_autocmd({ "ColorScheme" }, {
            --     group = augroup,
            --     callback = function()
            --         require('tabby.tabline').set(tabline)
            --     end
            -- })
        end
    }
}
