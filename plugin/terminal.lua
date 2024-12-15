vim.env.LAUNCHED_FROM_NVIM = 1
vim.env.NVIM_LISTEN_ADDRESS = vim.v.servername

local term_augroup = vim.api.nvim_create_augroup("MyTerm", {})
vim.api.nvim_create_autocmd({ "TermOpen", "TermEnter" }, {
    pattern = { [[term://*]] },
    group = term_augroup,
    callback = function()
        local status, Color = pcall(require, "nightfox.lib.color")
        if (status) then
            local normal = vim.api.nvim_get_hl(0, { name = 'Normal' })
            local bg = Color.from_hex(string.format("%06x", normal.bg)):brighten(-3):to_hex()
            vim.api.nvim_set_hl(0, "TermNormal", { bg = bg })
        end
        vim.wo.winhighlight = "Normal:TermNormal"
        vim.wo.cursorline = false
        vim.wo.number = false
        vim.wo.relativenumber = false
        -- vim.cmd.startinsert()
    end
})

vim.keymap.set('t', 'kj', [[<C-\><C-n>]])
vim.keymap.set('t', '<C-h>', [[<C-\><C-n><C-w>h]])
vim.keymap.set('t', '<C-j>', [[<C-\><C-n><C-w>j]])
vim.keymap.set('t', '<C-k>', [[<C-\><C-n><C-w>k]])
vim.keymap.set('t', '<C-l>', [[<C-\><C-n><C-w>l]])
vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]])
vim.keymap.set('n', '<leader>ts', ':botright 20split | setl wfh | term<cr>')
vim.keymap.set('n', '<leader>tv', ':botright 80vsplit | setl wfh | term<cr>')
