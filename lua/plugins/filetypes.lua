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

            -- require("overseer").register_template({
            --     name = "Janet server",
            --     params = {},
            --     builder = function()
            --         return {
            --             cmd = { "janet" },
            --             args = { "-e", [[(import spork/netrepl) (netrepl/server)]] },
            --             cwd = vim.fn.getcwd(),
            --         }
            --     end,
            -- })

            -- -- https://github.com/acro5piano/nvim-format-buffer/blob/b3b6cbbdc78ab73ab8256e37a9e6203ac875866a/lua/nvim-format-buffer.lua
            -- local buf_get_full_text = function(bufnr)
            --     local text = table.concat(vim.api.nvim_buf_get_lines(bufnr, 0, -1, true), "\n")
            --     if vim.api.nvim_buf_get_option(bufnr, "eol") then
            --         text = text .. "\n"
            --     end
            --     return text
            -- end
            --
            -- -- https://github.com/acro5piano/nvim-format-buffer/blob/b3b6cbbdc78ab73ab8256e37a9e6203ac875866a/lua/nvim-format-buffer.lua
            -- local format_whole_file = function(cmd)
            --     local bufnr = vim.fn.bufnr("%")
            --     local input = buf_get_full_text(bufnr)
            --     local output = vim.fn.system(cmd, input)
            --     if vim.v.shell_error ~= 0 then
            --         print(output)
            --         return
            --     end
            --     if output ~= input then
            --         local new_lines = vim.fn.split(output, "\n")
            --         vim.api.nvim_buf_set_lines(0, 0, -1, false, new_lines)
            --     end
            -- end
            --
            -- local augrp = vim.api.nvim_create_augroup("Conjure", {})
            -- vim.api.nvim_create_autocmd({ "BufNew" }, {
            --     group = augrp,
            --     pattern = { "*.janet" },
            --     callback = function()
            --         require 'overseer'.run_template({ name = "Janet server" })
            --         vim.keymap.set('n', '<localleader>f',
            --             function() format_whole_file({ "janet", "-e",
            --                     [[(import spork/fmt) (fmt/format-print (file/read stdin :all))]] }) end,
            --             { buffer = 0 })
            --     end
            -- })
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
