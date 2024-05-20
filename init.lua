vim.g.mapleader = " "
vim.g.localleader = "\\"

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
    {
        checker = {
            enabled = true,
            concurrency = 16,
            frequency = 3600 * 24 * 7,
        }
    }
)
