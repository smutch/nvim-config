return {
    {
        "AckslD/nvim-neoclip.lua",
        event = "VeryLazy",
        dependencies = {
            { 'nvim-telescope/telescope.nvim' }
        },
        config = function()
            require('neoclip').setup()
            vim.api.nvim_set_keymap('n', '<leader>fv', '<cmd>Telescope neoclip<cr>', { noremap = true })

            local actions = require "telescope.actions"
            require("telescope").setup {
                defaults = {
                    vimgrep_arguments = {
                        "rg",
                        "--color=never",
                        "--no-heading",
                        "--with-filename",
                        "--line-number",
                        "--column",
                        "--smart-case",
                    },
                    prompt_prefix = "  ",
                    selection_caret = "  ",
                    entry_prefix = "  ",
                    mappings = {
                        n = { ["q"] = actions.close },
                        i = {
                            ["<c-d>"] = actions.delete_buffer + actions.move_to_top,
                        },
                    },
                },
                extensions_list = { "themes", "terms" },
            }
        end
    },
    {
        'nvim-telescope/telescope.nvim',
        event = "VeryLazy",
        dependencies = {
            { "polirritmico/telescope-lazy-plugins.nvim", event = "VeryLazy" },
            { 'nvim-telescope/telescope-fzy-native.nvim', run = 'make -C deps/fzy-lua-native' },
            { 'xiyaowong/telescope-emoji.nvim',           event = "VeryLazy" },
            { 'nvim-telescope/telescope-symbols.nvim',    event = "VeryLazy" },
            { 'nvim-telescope/telescope-ui-select.nvim',  event = "VeryLazy" },
            { "nvim-lua/plenary.nvim",                    event = "VeryLazy" },
            { "debugloop/telescope-undo.nvim",            event = "VeryLazy" },
        },
        config = function() require 'plugs.config.telescope' end
    }
}
