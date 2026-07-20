local load = require("load")

load.later(function()
    vim.pack.add(load.gh({ "stevearc/conform.nvim" }))

    require("conform").setup({
        default_format_opts = {
            lsp_format = "fallback",
        },
        formatters_by_ft = {
            -- lua = { "stylua" },
            -- Conform will run multiple formatters sequentially
            python = { "ruff_organize_imports", "ruff_format" },
            -- You can customize some of the format options for the filetype (:help conform.format)
            rust = { "rustfmt" },
            -- Conform will run the first available formatter
            markdown = { "rumdl" },
            bash = { "shfmt" },
            sh = { "shfmt" },
            quarto = { "rumdl", "injected" },
            htmldjango = { "djlint" },
        },
    })
    vim.keymap.set("n", "<localleader>f", function()
        require("conform").format()
    end, { desc = "Format code using conform", silent = true })
end)
