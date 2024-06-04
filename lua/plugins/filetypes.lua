return {
    { 'adamclaxon/taskpaper.vim', ft = { 'taskpaper', 'tp' } },
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
    {
        'MeanderingProgrammer/markdown.nvim',
        name = 'render-markdown',
        dependencies = { 'nvim-treesitter/nvim-treesitter' },
        opts = { file_types = { 'markdown.pandoc', 'markdown', 'quarto', 'pandoc' }, },
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
        ft = "quarto",
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
    {
        "Olical/conjure",
        ft = { "clojure", "fennel", "racket", "janet" }, -- etc
        -- [Optional] cmp-conjure for cmp
        dependencies = {
            {
                "PaterJason/cmp-conjure",
                config = function()
                    local cmp = require("cmp")
                    local config = cmp.get_config()
                    table.insert(config.sources, {
                        name = "buffer",
                        option = {
                            sources = {
                                { name = "conjure" },
                            },
                        },
                    })
                    cmp.setup(config)
                end,
            },
        },
        config = function(_, opts)
            require("conjure.main").main()
            require("conjure.mapping")["on-filetype"]()
        end,
        init = function()
            -- Set configuration options here
            vim.g["conjure#debug"] = true
        end,

    },
    {
        "al1-ce/just.nvim",
        dependencies = {
            'nvim-lua/plenary.nvim',
            'nvim-telescope/telescope.nvim',
            'rcarriga/nvim-notify',
            'j-hui/fidget.nvim',
        },
        config = true
    }
}
