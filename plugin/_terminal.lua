-- vim.env.LAUNCHED_FROM_NVIM = 1
-- vim.env.NVIM_LISTEN_ADDRESS = vim.v.servername

local term_augroup = vim.api.nvim_create_augroup("user_term", { clear = true })
vim.api.nvim_create_autocmd({ "TermOpen", "TermEnter" }, {
    pattern = { [[term://*]] },
    group = term_augroup,
    callback = function()
        vim.wo.winhighlight = "Normal:TermNormal"
        vim.wo.cursorline = false
        vim.wo.number = false
        vim.wo.relativenumber = false
        -- vim.cmd.startinsert()
    end,
})

vim.keymap.set("t", "kj", [[<C-\><C-n>]])
vim.keymap.set("t", "<C-h>", [[<C-\><C-n><C-w>h]])
vim.keymap.set("t", "<C-j>", [[<C-\><C-n><C-w>j]])
vim.keymap.set("t", "<C-k>", [[<C-\><C-n><C-w>k]])
vim.keymap.set("t", "<C-l>", [[<C-\><C-n><C-w>l]])
vim.keymap.set("t", "<C-w>", [[<C-\><C-n><C-w>]])
