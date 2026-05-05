local load = require("load")
vim.pack.add(load.gh({
    "arborist-ts/arborist.nvim",
}))

require("arborist").setup({
    ensure_installed = {
        "bash",
        "c",
        "cpp",
        "css",
        "html",
        "javascript",
        "json",
        "lua",
        "python",
        "rust",
        "typescript",
        "yaml",
        "toml",
        "sql"
    },
})
