local load = require("load")

load.later(function()
    vim.pack.add(load.gh({ "mason-org/mason.nvim", "mason-org/mason-lspconfig.nvim" }))

    require("mason").setup({
        ensure_installed = {
            "lua_ls",
            "stylelua",
            "basedpyright",
            "ruff",
            "ty",
            "codespell",
            "shellcheck",
        },
    })
    require("mason-lspconfig").setup()
end)
