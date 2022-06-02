local M = {}

function M.config()
    require('auto-session').setup {
        post_restore_cmds = { "stopinsert" }
    }
end

return M

