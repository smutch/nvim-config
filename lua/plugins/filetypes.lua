return {
    { 'vim-python/python-syntax', ft = { 'python' } },
    { 'Vimjas/vim-python-pep8-indent', ft = { 'python' } },
    { 'anntzer/vim-cython', ft = { 'python', 'cython' } },
    { 'adamclaxon/taskpaper.vim', ft = { 'taskpaper', 'tp' } },
    { 'jbyuki/nabla.nvim' },
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
    { "vim-pandoc/vim-pandoc", ft = { 'markdown', 'quarto', 'pandoc' } },
    { "quarto-dev/quarto-vim", ft = { "quarto" } },
    { 'vim-scripts/scons.vim', ft = { 'scons' } },
    { 'Glench/Vim-Jinja2-Syntax', ft = { 'html' } },
    { 'mattn/emmet-vim', ft = { 'html', 'css', 'sass', 'jinja.html' } },
    { 'cespare/vim-toml', ft = { 'toml' } },
    { 'tikhomirov/vim-glsl'},
    { 'DingDean/wgsl.vim'},
    { 'snakemake/snakemake', rtp = 'misc/vim' },
    { 'NoahTheDuke/vim-just' },
    { 'alaviss/nim.nvim', ft = { 'nim' } },
}