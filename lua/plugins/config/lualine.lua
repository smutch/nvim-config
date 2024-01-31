local M = {}

local function sync_colors()
    -- default colors
    local colors = {
        blue   = '#80a0ff',
        cyan   = '#79dac8',
        black  = '#080808',
        white  = '#c6c6c6',
        red    = '#ff5189',
        violet = '#d183e8',
        grey   = '#303030',
        yellow = '#dbc074',
    }

    local colorscheme = vim.api.nvim_exec("colorscheme", true)
    if string.find(colorscheme, "fox") then
        local palette = require('nightfox.palette').load(vim.g.colors_name)
        colors = {
            blue     = palette.blue.base,
            cyan     = palette.cyan.base,
            black    = palette.black.dark,
            white    = palette.white.base,
            red      = palette.red.base,
            violet   = palette.magenta.dim,
            green    = palette.green.base,
            grey     = palette.bg3,
            yellow   = palette.yellow.base,
        }
    end

    return colors
end


function M.statusline()
    -- Bubbles config for lualine
    -- Author: lokesh-krishna
    -- MIT license, see LICENSE for more details.

    -- local colors = sync_colors()

    local lsp_server = function ()
        local msg = ''
        local buf_ft = vim.api.nvim_buf_get_option(0, 'filetype')
        local clients = vim.lsp.get_active_clients()
        if next(clients) == nil then
            return msg
        end
        for _, client in ipairs(clients) do
            local filetypes = client.config.filetypes
            if filetypes and client.name ~= "null-ls" and vim.fn.index(filetypes, buf_ft) ~= -1 then
                return client.name
            end
        end
        return msg
    end

    require('lualine').setup {
        options = {
            -- theme = "nordic",
            component_separators = '|',
            section_separators = { left = '', right = '' },
        },
        sections = {
            lualine_a = {
                { 'mode', separator = { left = '' }, right_padding = 2 },
            },
            lualine_b = {
                -- 'filename',
                'branch',
                -- {
                --     'diagnostics',
                --     sources = { 'nvim_diagnostic' },
                --     symbols = { error = ' ', warn = ' ', info = ' ' },
                --     diagnostics_color = {
                --         color_error = { fg = colors.red },
                --         color_warn = { fg = colors.yellow },
                --         color_info = { fg = colors.cyan },
                --     },
                -- }
            },
            lualine_c = { },
            lualine_x = { },
            lualine_y = {
                {
                    lsp_server,
                    icon = '󰿘',
                    color = { fg = '#ffffff', gui = 'bold' },
                },
                'filetype',
                'progress',
                {
                    'fileformat',
                    separator = {
                        right = ''
                    },
                    right_padding = 2
                }
            },
            lualine_z = {
                { 'location', separator = { right = '' }, left_padding = 2 },
            },
        },
        inactive_sections = {
            lualine_a = { 'filename' },
            lualine_b = {},
            lualine_c = {},
            lualine_x = {},
            lualine_y = {},
            lualine_z = { 'location' },
        },
        tabline = {},
        extensions = {
            "fugitive",
            "fzf",
            "lazy",
            "man",
            "neo-tree",
            "nvim-dap-ui",
            "quickfix",
            "trouble",
        },
    }

end

function M.config()
    local setup = require('plugins.config.lualine')
    setup.statusline()

    local augroup = vim.api.nvim_create_augroup("lualine_colors", {})
    vim.api.nvim_create_autocmd("ColorScheme", {
        callback = setup.statusline,
        group = augroup
    })

end

return M
