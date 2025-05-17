return {
    {
        "EdenEast/nightfox.nvim",
        -- lazy = false,
        -- priority = 1000,
        config = function()
            require("nightfox").setup({
                options = {
                    dim_inactive = false,
                    styles = { comments = "italic", keywords = "bold", types = "italic,bold" },
                },
                groups = {
                    nightfox = {
                        -- As with specs and palettes, a specific style's value will be used over the `all`'s value.
                        VertSplit = { fg = "sel1" },
                        WinSeparator = { fg = "sel1" },
                        BufferCurrent = { bg = "bg2", fg = "fg1" },
                        BufferCurrentIndex = { bg = "bg2", fg = "diag.info" },
                        BufferCurrentMod = { bg = "bg2", fg = "diag.warn" },
                        BufferCurrentSign = { bg = "bg2", fg = "diag.info" },
                        BufferCurrentTarget = { bg = "bg2", fg = "diag.error" },
                        MatchParen = { bg = "bg3", fg = "diag.error" },
                    },
                },
            })
            -- vim.cmd.colorscheme('nightfox')
        end,
    },
    {
        "rose-pine/neovim",
        lazy = false,
        priority = 1000,
        config = function()
            require("rose-pine").setup({
                styles = {
                    bold = true,
                    italic = false,
                    transparency = false,
                },
                ---@diagnostic disable-next-line: unused-local
                before_highlight = function(group, highlight, palette)
                    -- Disable all undercurls
                    -- print(group, highlight, palette)
                    if string.match(string.lower(group), "comment") then
                        highlight.italic = true
                    end
                end,
            })
            vim.cmd.colorscheme("rose-pine-moon")

            -- for some reason rose-pine sets this and we want it back to 3!
            vim.o.laststatus = 3
        end,
    },
    {
        "slugbyte/lackluster.nvim",
        -- lazy = false,
        -- priority = 1000,
        config = function()
            ---@diagnostic disable-next-line: missing-fields
            require("lackluster").setup({
                tweak_syntax = {
                    comment = "#4c4c4c",
                },
            })
            -- vim.cmd.colorscheme('lackluster-mint')
        end,
    },
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "abeldekat/harpoonline", "AndreM222/copilot-lualine", "yavorski/lualine-macro-recording.nvim" },
        lazy = false,
        config = function()
            require("plugins.config.statusline")
            local augroup = vim.api.nvim_create_augroup("lualine_colors", {})
            vim.api.nvim_create_autocmd("ColorScheme", {
                callback = function()
                    require("plugins.config.statusline")
                end,
                group = augroup,
            })
        end,
    },
    {
        "folke/noice.nvim",
        depends = { "MunifTanjim/nui.nvim" },
        lazy = false,
        config = function()
            require("noice").setup({
                lsp = {
                    -- override markdown rendering so that **cmp** and other plugs use **Treesitter**
                    override = {
                        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                        ["vim.lsp.util.stylize_markdown"] = true,
                    },
                },
                -- you can enable a preset for easier configuration
                presets = {
                    bottom_search = true, -- use a classic bottom cmdline for search
                    command_palette = true, -- position the cmdline and popupmenu together
                    long_message_to_split = true, -- long messages will be sent to a split
                    inc_rename = false, -- enables an input dialog for inc-rename.nvim
                    lsp_doc_border = true, -- add a border to hover docs and signature help
                },
                messages = {
                    view_search = false,
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
                        view = "mini",
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
                    },
                },
            })
        end,
    },
    {
        "echasnovski/mini.icons",
        version = "*",
        config = function()
            local mini_icons = require("mini.icons")
            mini_icons.setup()
            mini_icons.mock_nvim_web_devicons()
        end,
    },
    {
        "utilyre/barbecue.nvim",
        name = "barbecue",
        dependencies = {
            "SmiteshP/nvim-navic",
            "echasnovski/mini.icons",
        },
        opts = {
            theme = {
                basename = { fg = "#baa386", bold = true },
            },
        },
    },
    {
        "folke/todo-comments.nvim",
        event = "VeryLazy",
        config = function()
            require("todo-comments").setup({
                colors = {
                    hint = { "Keyword", "#9d79d6" },
                    warning = { "DiagnosticError", "#c94f6d" },
                    error = { "DiagnosticWarn", "WarningMsg", "FBBF24" },
                },
                gui_style = {
                    fg = "BOLD",
                    bg = "BOLD",
                },
            })
        end,
    },
}
