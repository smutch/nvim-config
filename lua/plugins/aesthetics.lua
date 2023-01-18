return {
    { 'navarasu/onedark.nvim' },
    {
        'EdenEast/nightfox.nvim',
        config = function()
            require'nightfox'.setup {
                options = { styles = { comments = "italic", keywords = "bold", types = "italic,bold" } },
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
    { 'kyazdani42/nvim-web-devicons' },
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
    {
        'gcmt/taboo.vim',
        config = function()
            vim.g.taboo_tab_format = " %I %f%m "
            vim.g.taboo_renamed_tab_format = " %I %l%m "
        end
    },
    { 'https://gitlab.com/yorickpeterse/nvim-pqf.git', config = function() require('pqf').setup() end },
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
}
