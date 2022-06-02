local M = {}

M.neotree_was_open = false

function M.config()
    vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal"

    require('auto-session').setup {
        pre_save_cmds = { "tabdo Neotree close" },
        post_save_cmds = { "tabdo Neotree show" },
        post_restore_cmds = { "stopinsert" }
    }
end

return M
