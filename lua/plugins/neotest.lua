local M = {}

function M.config()
    require("neotest").setup({
        adapters = {
            require("neotest-python"){},
        },
    })

    vim.keymap.set('n', '<localleader>t', require("neotest").run.run)
    vim.keymap.set('n', '<localleader>T', function() return require("neotest").run.run(vim.fn.expand("%")) end)
    vim.keymap.set('n', '<localleader>d', function() return require("neotest").run.run({strategy = "dap"}) end)
    vim.keymap.set('n', '<localleader>S', require("neotest").run.stop)
end

return M
