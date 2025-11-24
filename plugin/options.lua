vim.o.clipboard = "unnamedplus"
vim.o.spelllang = "en_gb"
vim.o.showmode = false
vim.o.exrc = true
vim.o.linebreak = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.laststatus = 3
vim.opt.listchars = { tab = [[▸\ ]], eol = "↵", trail = "·" }
vim.o.number = false -- Don't show line numbers
vim.o.ignorecase = true
vim.o.smartcase = true
vim.opt.splitkeep = "screen"

vim.o.backupdir = os.getenv("HOME") .. "/.nvim_backup"
vim.o.directory = os.getenv("HOME") .. "/.nvim_backup"
vim.o.undodir = os.getenv("HOME") .. "/.nvim_backup/undo"
vim.o.undofile = true

vim.opt.diffopt:append({ "algorithm:patience" })

vim.o.foldexpr = "nvim_treesitter#foldexpr()"
vim.o.foldmethod = "expr"
vim.o.foldenable = false

-- Include project specific options
if vim.env.EXTRA_NVIM then
    local paths = vim.split(vim.env.EXTRA_NVIM, ":", { plain = true, trimempty = true })
    for _, path in ipairs(paths) do
        local success, err = pcall(dofile, path)
        if not success then
            vim.notify("Error loading " .. path .. ": " .. tostring(err), vim.log.levels.ERROR)
        end
    end
end
