local M = {}

function M.config()
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

    -- vim.cmd [[hi! link TelescopeResultsTitle TodoBgNOTE]]
    -- vim.cmd [[hi! link TelescopePromptTitle TodoBgTODO]]
    -- vim.cmd [[hi! link TelescopePreviewTitle TodoBgHACK]]
end

return M

