return {
    {
        "folke/lazydev.nvim",
        ft = "lua", -- only load on lua files
        opts = {
            library = {
                -- Library items can be absolute paths
                -- "~/projects/my-awesome-lib",
                -- Or relative, which means they will be resolved as a plugin
                -- "LazyVim",
                -- When relative, you can also provide a path to the library in the plugin dir
                "luvit-meta/library", -- see below
            },
        },
    },
    { "Bilal2453/luvit-meta", lazy = true }, -- optional `vim.uv` typings
    {
        'neovim/nvim-lspconfig',
        dependencies = {
            { 'williamboman/mason.nvim',           config = true },
            { "williamboman/mason-lspconfig.nvim", config = true },
            {
                'WhoIsSethDaniel/mason-tool-installer.nvim',
                opts = {
                    ensure_installed = {
                        'lua-language-server',
                        'stylua',
                        'shellcheck',
                        'basedpyright',
                        'ruff-lsp'
                    }
                }
            },
        },
        config = function()
            require 'plugins.config.lsp'
        end
    },
    { 'nvimtools/none-ls.nvim' },
    {
        'kosayoda/nvim-lightbulb',
        config = function()
            vim.fn.sign_define('LightBulbSign', { text = "", texthl = "", linehl = "", numhl = "" })
            local augrp = vim.api.nvim_create_augroup("Projects", {})
            vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
                group = augrp,
                pattern = { "*" },
                callback = require 'nvim-lightbulb'.update_lightbulb
            })
        end
    },
    {
        'folke/lsp-trouble.nvim',
        config = function()
            require "trouble".setup()
            -- Load up last search in buffer into the location list and open it
            vim.keymap.set('n', '<leader>L', ':<C-u>lvimgrep // % | Trouble loclist<CR>')
        end
    },
    {
        'mrcjkb/rustaceanvim',
        version = '^4', -- Recommended
        ft = { 'rust' },
        config = function()
            vim.g.rustaceanvim = {
                -- Plugin configuration
                tools = {
                },
                -- LSP configuration
                server = {
                    on_attach = require 'plugins.config.lsp'.on_attach,
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
            vim.keymap.set("", "gP", require("lsp_lines").toggle, { desc = "Toggle lsp_lines (p)roblems" })
        end
    },
    -- TODO: Come back and try this again when more mature. Really love the idea!
    -- {
    --     "RaafatTurki/corn.nvim",
    --     config = true
    -- }
}
