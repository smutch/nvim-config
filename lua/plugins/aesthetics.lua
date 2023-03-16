return {
    { 'navarasu/onedark.nvim' },
    {
        'EdenEast/nightfox.nvim',
        config = function()
            require'nightfox'.setup {
                options = { styles = { comments = "italic", keywords = "bold", types = "italic,bold" } },
                groups = {
                    nightfox = {
                        -- As with specs and palettes, a specific style's value will be used over the `all`'s value.
                        VertSplit = { fg = "sel1" },
                        BufferCurrent = { bg = "bg2", fg = "fg1" },
                        BufferCurrentIndex   = { bg = "bg2", fg = "diag.info" },
                        BufferCurrentMod     = { bg = "bg2", fg = "diag.warn" },
                        BufferCurrentSign    = { bg = "bg2", fg = "diag.info" },
                        BufferCurrentTarget  = { bg = "bg2", fg = "diag.error" },
                    },
                },
            }
        end
    },
    { 'Shatur/neovim-ayu' },
    {
        'projekt0n/github-nvim-theme',
        opt = true,
        config = function() require'github-theme'.setup { theme_style = 'dark' } end
    },
    { 'rmehri01/onenord.nvim' },
    {
        'nvim-lualine/lualine.nvim',
        config = require'plugins.config.lualine'.config
    },
    {
        'lukas-reineke/indent-blankline.nvim',
        config = function()
            require("indent_blankline").setup {
                char = '│',
                show_current_context = true,
                buftype_exclude = { "terminal" }
            }
            vim.cmd [[highlight! link IndentBlanklineChar VertSplit]]
        end
    },
    -- {
    --     'gcmt/taboo.vim',
    --     config = function()
    --         vim.g.taboo_tab_format = " %I %f%m "
    --         vim.g.taboo_renamed_tab_format = " %I %l%m "
    --     end
    -- },
    { 'https://gitlab.com/yorickpeterse/nvim-pqf.git', config = true },
    { 'kevinhwang91/nvim-hlslens' },
    {
        'petertriho/nvim-scrollbar',
        config = function()
            require("scrollbar").setup {
                handle = { color = "#4C566A" },
                excluded_filetypes = {
                    "prompt",
                    "TelescopePrompt",
                    "tex"
                }, }

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
                    bottom_search = true, -- use a classic bottom cmdline for search
                    command_palette = true, -- position the cmdline and popupmenu together
                    long_message_to_split = true, -- long messages will be sent to a split
                    inc_rename = false, -- enables an input dialog for inc-rename.nvim
                    lsp_doc_border = false, -- add a border to hover docs and signature help
                },
                messages = {
                    view_search = false
                },
            })
        end
    }
}
