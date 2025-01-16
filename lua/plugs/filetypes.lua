return {
    { "adamclaxon/taskpaper.vim", ft = { "taskpaper", "tp" } },
    {
        "lervag/vimtex",
        ft = { "tex" },
        config = function()
            vim.g.vimtex_compiler_latexmk = { build_dir = "./build" }
            vim.g.vimtex_quickfix_mode = 0
            vim.g.vimtex_view_method = "skim"
            vim.g.vimtex_fold_enabled = 1
            vim.g.vimtex_compiler_progname = "nvr"
        end,
    },
    {
        "OXY2DEV/markview.nvim",
        dependencies = {
            "echasnovski/mini.icons",
        },
        ft = { "markdown", "pandoc", "quarto", "markdown.pandoc", "Avante", "codecompanion" },
        opts = {
            hybrid_modes = { "n" }
        },
    },
    {
        "snakemake/snakemake",
        ft = "snakemake",
        config = function(plugin)
            vim.opt.rtp:append(plugin.dir .. "/misc/vim")
        end,
    },
    { -- directly open ipynb files as quarto docuements
        -- and convert back behind the scenes
        "GCBallesteros/jupytext.nvim",
        opts = {
            custom_language_formatting = {
                python = {
                    extension = "qmd",
                    style = "quarto",
                    force_ft = "quarto",
                },
                r = {
                    extension = "qmd",
                    style = "quarto",
                    force_ft = "quarto",
                },
            },
        },
    },
    {
        "quarto-dev/quarto-nvim",
        ft = "quarto",
        dependencies = {
            "jmbuhr/otter.nvim",
            "neovim/nvim-lspconfig",
        },
        config = function()
            require("quarto").setup({
                lspFeatures = {
                    enabled = true,
                    languages = { "r", "python", "julia", "javascript" },
                    diagnostics = {
                        enabled = true,
                        triggers = { "BufWrite" },
                    },
                    completion = {
                        enabled = true,
                    },
                    codeRunner = {
                        enabled = true,
                        default_method = "molten",
                        never_run = { "yaml" }, -- filetypes which are never sent to a code runner
                    },
                },
            })
            local runner = require("quarto.runner")
            vim.keymap.set("n", "gz", runner.run_cell, { desc = "run cell", silent = true })
            vim.keymap.set("n", "<localleader>qa", runner.run_above, { desc = "run cell and above", silent = true })
            vim.keymap.set("n", "<localleader>qA", runner.run_all, { desc = "run all cells", silent = true })
            vim.keymap.set("n", "<localleader>ql", runner.run_line, { desc = "run line", silent = true })
            vim.keymap.set("v", "gz", runner.run_range, { desc = "run visual range", silent = true })
            vim.keymap.set(
                "n",
                "<localleader>qp",
                require("quarto").quartoPreview,
                { desc = "quarto preview", silent = true }
            )
            vim.keymap.set("n", "<localleader>QA", function()
                runner.run_all(true)
            end, { desc = "run all cells of all languages", silent = true })

            vim.filetype.add({
                extension = {
                    ojs = "javascript",
                },
            })
        end,
        cmd = { "QuartoPreview", "QuartoActivate" },
    },
    {
        "kaarmu/typst.vim",
        ft = { "typst" },
        config = function()
            vim.g.typst_pdf_viewer = "Skim"
        end,
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
            vim.g["conjure#mapping#doc_word"] = "gk"
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
            "nvim-treesitter/nvim-treesitter",
        },
    },
    { "GCBallesteros/jupytext.nvim", opts = { style = "percent" } },
}
