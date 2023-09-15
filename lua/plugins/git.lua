return {
    { 'tpope/vim-git' },
    {
        'tpope/vim-fugitive',
        config = function()
            vim.api.nvim_set_keymap('n', 'git', ':Git', { noremap = true })
            vim.api.nvim_set_keymap('n', '<leader>gs', ':Git<CR>', { noremap = true })
            vim.api.nvim_set_keymap('n', '<leader>ga', ':Git commit -a<CR>', { noremap = true })
            vim.api.nvim_set_keymap('n', '<leader>gd', ':Git diff<CR>', { noremap = true })
            vim.api.nvim_set_keymap('n', '<leader>gP', ':Git pull<CR>', { noremap = true })
            vim.api.nvim_set_keymap('n', '<leader>gp', ':Git push<CR>', { noremap = true })
            vim.api.nvim_set_keymap('n', '<leader>g/', ':Git grep<CR>', { noremap = true })
        end
    },
    { 'junegunn/gv.vim' },
    {
        'lewis6991/gitsigns.nvim',
        config = function()
            require('gitsigns').setup({
                signs = {
                    untracked    = { text = '╿' },
                },
                on_attach = function(bufnr)
                    local gs = require("gitsigns")
                    vim.keymap.set("n", "]h", gs.next_hunk, { noremap = true })
                    vim.keymap.set("n", "[h", gs.prev_hunk, { noremap = true })
                    vim.keymap.set("n", "ghs", gs.stage_hunk, { noremap = true })
                    vim.keymap.set("n", "ghu", gs.undo_stage_hunk, { noremap = true })
                end
            })
        end
    },
    { 'f-person/git-blame.nvim', init = function() vim.g.gitblame_enabled = 0 end },
}
