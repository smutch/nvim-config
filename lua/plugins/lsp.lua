return {
    {
        "folke/lazydev.nvim",
        ft = "lua", -- only load on lua files
        opts = {
            debug = false,
            library = {
                -- See the configuration section for more details
                -- Load luvit types when the `vim.uv` word is found
                { path = "${3rd}/luv/library", words = { "vim%.uv" } },
                { path = "LazyVim", words = { "LazyVim" } },
            },
        },
    },
    { "Bilal2453/luvit-meta", lazy = true }, -- optional `vim.uv` typings
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            { "mason-org/mason.nvim", config = true },
            {
                "mason-org/mason-lspconfig.nvim",
                opts = {
                    automatic_enable = {
                        exclude = {
                            "rust_analyzer", -- handled by rustaceanvim
                        },
                    },
                },
            },
        },
        config = function()
            require("plugins.config.lsp")
        end,
    },
    {
        "kosayoda/nvim-lightbulb",
        opts = { autocmd = { enabled = true } },
    },
    {
        "folke/lsp-trouble.nvim",
        opts = {},
    },
    {
        "mrcjkb/rustaceanvim",
        version = "^6", -- Recommended
        ft = { "rust" },
        lazy = false,
        config = function()
            vim.g.rustaceanvim = {
                -- Plugin configuration
                tools = {},
                -- LSP configuration
                server = {
                    on_attach = require("plugins.config.lsp").on_attach,
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
                dap = {},
            }
        end,
    },
    -- TODO: Come back and try this again when more mature. Really love the idea!
    -- {
    --     "RaafatTurki/corn.nvim",
    --     config = true
    -- }
    {
        "rachartier/tiny-inline-diagnostic.nvim",
        event = "VeryLazy",
        proiority = 1000,
        opts = {
            preset = "modern",
            hi = {
                background = "#1d2939", -- Can be a highlight or a hexadecimal color (#RRGGBB)
            },
        },
        keys = {
            {
                "grv",
                function()
                    require("tiny-inline-diagnostic").toggle()
                end,
                desc = "Toggle (v)irtual text diagnostics",
            },
        },
    },
    {
        "stevearc/conform.nvim",
        opts = {
            default_format_opts = {
                lsp_format = "fallback",
            },
            formatters_by_ft = {
                lua = { "stylua" },
                -- Conform will run multiple formatters sequentially
                python = { "ruff_organize_imports", "ruff_format" },
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
        },
        keys = {
            {
                "<localleader>f",
                function()
                    require("conform").format()
                end,
                desc = "Format code using conform",
                silent = true,
            },
        },
    },
    {
        "mfussenegger/nvim-lint",
        opts = {},
        config = function()
            local lint = require("lint")
            lint.linters_by_ft = {
                markdown = { "codespell" },
                typst = { "codespell" },
            }

            local ignore_words = { "Mutch" }

            lint.linters.codespell.args = { "--stdin-single-line", "-L", table.concat(ignore_words, ","), "-" }

            vim.api.nvim_create_augroup("Linters", { clear = true })

            vim.api.nvim_create_autocmd("BufWritePost", {
                group = "Linters",
                pattern = { "*.md", "*.typ" },
                callback = function()
                    lint.try_lint()
                end,
            })
        end,
    },
}
