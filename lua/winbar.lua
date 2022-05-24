if not vim.api.nvim_get_all_options_info().winbar then
    return
end


local M = {}
local gps = require("nvim-gps")

local disabled_filetypes = {
    'NvimTree',
    'qf',
    'fugitive',
}

M.winbar = function()
    local win_num = vim.api.nvim_win_get_number(0)
    local basic = '[' .. win_num .. ']'

    if vim.bo.buftype == "terminal" then
        return basic
    end
    for _, ft in pairs(disabled_filetypes) do
        if (vim.bo.filetype == ft) then
            return basic
        end
    end

    local location = ''
    if gps.is_available() then
        location = gps.get_location()
    end

    return location .. ' [' .. win_num .. '] ' .. '%F'
end

vim.o.winbar = "%=%{%v:lua.require('winbar').winbar()%}"
vim.api.nvim_set_hl(0, "winbar", { link = "FoldColumn" })

return M
