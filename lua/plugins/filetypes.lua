return {
    { 'vim-python/python-syntax',      ft = { 'python' } },
    { 'Vimjas/vim-python-pep8-indent', ft = { 'python' } },
    { 'anntzer/vim-cython',            ft = { 'python', 'cython' } },
    { 'adamclaxon/taskpaper.vim',      ft = { 'taskpaper', 'tp' } },
    -- { 'jbyuki/nabla.nvim' },
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
    { 'vim-scripts/scons.vim',       ft = { 'scons' } },
    { 'Glench/Vim-Jinja2-Syntax',    ft = { 'html' } },
    {
        'MeanderingProgrammer/markdown.nvim',
        name = 'render-markdown',
        dependencies = { 'nvim-treesitter/nvim-treesitter' },
        opts = { file_types = { 'markdown.pandoc' }, },
        ft = { 'markdown', 'pandoc', 'quarto', 'markdown.pandoc' },
    },
    { 'cespare/vim-toml',   ft = { 'toml' } },
    { 'tikhomirov/vim-glsl' },
    { 'DingDean/wgsl.vim' },
    {
        'snakemake/snakemake',
        ft = 'snakemake',
        config = function(plugin)
            vim.opt.rtp:append(plugin.dir .. "/misc/vim")
        end
    },
    { 'NoahTheDuke/vim-just', ft = { 'just' } },
    { 'alaviss/nim.nvim',    ft = { 'nim' } },
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
}
