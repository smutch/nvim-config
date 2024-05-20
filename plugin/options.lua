vim.o.clipboard = "unnamedplus"
vim.o.spelllang = "en_gb"
vim.o.showmode = false
vim.o.exrc = true
vim.o.linebreak = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.laststatus = 3
vim.opt.listchars = { tab = [[▸\ ]], eol = '↵', trail = '·' }
vim.o.number = false -- Don't show line numbers
vim.o.smartcase = true

vim.o.backupdir = os.getenv('HOME') .. "/.nvim_backup"
vim.o.directory = os.getenv('HOME') .. "/.nvim_backup"
vim.o.undodir = os.getenv('HOME') .. "/.nvim_backup/undo"
vim.o.undofile = true

vim.opt.diffopt:append { "algorithm:patience" }

vim.o.colorscheme = "nighfox"
