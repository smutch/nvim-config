local M = {}

function M.config()
    require("neotest").setup({
        adapters = {
            require("neotest-python"){},
        },
    })

    local h = require "helpers"
    h.noremap('n', '<localleader>t', require("neotest").run.run())
    h.noremap('n', '<localleader>T', require("neotest").run.run(vim.fn.expand("%")))
    h.noremap('n', '<localleader>d', require("neotest").run.run({strategy = "dap"}))
    h.noremap('n', '<localleader>S', require("neotest").run.stop())
end

return M
