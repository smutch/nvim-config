-- LSP
local M = {}

-- local h = require("helpers")
-- vim.lsp.set_log_level("debug")

vim.cmd("hi LspDiagnosticsVirtualTextWarning guifg=#7d5500")
vim.cmd("hi! link SignColumn Normal")

vim.diagnostic.config({
    underline = true,
    virtual_text = false,
    signs = true,
    update_in_insert = false,
    severity_sort = true,
    virtual_lines = false,
})

local function toggle_lsp_virtual_lines()
    local conf = vim.diagnostic.config()
    if conf and not conf.virtual_lines then
        conf.virtual_lines = true
    else
        conf.virtual_text = false
    end
    vim.diagnostic.config(conf)
end

vim.keymap.set("n", "grL", toggle_lsp_virtual_lines, { noremap = true, desc = "Toggle virtual (L)ines diagnostics" })

local function toggle_lsp_inlay_hints(bufnr)
    if vim.lsp.inlay_hint.is_enabled(bufnr) then
        if vim.version.lt(vim.version(), vim.version("v0.10.0-dev")) then
            vim.lsp.inlay_hint.enable(false)
        else
            vim.lsp.inlay_hint.enable(false, { bufnr = bufnr })
        end
    else
        if vim.version.lt(vim.version(), vim.version("v0.10.0-dev")) then
            vim.lsp.inlay_hint.enable(true)
        else
            vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
        end
    end
end

local on_attach = function(client, bufnr)
    -- Keybindings for LSPs
    -- Note these are in on_attach so that they don't override bindings in a non-LSP setting
    -- NOTE: Also see the Namu bindings
    vim.keymap.set("n", "grd", vim.lsp.buf.definition, { silent = true, buffer = 0 })
    vim.keymap.set("n", "grD", vim.lsp.buf.declaration, { silent = true, buffer = 0 })
    vim.keymap.set("n", "grt", vim.lsp.buf.type_definition, { silent = true, buffer = 0 })
    vim.keymap.set("n", "grs", vim.lsp.buf.signature_help, { silent = true, buffer = 0 })
    vim.keymap.set("n", "g/", vim.diagnostic.open_float, { silent = true, buffer = 0 })
    if client.name == "rust_analyzer" then
        vim.keymap.set("n", "K", function()
            vim.cmd.RustLsp({ "hover", "actions" })
        end, { noremap = true, silent = true, buffer = bufnr })
        vim.keymap.set("n", "gre", function()
            vim.cmd.RustLsp("explainError")
        end, { noremap = true, silent = true, buffer = bufnr })
    end

    vim.api.nvim_command('call sign_define("DiagnosticSignError", {"text" : "", "texthl" : "DiagnosticSignError"})')
    vim.api.nvim_command('call sign_define("DiagnosticSignWarn", {"text" : "", "texthl" : "DiagnosticSignWarn"})')
    vim.api.nvim_command('call sign_define("DiagnosticSignInfo", {"text" : "", "texthl" : "DiagnosticSignInfo"})')
    vim.api.nvim_command('call sign_define("DiagnosticSignHint", {"text" : "", "texthl" : "DiagnosticSignHint"})')

    vim.g.lsp_diagnostic_sign_priority = 100

    if client.server_capabilities.inlayHintProvider then
        vim.lsp.inlay_hint.enable(false, { bufnr = bufnr })
        vim.keymap.set("n", "grI", toggle_lsp_inlay_hints, { noremap = true, desc = "Toggle (i)nlay hints" })
    end

    if client.server_capabilities.documentSymbolProvider then
        require("nvim-navic").attach(client, bufnr)
    end
end

local capabilities = require("blink.cmp").get_lsp_capabilities()

-- nvim-ufo
capabilities.textDocument.foldingRange = { dynamicRegistration = false, lineFoldingOnly = true }

vim.lsp.config("*", {
    capabilities = capabilities,
    on_attach = on_attach,
})

local augrp = vim.api.nvim_create_augroup("LSP", {})
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "janet" },
    group = augrp,
    callback = function(ev)
        if string.sub(vim.fn.expand("%"), 1, string.len("conjure-log")) == "conjure-log" then
            return
        end
        local path = "janet-lsp"
        if vim.fn.has("macunix") == 1 then
            -- path = vim.trim(vim.fn.system([[brew info janet | rg -A1 Installed | tail -n1 | cut -d' ' -f1]])) .. "/bin/janet-lsp"
            path = "/opt/homebrew/bin/janet-lsp"
        end
        vim.lsp.start({
            name = "janet-lsp",
            cmd = { path },
            root_dir = (function()
                local root = vim.fs.root(ev.buf, { "project.janet" })
                if not root then
                    root = vim.fs.dirname(vim.fn.expand("%:p"))
                end
                return root
            end)(),
            on_attach = on_attach,
            capabilities = capabilities,
        })
    end,
})

M.on_attach = on_attach
return M
