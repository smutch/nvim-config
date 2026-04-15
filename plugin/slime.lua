vim.pack.add(require("load").gh({"jpalardy/vim-slime"}))

vim.g.slime_target = "neovim"
vim.g.slime_no_mappings = 1
-- vim.g.slime_bracketed_paste = 1
vim.g.slime_python_ipython = 1

vim.keymap.set("n", "gz", "<Plug>SlimeRegionSend", { mode = "v", desc = "Send region" })
vim.keymap.set("n", "gz", "<Plug>SlimeMotionSend", { desc = "Send motion" })
vim.keymap.set("n", "gZ", "<Plug>SlimeLineSend", { desc = "Send line" })
