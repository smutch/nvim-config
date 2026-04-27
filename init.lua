vim.g.mapleader = " "
vim.g.localleader = "\\"

if vim.loop.fs_stat(vim.fn.stdpath("config") .. "/lua/system.lua") then
    require("system")
end

vim.api.nvim_create_user_command("Erc", function()
    vim.cmd("tabedit ~/.config/nvim/init.lua")
end, {})
vim.api.nvim_create_user_command("Eplug", function()
    vim.cmd("tabedit ~/.config/nvim/plugin")
end, {})

-- new UI
pcall(require("vim._core.ui2").enable, {})

-- required for this setup
vim.pack.add({ "https://github.com/nvim-mini/mini.misc" })
