local gh = require("load").gh

vim.pack.add(gh({ "jmbuhr/otter.nvim", "GCBallesteros/jupytext.nvim" }))

require("otter").setup()
require("jupytext").setup({
    style = "percent",
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
})

require("load").on_event("FileType~quarto", function()
    vim.pack.add(gh({ "quarto-dev/quarto-nvim" }))
    require("quarto").setup({
        lspFeatures = {
            enabled = true,
            languages = { "r", "python", "julia", "javascript" },
            diagnostics = {
                enabled = true,
                triggers = { "BufWritePost" },
            },
            completion = {
                enabled = true,
            },
            codeRunner = {
                enabled = true,
                default_method = "slime",
                never_run = { "yaml" }, -- filetypes which are never sent to a code runner
            },
        },
    })
    local runner = require("quarto.runner")
    vim.keymap.set("n", "gz", runner.run_cell, { desc = "run cell", silent = true, nnoremap = true })
    vim.keymap.set(
        "n",
        "<localleader>qa",
        runner.run_above,
        { desc = "run cell and above", silent = true, nnoremap = true }
    )
    vim.keymap.set("n", "<localleader>qA", runner.run_all, { desc = "run all cells", silent = true, nnoremap = true })
    vim.keymap.set("n", "<localleader>ql", runner.run_line, { desc = "run line", silent = true, nnoremap = true })
    vim.keymap.set("v", "gz", runner.run_range, { desc = "run visual range", silent = true, nnoremap = true })
    vim.keymap.set(
        "n",
        "<localleader>qp",
        require("quarto").quartoPreview,
        { desc = "quarto preview", silent = true, nnoremap = true }
    )
    vim.keymap.set("n", "<localleader>QA", function()
        runner.run_all(true)
    end, { desc = "run all cells of all languages", silent = true, nnoremap = true })

    vim.filetype.add({
        extension = {
            ojs = "javascript",
        },
    })
end)
