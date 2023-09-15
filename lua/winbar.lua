if not vim.api.nvim_get_all_options_info().winbar then
    return
end


local M = {}
-- local navic = require("nvim-navic")

local disabled_filetypes = {
    'NvimTree',
    'qf',
    'fugitive',
}

M.winbar = function()
    local win_num = vim.api.nvim_win_get_number(0)
    local basic = ' ' .. win_num

    if vim.bo.buftype == "terminal" then
        return basic
    end
    for _, ft in pairs(disabled_filetypes) do
        if (vim.bo.filetype == ft) then
            return basic
        end
    end

    local location = ''
    -- if navic.is_available() then
    --     location = navic.get_location()
    -- end
    -- if location ~= '' then
    --     location = '  ' .. location
    -- end

    local modified = vim.o.modified and ' 󱙃 ' or ''

    return ' ' .. win_num .. modified .. location
    -- return ' ' .. win_num .. ' | ' .. modified .. '%f' .. location
end

vim.o.winbar = "%{%v:lua.require('winbar').winbar()%}"

local augrp = vim.api.nvim_create_augroup("winbar", {})

-- local function winbar_colors()
--     vim.api.nvim_set_hl(0, "WinBarNC", { link = "lualine_x_normal" })
--     vim.api.nvim_set_hl(0, "WinBar", { link = "lualine_c_normal" })
-- end

-- vim.api.nvim_create_autocmd("ColorScheme", {
--     group = augrp,
--     callback = winbar_colors
-- })

return M
