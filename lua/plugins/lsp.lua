return {
    { 'williamboman/mason.nvim', config = true },
    { "williamboman/mason-lspconfig.nvim", config = true },
    { 'WhoIsSethDaniel/mason-tool-installer.nvim', opts = {
        ensure_installed = {
            'lua-language-server',
            'stylua',
            'shellcheck',
            'python-lsp-server',
        }
    }},
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
            vim.api.nvim_create_autocmd({"CursorHold" , "CursorHoldI"}, {
                group = augrp,
                pattern = { "*" },
                callback = require'nvim-lightbulb'.update_lightbulb
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
    { 'simrat39/rust-tools.nvim', config = true },
    {
        "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
        config = function()
            require("lsp_lines").setup()
            vim.diagnostic.config({ virtual_lines = false })
            vim.keymap.set("", "<Leader>D", require("lsp_lines").toggle, { desc = "Toggle lsp_lines" })
        end
    }
}
