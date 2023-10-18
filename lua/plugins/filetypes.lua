return {
    { 'vim-python/python-syntax',      ft = { 'python' } },
    { 'Vimjas/vim-python-pep8-indent', ft = { 'python' } },
    { 'anntzer/vim-cython',            ft = { 'python', 'cython' } },
    { 'adamclaxon/taskpaper.vim',      ft = { 'taskpaper', 'tp' } },
    -- { 'jbyuki/nabla.nvim' },
    {
        'lervag/vimtex',
        ft = 'tex',
        config = function()
            vim.g.vimtex_compiler_latexmk = { build_dir = './build' }
            vim.g.vimtex_quickfix_mode = 0
            vim.g.vimtex_view_method = 'skim'
            vim.g.vimtex_fold_enabled = 1
            vim.g.vimtex_compiler_progname = 'nvr'
        end
    },
    { "vim-pandoc/vim-pandoc-syntax" },
    { "vim-pandoc/vim-pandoc",       ft = { 'markdown', 'quarto', 'pandoc' } },
    { 'vim-scripts/scons.vim',       ft = { 'scons' } },
    { 'Glench/Vim-Jinja2-Syntax',    ft = { 'html' } },
    {
        'mattn/emmet-vim',
        ft = { 'html', 'css', 'sass', 'jinja.html', 'markdown', 'markdown.pandoc' },
        init = function()
            vim.g.user_emmet_leader_key = '<M-y>'
        end
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
    { 'NoahTheDuke/vim-just' },
    { 'alaviss/nim.nvim',    ft = { 'nim' } },
    {
        'quarto-dev/quarto-nvim',
        lazy = true,
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
