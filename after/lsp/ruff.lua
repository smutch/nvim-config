local on_attach = require("plugs.config.lsp").on_attach

return {
    init_options = {
        settings = {
            lint = {
                enable = false, -- use basedpyright for linting
            },
        },
    },
    on_attach = function(client, bufnr)
        vim.notify("Ruff LSP attached")
        client.server_capabilities.hoverProvider = false
        on_attach(client, bufnr)
    end,
}
