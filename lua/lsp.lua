-- LSP
local M = {}

local h = require 'helpers'
-- vim.lsp.set_log_level("debug")

vim.cmd("hi LspDiagnosticsVirtualTextWarning guifg=#7d5500")
vim.cmd("hi! link SignColumn Normal")

vim.diagnostic.config({
    underline = true,
    virtual_text = false,
    signs = true,
    update_in_insert = false,
    severity_sort = true,
})

local function toggle_lsp_virtual_text()
    local conf = vim.diagnostic.config()
    if conf.virtual_text == false then
        conf.virtual_text = { spacing = 4 }
    else
        conf.virtual_text = false
    end
    vim.diagnostic.config(conf)
end

local function toggle_lsp_inlay_hints(bufnr)
    if vim.lsp.inlay_hint.is_enabled(bufnr) then
        vim.lsp.inlay_hint.enable(bufnr, false)
    else
        vim.lsp.inlay_hint.enable(bufnr, true)
    end
end

vim.keymap.set("n", "gV", toggle_lsp_virtual_text, { noremap = true, desc = "Toggle virtual text for LSP diagnostics" })

local on_attach = function(client, bufnr)
    -- Keybindings for LSPs
    -- Note these are in on_attach so that they don't override bindings in a non-LSP setting
    local function bnoremap(...) h.bnoremap(bufnr, ...) end

    bnoremap("n", "gd", "<cmd>Telescope lsp_definitions<CR>", { silent = true })
    bnoremap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", { silent = true })
    bnoremap("n", "1gd", "<cmd>Telescope lsp_type_definitions<CR>", { silent = true })
    bnoremap("n", "gm", "<cmd>Telescope lsp_implementations<CR>", { silent = true })
    bnoremap("n", "gk", "<cmd>lua vim.lsp.buf.signature_help()<CR>", { silent = true })
    bnoremap("n", "gR", "<cmd>lua vim.lsp.buf.rename()<CR>", { silent = true })
    bnoremap("n", "gr", "<cmd>Telescope lsp_references<CR>", { silent = true })
    bnoremap("n", "1g/", "<cmd>Telescope lsp_document_symbols<CR>", { silent = true })
    bnoremap("n", "g/", ":Telescope lsp_dynamic_workspace_symbols<CR>", { silent = true })
    bnoremap("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>", { silent = true })
    bnoremap("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>", { silent = true })
    bnoremap("n", "gl", "<cmd>lua vim.diagnostic.open_float()<CR>", { silent = true })
    bnoremap("n", "<localleader>d", "<cmd>Trouble document_diagnostics<cr>", { silent = true })
    bnoremap("n", "<localleader>f", "<cmd>lua vim.lsp.buf.format()<CR>", { silent = true })
    bnoremap("n", "ga", "<cmd>lua vim.lsp.buf.code_action()<CR>", { silent = true })
    if client.name ~= "rust_analyzer" then
        bnoremap("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", { silent = true })
    else
        vim.keymap.set("n", "K", function() vim.cmd.RustLsp { 'hover', 'actions' } end,
            { noremap = true, silent = true, buffer = bufnr })
        vim.keymap.set("n", "gL", function() vim.cmd.RustLsp('explainError') end,
            { noremap = true, silent = true, buffer = bufnr })
    end

    vim.api.nvim_command(
        'call sign_define("DiagnosticSignError", {"text" : "", "texthl" : "DiagnosticSignError"})')
    vim.api.nvim_command(
        'call sign_define("DiagnosticSignWarn", {"text" : "", "texthl" : "DiagnosticSignWarn"})')
    vim.api.nvim_command(
        'call sign_define("DiagnosticSignInformation", {"text" : "", "texthl" : "DiagnosticSignInformation"})')
    vim.api.nvim_command(
        'call sign_define("DiagnosticSignHint", {"text" : "", "texthl" : "DiagnosticSignHint"})')

    vim.g.lsp_diagnostic_sign_priority = 100

    if client.server_capabilities.inlayHintProvider then
        vim.lsp.inlay_hint.enable(bufnr, true)
        vim.keymap.set("n", "gI", toggle_lsp_inlay_hints, { noremap = true, desc = "Toggle inlay hints" })
    end

    if client.name == "ruff_lsp" then
        client.server_capabilities.hoverProvider = false
    end
end

-- nvim-ufo
local capabilities = require('cmp_nvim_lsp').default_capabilities()
capabilities.textDocument.foldingRange = { dynamicRegistration = false, lineFoldingOnly = true }

local lspconfig = require("lspconfig")
lspconfig.pylsp.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
        pylsp = {
            plugins = {
                -- disable everything I don't want
                autopep8 = { enabled = false },
                yapf = { enabled = false },
                pylint = { enabled = false },
                pyflakes = { enabled = false },
                pycodestyle = { enabled = false },
                mccabe = { enabled = false },

                -- set up the stuff I do
                black = { enabled = true },
                jedi = { environment = h.python_prefix, fuzzy = true },
                ruff = { enabled = true, extendSelect = { "I", "F" } },
                pylsp_mypy = {
                    enabled = true,
                    dmypy = true,
                    overrides = { "--python-executable", h.python_interpreter_path, true },
                    report_progress = false
                }
            }
        }
    }
}

-- lspconfig.pyright.setup {
--     on_attach = on_attach,
--     capabilities = capabilities,
--     python = {
--         analysis = { typeCheckingMode = "off" }  -- <- This seems to be ignored
--     }
-- }

lspconfig.lua_ls.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    diagnostics = { globals = { 'vim' } },
    workspace = { preloadFileSize = 500 },
    format = { enable = false }
}

lspconfig.julials.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    julia = {
        environmentPath = "./"
    }
}

-- lspconfig.rust_analyzer.setup {
--     on_attach = on_attach,
--     capabilities = capabilities,
--     settings = {
--         ['rust-analyzer'] = {
--             tools = {
--                 inlay_hints = {
--                     max_len_align = true,
--                     max_len_align_padding = 2
--                 }
--             }
--         }
--     }
-- }

require 'lspconfig'.typst_lsp.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
        exportPdf = "onSave" -- Choose onType, onSave or never.
    }
}

require 'lspconfig'.hls.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    filetypes = { 'haskell', 'lhaskell', 'cabal' },
}

require 'lspconfig'.nil_ls.setup {
    on_attach = on_attach,
    capabilities = capabilities,
}

require 'lspconfig'.ocamllsp.setup {
    on_attach = on_attach,
    capabilities = capabilities,
}

require 'lspconfig'.astro.setup {
    on_attach = on_attach,
    capabilities = capabilities,
}

require 'lspconfig'.tailwindCSS.setup {
    on_attach = on_attach,
    capabilities = capabilities,
}

require 'lspconfig'.clangd.setup {
    on_attach = on_attach,
    capabilities = capabilities,
}

local null_ls = require("null-ls")
null_ls.setup {
    sources = {
        -- null_ls.builtins.formatting.black.with {
        --     -- command = h.python_prefix .. 'black',
        --     command = 'black',
        --     extra_args = function(params)
        --         if not h.file_exists('pyproject.toml') then
        --             return { "-l", "88" }
        --         else
        --             return {}
        --         end
        --     end
        -- },
        -- null_ls.builtins.formatting.isort.with {
        --     -- command = h.python_prefix .. '/bin/isort'
        --     command = 'isort'
        -- },
        null_ls.builtins.formatting.prettier.with({
            filetypes = { "html", "json", "yaml", "markdown" },
            args = { "--print-width=1000" }
        }),
        null_ls.builtins.formatting.nimpretty,
        null_ls.builtins.formatting.ocamlformat,
        null_ls.builtins.diagnostics.chktex,
        null_ls.builtins.formatting.beautysh,
        -- null_ls.builtins.diagnostics.ruff.with({
        --     extra_args = { "--line-length=88" }
        -- }),
        -- null_ls.builtins.diagnostics.mypy.with({
        --     extra_args = { "--install-types" }
        -- }),
    },
    on_attach = on_attach,
    fallback_severity = vim.diagnostic.severity.HINT
}

M.on_attach = on_attach
return M
