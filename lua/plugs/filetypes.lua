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
        "OXY2DEV/markview.nvim",
        dependencies = {
            "nvim-tree/nvim-web-devicons", -- Used by the code bloxks
        },
        ft = { 'markdown', 'pandoc', 'quarto', 'markdown.pandoc', 'Avante' },
        opts = {},
    },
    -- {
    --     'MeanderingProgrammer/markdown.nvim',
    --     name = 'render-markdown',
    --     dependencies = { 'nvim-treesitter/nvim-treesitter' },
    --     opts = { file_types = { 'markdown.pandoc', 'markdown', 'quarto', 'pandoc' }, },
    --     ft = { 'markdown', 'pandoc', 'quarto', 'markdown.pandoc' },
    -- },
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
        dependencies = {
            "stevearc/overseer.nvim",
            "PaterJason/cmp-conjure",
        },
        config = function()
            require("conjure.main").main()
            require("conjure.mapping")["on-filetype"]()
        end,
        init = function()
            vim.g["conjure#debug"] = false
            vim.g["conjure#filetypes"] = { "clojure", "fennel", "racket", "janet" }
            vim.g["conjure#filetype#janet"] = "conjure.client.janet.stdio"
        end,
    },
    {
        "gpanders/nvim-parinfer",
        ft = { "clojure", "fennel", "racket", "janet" },
    },
    {
        "OXY2DEV/helpview.nvim",
        lazy = false, -- Recommended
        dependencies = {
            "nvim-treesitter/nvim-treesitter"
        }
    }
}
