vim.g.mapleader = " "
vim.g.localleader = "\\"

if vim.loop.fs_stat(vim.fn.stdpath("config") .. "/lua/system.lua") then
    require "system"
end

-- lazy
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins",
    vim.tbl_extend(
        "error",
        {
            checker = {
                enabled = true,
                concurrency = 16,
                frequency = 3600 * 24 * 7,
            }
        },
        require "init-vscode"
    )
)

vim.api.nvim_create_user_command("Erc", function() vim.cmd("edit ~/.config/nvim/init.lua") end, {})
vim.api.nvim_create_user_command("Eplug", function() vim.cmd("edit ~/.config/nvim/lua/plugins") end, {})
