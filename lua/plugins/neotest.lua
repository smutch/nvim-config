local M = {}

function M.config()
    require("neotest").setup({
        adapters = {
            require("neotest-python"){},
        },
    })

    vim.keymap.set('n', '<localleader>tr', require("neotest").run.run)
    vim.keymap.set('n', '<localleader>tR', function() return require("neotest").run.run(vim.fn.expand("%")) end)
    -- vim.keymap.set('n', '<localleader>p', function() return require("neotest").run.run({strategy = "dap"}) end)
    vim.keymap.set('n', '<localleader>tc', require("neotest").run.stop)
    vim.keymap.set('n', '<localleader>ts', require("neotest").summary.toggle)
    vim.keymap.set('n', '[f', function() return require("neotest").jump.prev({ status = "failed" }) end, {noremap = true, silent = true})
    vim.keymap.set('n', ']f', function() return require("neotest").jump.next({ status = "failed" }) end, {noremap = true, silent = true})
end

return M
