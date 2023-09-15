return {
    {
        "AckslD/nvim-neoclip.lua",
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
    { 'nvim-telescope/telescope-fzy-native.nvim', run = 'make -C deps/fzy-lua-native' },
    { 'xiyaowong/telescope-emoji.nvim' },
    { 'nvim-telescope/telescope-symbols.nvim' },
    { 'nvim-telescope/telescope-ui-select.nvim' },
    { 'tsakirist/telescope-lazy.nvim' },
    {
        'nvim-telescope/telescope.nvim',
        config = function()
            local h = require 'helpers'
            local telescope = require 'telescope'
            telescope.setup {
                pickers = {
                    find_files = { theme = "dropdown" },
                    git_files = { theme = "dropdown" },
                    old_files = { theme = "dropdown" },
                    buffers = { theme = "dropdown" },
                    marks = { theme = "dropdown" },
                    emoji = { theme = "dropdown" },
                    symbols = { theme = "dropdown" },
                },
                extensions = { ["ui-select"] = { require("telescope.themes").get_dropdown() }
                }
            }

            local extensions = { "fzy_native", "emoji", "neoclip", "ui-select", "lazy" }
            for _, extension in ipairs(extensions) do telescope.load_extension(extension) end

            h.noremap('n', '<leader>ff', '<cmd>Telescope find_files<cr>')
            h.noremap('n', '<leader>fg', '<cmd>Telescope git_files<cr>')
            h.noremap('n', '<leader>fb', '<cmd>Telescope buffers<cr>')
            h.noremap('n', '<leader>fh', '<cmd>Telescope oldfiles<cr>')
            h.noremap('n', '<leader>f?', '<cmd>Telescope help_tags<cr>')
            h.noremap('n', '<leader>f:', '<cmd>Telescope commands<cr>')
            h.noremap('n', '<leader>fm', '<cmd>Telescope marks<cr>')
            h.noremap('n', '<leader>fl', '<cmd>Telescope loclist<cr>')
            h.noremap('n', '<leader>fq', '<cmd>Telescope quickfix<cr>')
            h.noremap('n', [[<leader>f"]], '<cmd>Telescope registers<cr>')
            h.noremap('n', '<leader>fk', '<cmd>Telescope keymaps<cr>')
            h.noremap('n', '<leader>ft', '<cmd>Telescope treesitter<cr>')
            h.noremap('n', '<leader>fe', '<cmd>Telescope emoji<cr>')
            h.noremap('n', '<leader>f<leader>', '<cmd>Telescope<cr>')
            h.noremap('n', '<leader>fs', '<cmd>Telescope symbols<cr>')
            vim.keymap.set('n', 'z=',
                function() require 'telescope.builtin'.spell_suggest(require 'telescope.themes'.get_dropdown {}) end,
                { noremap = true })

            -- to fix gub introduced into neovim by vim patch
            -- (https://github.com/nvim-telescope/telescope.nvim/issues/2027#issuecomment-1510001730)
            local augroup = vim.api.nvim_create_augroup("Telescope", {})
            vim.api.nvim_create_autocmd({ "WinLeave" }, {
                group = augroup,
                callback = function()
                    if vim.bo.ft == "TelescopePrompt" and vim.fn.mode() == "i" then
                        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "i", false)
                    end
                end
            })
        end
    }
}
