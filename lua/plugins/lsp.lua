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
                    on_attach = require'lsp'.on_attach,
                    -- settings = {
                    --     -- rust-analyzer language server configuration
                    --     ['rust-analyzer'] = {
                    --         tools = {
                    --             inlay_hints = {
                    --                 max_len_align = true,
                    --                 max_len_align_padding = 2
                    --             }
                    --         }
                    --     },
                    -- },
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
    },
    -- TODO: Come back and try this again when more mature. Really love the idea!
    -- {
    --     "RaafatTurki/corn.nvim",
    --     config = true
    -- }
}
