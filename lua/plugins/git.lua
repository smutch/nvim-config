return {
    { 'tpope/vim-git' },
    {
        'tpope/vim-fugitive',
        config = function()
            vim.keymap.set('n', '<leader>g:', ':Git ')
            vim.keymap.set('n', '<leader>gs', ':Git<CR>')
            vim.keymap.set('n', '<leader>ga', ':Git commit -a<CR>')
            vim.keymap.set('n', '<leader>gd', ':Git diff<CR>')
            vim.keymap.set('n', '<leader>gp', ':Git pull<CR>')
            vim.keymap.set('n', '<leader>gP', ':Git push<CR>')
            vim.keymap.set('n', '<leader>g/', ':Git grep<CR>')
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
    { 'f-person/git-blame.nvim', config = {enabled = false} },
    { 'sindrets/diffview.nvim', cmd = "DiffviewOpen" },
}
