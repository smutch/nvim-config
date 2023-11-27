return {
    { 'williamboman/mason.nvim',           config = true },
    { "williamboman/mason-lspconfig.nvim", config = true },
    {
        'WhoIsSethDaniel/mason-tool-installer.nvim',
        opts = {
            ensure_installed = {
                'lua-language-server',
                'stylua',
                'shellcheck',
                'python-lsp-server',
            }
        }
    },
    { 'neovim/nvim-lspconfig' },
    -- {
    --     'ray-x/lsp_signature.nvim',
    --     config = function()
    --         require'lsp_signature'.setup { fix_pos = true, hint_enable = false, hint_prefix = " " }
    --         vim.cmd([[hi link LspSignatureActiveParameter SpellBad]])
    --     end
    -- },
    { 'nvimtools/none-ls.nvim' },
    {
        'kosayoda/nvim-lightbulb',
        config = function()
            local augrp = vim.api.nvim_create_augroup("Projects", {})
            vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
                group = augrp,
                pattern = { "*" },
                callback = require 'nvim-lightbulb'.update_lightbulb
            })
            vim.fn.sign_define('LightBulbSign', { text = "", texthl = "", linehl = "", numhl = "" })
        end
    },
    {
        'folke/lsp-trouble.nvim',
        config = function()
            require "trouble".setup()
            -- Load up last search in buffer into the location list and open it
            require "helpers".noremap('n', '<leader>L', ':<C-u>lvimgrep // % | Trouble loclist<CR>')
        end
    },
    -- { 'j-hui/fidget.nvim', config = true },
    {
        'mrcjkb/rustaceanvim',
        version = '^3', -- Recommended
        ft = { 'rust' },
        config = function()
            vim.g.rustaceanvim = {
                -- Plugin configuration
                tools = {
                },
                -- LSP configuration
                server = {
                    on_attach = function(client, bufnr)
                        -- you can also put keymaps in here
                        vim.keymap.set("n", "K", function() vim.cmd.RustLsp { 'hover', 'actions' } end,
                            { noremap = true, silent = true })
                        vim.keymap.set("n", "gL", function() vim.cmd.RustLsp('explainError') end,
                            { noremap = true, silent = true })

                        vim.keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", { silent = true, buffer = true })
                        vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>",
                            { silent = true, buffer = true })
                        vim.keymap.set("n", "1gd", "<cmd>Telescope lsp_type_definitions<CR>",
                            { silent = true, buffer = true })
                        vim.keymap.set("n", "gm", "<cmd>Telescope lsp_implementations<CR>",
                            { silent = true, buffer = true })
                        vim.keymap.set("n", "gk", "<cmd>lua vim.lsp.buf.signature_help()<CR>",
                            { silent = true, buffer = true })
                        vim.keymap.set("n", "gR", "<cmd>lua vim.lsp.buf.rename()<CR>", { silent = true, buffer = true })
                        vim.keymap.set("n", "gr", "<cmd>Telescope lsp_references<CR>", { silent = true, buffer = true })
                        vim.keymap.set("n", "ga", "<cmd>lua vim.lsp.buf.code_action()<CR>", { silent = true, buffer = true })
                        vim.keymap.set("n", "1g/", "<cmd>Telescope lsp_document_symbols<CR>",
                            { silent = true, buffer = true })
                        vim.keymap.set("n", "g/", ":Telescope lsp_dynamic_workspace_symbols<CR>",
                            { silent = true, buffer = true })
                        vim.keymap.set("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>",
                            { silent = true, buffer = true })
                        vim.keymap.set("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>",
                            { silent = true, buffer = true })
                        vim.keymap.set("n", "gl", "<cmd>lua vim.diagnostic.open_float()<CR>",
                            { silent = true, buffer = true })
                        vim.keymap.set("n", "<localleader>d", "<cmd>Trouble document_diagnostics<cr>",
                            { silent = true, buffer = true })
                        vim.keymap.set("n", "<localleader>f", "<cmd>lua vim.lsp.buf.format()<CR>",
                            { silent = true, buffer = true })
                        vim.api.nvim_command(
                            'call sign_define("DiagnosticSignError", {"text" : "", "texthl" : "DiagnosticSignError"})')
                        vim.api.nvim_command(
                            'call sign_define("DiagnosticSignWarn", {"text" : "", "texthl" : "DiagnosticSignWarn"})')
                        vim.api.nvim_command(
                            'call sign_define("DiagnosticSignInformation", {"text" : "", "texthl" : "DiagnosticSignInformation"})')
                        vim.api.nvim_command(
                            'call sign_define("DiagnosticSignHint", {"text" : "", "texthl" : "DiagnosticSignHint"})')

                        vim.g.lsp_diagnostic_sign_priority = 100

                        if client.name == "ruff_lsp" then
                            client.server_capabilities.hoverProvider = false
                        end
                    end,
                    settings = {
                        -- rust-analyzer language server configuration
                        ['rust-analyzer'] = {
                            tools = {
                                inlay_hints = {
                                    max_len_align = true,
                                    max_len_align_padding = 2
                                }
                            }
                        },
                    },
                },
                -- DAP configuration
                dap = {
                },
            }
        end
    },
    {
        "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
        config = function()
            require("lsp_lines").setup()
            vim.diagnostic.config({ virtual_lines = false })
            vim.keymap.set("", "<Leader>D", require("lsp_lines").toggle, { desc = "Toggle lsp_lines" })
        end
    }
}
