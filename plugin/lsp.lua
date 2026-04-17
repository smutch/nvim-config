require("load").later(function()
    vim.pack.add(require("load").gh({ "neovim/nvim-lspconfig", "rachartier/tiny-inline-diagnostic.nvim" }))

    require("tiny-inline-diagnostic").setup({
        preset = "modern",
        hi = {
            background = "#1d2939", -- Can be a highlight or a hexadecimal color (#RRGGBB)
        },
    })
    vim.keymap.set("n", "grv", function()
        require("tiny-inline-diagnostic").toggle()
    end, { desc = "Toggle (v)irtual text diagnostics" })
end)

vim.diagnostic.config({
    underline = true,
    virtual_text = false,
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = "",
            [vim.diagnostic.severity.WARN] = "",
            [vim.diagnostic.severity.INFO] = "",
            [vim.diagnostic.severity.HINT] = "",
        },
    },
    update_in_insert = false,
    severity_sort = true,
    virtual_lines = false,
    float = {
        border = "rounded",
        source = "if_many",
    },
})

local on_attach = function(client, bufnr)
    vim.keymap.set("n", "grD", function()
        vim.diagnostic.enable(not vim.diagnostic.is_enabled())
    end, { noremap = true, desc = "Toggle diagnostics on/off", buffer = bufnr })

    vim.keymap.set("n", "grL", function()
        local conf = vim.diagnostic.config()
        if conf then
            conf["virtual_lines"] = not conf["virtual_lines"]
            vim.diagnostic.config(conf)
        end
    end, { noremap = true, desc = "Toggle virtual (L)ines diagnostics", buffer = bufnr })

    vim.keymap.set("n", "grd", vim.lsp.buf.declaration, { silent = true, buffer = 0, desc = "Go to (d)eclaration" })
    vim.keymap.set(
        "n",
        "grv",
        vim.diagnostic.open_float,
        { silent = true, buffer = 0, desc = "Show (v)irtual text diagnostics" }
    )

    if client.server_capabilities.inlayHintProvider then
        vim.lsp.inlay_hint.enable(false, { bufnr = bufnr })
        vim.keymap.set("n", "grI", function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled(bufnr), { bufnr = bufnr })
        end, { noremap = true, desc = "Toggle (I)nlay hints" })
    end
end

vim.lsp.config("*", {
    capabilities = require("blink.cmp").get_lsp_capabilities(),
    on_attach = on_attach,
})
