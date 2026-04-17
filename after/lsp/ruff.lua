local on_attach = vim.lsp.config["*"].on_attach

return {
    init_options = {
        settings = {
            lint = {
                enable = false, -- use basedpyright for linting
            },
        },
    },
    on_attach = function(client, bufnr)
        client.server_capabilities.hoverProvider = false
        if on_attach then
            on_attach(client, bufnr)
        end
    end,
}
