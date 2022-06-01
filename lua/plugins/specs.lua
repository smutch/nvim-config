local M = {}

function M.config()
    require('specs').setup {
        popup = { inc_ms = 10, width = 50, winhl = "DiffText", resizer = require('specs').slide_resizer },
        ignore_filetypes = { "rust" }
    }
end

return M

