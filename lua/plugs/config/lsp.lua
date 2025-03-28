-- LSP
local M = {}

local h = require("helpers")
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

-- using rachartier/tiny-inline-diagnostic.nvim for this now
--[[ local function toggle_lsp_virtual_text()
    local conf = vim.diagnostic.config()
    if conf.virtual_text == false then
        conf.virtual_text = { spacing = 4 }
    else
        conf.virtual_text = false
    end
    vim.diagnostic.config(conf)
end
vim.keymap.set("n", "grv", toggle_lsp_virtual_text, { noremap = true, desc = "Toggle (v)irtual text diagnostics" }) ]]

local function toggle_lsp_virtual_lines()
    local conf = vim.diagnostic.config()
    if conf.virtual_lines == false then
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
            vim.lsp.inlay_hint.enable(bufnr, false)
        else
            vim.lsp.inlay_hint.enable(false, { bufnr = bufnr })
        end
    else
        if vim.version.lt(vim.version(), vim.version("v0.10.0-dev")) then
            vim.lsp.inlay_hint.enable(bufnr, true)
        else
            vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
        end
    end
end

local on_attach = function(client, bufnr)
    -- Keybindings for LSPs
    -- Note these are in on_attach so that they don't override bindings in a non-LSP setting
    vim.keymap.set("n", "grd", vim.lsp.buf.definition, { silent = true, buffer = 0 })
    vim.keymap.set("n", "grD", vim.lsp.buf.declaration, { silent = true, buffer = 0 })
    vim.keymap.set("n", "grt", vim.lsp.buf.type_definition, { silent = true, buffer = 0 })
    vim.keymap.set("n", "grs", vim.lsp.buf.signature_help, { silent = true, buffer = 0 })
    vim.keymap.set("n", "gr?", "<cmd>Telescope lsp_dynamic_workspace_symbols<CR>", { silent = true, buffer = 0 })
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

require("mason-lspconfig").setup_handlers({
    function(server_name) -- default handler (optional)
        require("lspconfig")[server_name].setup({
            on_attach = on_attach,
            capabilities = capabilities,
        })
    end,

    ["basedpyright"] = function()
        require("lspconfig").basedpyright.setup({
            on_attach = on_attach,
            capabilities = capabilities,
            settings = {
                basedpyright = { analysis = { typeCheckingMode = "standard" } },
                python = { pythonPath = h.python_interpreter_path },
            },
        })
    end,

    ["ruff"] = function()
        require("lspconfig").ruff.setup({
            on_attach = function(client, bufnr)
                client.server_capabilities.hoverProvider = false
                on_attach(client, bufnr)
            end,
        })
    end,

    ["lua_ls"] = function()
        require("lspconfig").lua_ls.setup({
            on_attach = on_attach,
            capabilities = capabilities,
            diagnostics = { globals = { "vim" } },
            workspace = { preloadFileSize = 500 },
            format = { enable = false },
        })
    end,

    ["hls"] = function()
        require("lspconfig").hls.setup({
            on_attach = on_attach,
            capabilities = capabilities,
            filetypes = { "haskell", "lhaskell", "cabal" },
        })
    end,

    ["emmet_language_server"] = function()
        require("lspconfig").emmet_language_server.setup({
            filetypes = {
                "css",
                "eruby",
                "html",
                "javascript",
                "javascriptreact",
                "less",
                "sass",
                "scss",
                "pug",
                "typescriptreact",
                "astro",
            },
            on_attach = on_attach,
            capabilities = capabilities,
        })
    end,

    -- Rustacean.nvim demands that we don't set up the LSP server here...
    ["rust_analyzer"] = function() end,

    ["ts_ls"] = function()
        require("lspconfig").ts_ls.setup({
            filetypes = { "typescript", "javascript", "js", "ojs" },
            on_attach = on_attach,
            capabilities = capabilities,
        })
    end,

    ["tinymist"] = function()
        require("lspconfig").tinymist.setup({
            settings = {
                formatterMode = "typstyle",
            },
            on_attach = on_attach,
            capabilities = capabilities,
        })
    end,
})

-- local function julials_on_attach(client, bufnr)
--     if vim.diagnostic.is_enabled() then
--         local original_set = vim.diagnostic.set
--         vim.diagnostic.set = function(namespace, bufnr, diagnostics, opts)
--             local filtered = vim.tbl_filter(function(diagnostic)
--                 if diagnostic.message:match("Missing reference") then
--                     return false
--                 end
--                 return true
--             end, diagnostics)
--             original_set(namespace, bufnr, filtered, opts)
--         end
--     end
--     on_attach(client, bufnr)
-- end

require("lspconfig").julials.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    -- settings = {
    --     julia = {
    --         environmentPath = "./",
    --     },
    -- },
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

require("conform").setup({
    default_format_opts = {
        lsp_format = "fallback",
    },
    formatters_by_ft = {
        lua = { "stylua" },
        -- Conform will run multiple formatters sequentially
        python = { "ruff_format" },
        -- You can customize some of the format options for the filetype (:help conform.format)
        rust = { "rustfmt" },
        -- Conform will run the first available formatter
        javascript = { "prettierd", "prettier", stop_after_first = true },
        html = { "prettierd", "prettier", stop_after_first = true },
        json = { "prettierd", "prettier", stop_after_first = true },
        yaml = { "prettierd", "prettier", stop_after_first = true },
        markdown = { "prettierd", "prettier", stop_after_first = true },
        bash = { "shfmt" },
        sh = { "shfmt" },
        quarto = { "injected" },
    },
})
vim.keymap.set("n", "<localleader>f", "<cmd>lua require('conform').format()<CR>", { silent = true })

M.on_attach = on_attach
return M
