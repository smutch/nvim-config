return {
    { 'adamclaxon/taskpaper.vim',      ft = { 'taskpaper', 'tp' } },
    {
        'lervag/vimtex',
        ft = { 'tex' },
        config = function()
            vim.g.vimtex_compiler_latexmk = { build_dir = './build' }
            vim.g.vimtex_quickfix_mode = 0
            vim.g.vimtex_view_method = 'skim'
            vim.g.vimtex_fold_enabled = 1
            vim.g.vimtex_compiler_progname = 'nvr'
        end
    },
    { "vim-pandoc/vim-pandoc-syntax", ft = { 'markdown.pandoc', 'pandoc' } },
    { "vim-pandoc/vim-pandoc",       ft = { 'markdown', 'quarto', 'pandoc' } },
    {
        'MeanderingProgrammer/markdown.nvim',
        name = 'render-markdown',
        dependencies = { 'nvim-treesitter/nvim-treesitter' },
        opts = { file_types = { 'markdown.pandoc' }, },
        ft = { 'markdown', 'pandoc', 'quarto', 'markdown.pandoc' },
    },
    {
        'snakemake/snakemake',
        ft = 'snakemake',
        config = function(plugin)
            vim.opt.rtp:append(plugin.dir .. "/misc/vim")
        end
    },
    {
        'quarto-dev/quarto-nvim',
        fd = "quarto",
        dependencies = {
            'jmbuhr/otter.nvim',
            'neovim/nvim-lspconfig'
        },
        config = function()
            require 'quarto'.setup {
                lspFeatures = {
                    enabled = true,
                    languages = { 'r', 'python', 'julia' },
                    diagnostics = {
                        enabled = true,
                        triggers = { "BufWrite" }
                    },
                    completion = {
                        enabled = true
                    }
                }
            }
        end
    },
    {
        'kaarmu/typst.vim',
        ft = { 'typst' },
        config = function()
            vim.g.typst_pdf_viewer = "Skim"
        end
    },
    { "folke/neodev.nvim", opts = {} },
}
