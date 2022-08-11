local M = {}

function M.config()
    local h = require 'helpers'
    local telescope = require 'telescope'
    telescope.setup {
        pickers = {
            find_files = { theme = "dropdown" } },
            extensions = { ["ui-select"] = { require("telescope.themes").get_dropdown() }
        }
    }

    local extensions = { "fzy_native", "packer", "emoji", "neoclip", "ui-select" }
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
    h.noremap('n', '<leader>fp', '<cmd>Telescope packer<cr>')
    h.noremap('n', '<leader>f<leader>', '<cmd>Telescope<cr>')
    h.noremap('n', '<leader>fs', '<cmd>Telescope symbols<cr>')
    vim.keymap.set('n', 'z=', function() require'telescope.builtin'.spell_suggest(require'telescope.themes'.get_dropdown{}) end, {noremap=true})
end

return M

