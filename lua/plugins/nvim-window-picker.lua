local M = {}

function M.config()
    require'window-picker'.setup({
        filter_rules = {
            bo = {
                filetype = { 'neo-tree', "neo-tree-popup", "notify", "quickfix" },
                buftype = { 'terminal' },
            },
        },
        other_win_hl_color = '#e35e4f',
    })
end

return M

