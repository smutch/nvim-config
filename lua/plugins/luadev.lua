local M = {}

function M.config()
    local augroup = vim.api.nvim_create_augroup("LuadDev", {})

    vim.api.nvim_create_autocmd("BufEnter", {
        pattern = "*nvim-lua*",
        group = augroup,
        callback = function()
            local buffer = vim.api.nvim_get_current_buf()
            vim.keymap.set("n", "<localleader>r", "<PLug>(Luadev-Run)", { buffer = buffer })
            vim.keymap.set("n", "<localleader>l", "<Plug>(Luadev-RunLine)", { buffer = buffer })
            vim.keymap.set("n", "<localleader>w", "<Plug>(Luadev-RunWord)", { buffer = buffer })
        end
    })
end

return M
