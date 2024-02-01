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
        config = function()
            require 'nightfox'.setup {
                options = { styles = { comments = "italic", keywords = "bold", types = "italic,bold" } },
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
                scope = { enabled = true, show_start = false, show_end = false, highlight = { "Number" } },
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
        'rcarriga/nvim-notify',
        config = function()
            require("notify").setup {
                top_down = false
            }
            vim.keymap.set('n', '<leader><bs>', require("notify").dismiss)
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
        'b0o/incline.nvim',
        requires = { 'nvim-tree/nvim-web-devicons' },
        config = function()
            require('incline').setup {
                render = function(props)
                    local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ':t')
                    local ft_icon, ft_color = require('nvim-web-devicons').get_icon_color(filename)
                    local modified = vim.bo[props.buf].modified and 'bold,italic' or 'bold'

                    local function get_git_diff()
                        local icons = { removed = ' ', changed = ' ', added = ' ' }
                        icons['changed'] = icons.modified
                        local signs = vim.b[props.buf].gitsigns_status_dict
                        local labels = {}
                        if signs == nil then
                            return labels
                        end
                        for name, icon in pairs(icons) do
                            if tonumber(signs[name]) and signs[name] > 0 then
                                table.insert(labels, { icon .. signs[name] .. ' ', group = 'Diff' .. name })
                            end
                        end
                        if #labels > 0 then
                            table.insert(labels, { '│ ' })
                        end
                        return labels
                    end
                    local function get_diagnostic_label()
                        local icons = { error = '', warn = '', info = '', hint = '' }
                        local label = {}

                        for severity, icon in pairs(icons) do
                            local n = #vim.diagnostic.get(props.buf,
                                { severity = vim.diagnostic.severity[string.upper(severity)] })
                            if n > 0 then
                                table.insert(label, { icon .. ' ' .. n .. ' ', group = 'DiagnosticSign' .. severity })
                            end
                        end
                        if #label > 0 then
                            table.insert(label, { '│ ' })
                        end
                        return label
                    end

                    return {
                        { get_diagnostic_label() },
                        { get_git_diff() },
                        { (ft_icon or '') .. ' ', guifg = ft_color, guibg = 'none' },
                        { filename .. ' ', gui = modified },
                        { '┊  ' .. vim.api.nvim_win_get_number(props.win), group = 'DevIconWindows' },
                    }
                end,
            }
        end
    }
}
