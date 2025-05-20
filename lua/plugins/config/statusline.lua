local cc_entry = require("lualine.component"):extend()

cc_entry.processing = false
cc_entry.spinner_index = 1

local spinner_symbols = {
    "⠋",
    "⠙",
    "⠹",
    "⠸",
    "⠼",
    "⠴",
    "⠦",
    "⠧",
    "⠇",
    "⠏",
}
local spinner_symbols_len = 10

-- Initializer
function cc_entry:init(options)
    cc_entry.super.init(self, options)

    local group = vim.api.nvim_create_augroup("CodeCompanionHooks", {})

    vim.api.nvim_create_autocmd({ "User" }, {
        pattern = "CodeCompanionRequest*",
        group = group,
        callback = function(request)
            if request.match == "CodeCompanionRequestStarted" then
                self.processing = true
            elseif request.match == "CodeCompanionRequestFinished" then
                self.processing = false
            end
        end,
    })
end

-- Function that runs every time statusline is updated
function cc_entry:update_status()
    if self.processing then
        self.spinner_index = (self.spinner_index % spinner_symbols_len) + 1
        return "%#lualine_y_copilot_spinner_normal#" .. spinner_symbols[self.spinner_index]
    else
        return nil
    end
end

local function theme_colors()
    -- default colors
    local colors = {
        blue = "#80a0ff",
        cyan = "#79dac8",
        black = "#080808",
        white = "#c6c6c6",
        red = "#ff5189",
        violet = "#d183e8",
        grey = "#303030",
        yellow = "#dbc074",
    }

    local colorscheme = vim.api.nvim_exec("colorscheme", true)
    if string.find(colorscheme, "fox") then
        local palette = require("nightfox.palette").load(vim.g.colors_name)
        -- local Color = require("nightfox.lib.color")
        -- local bg = Color.from_hex(palette.bg1)
        local bg = palette.bg2
        if vim.o.background == "light" then
            bg = palette.bg1
        end
        colors = {
            blue = palette.blue.base,
            cyan = palette.cyan.base,
            black = palette.black.base,
            white = palette.white.base,
            red = palette.red.base,
            violet = palette.magenta.dim,
            green = palette.green.base,
            grey = palette.bg3,
            yellow = palette.yellow.base,
            fg1 = palette.white.dim,
            fg2 = palette.yellow.dim,
            bg1 = bg,
        }
    end

    return {
        normal = {
            a = { bg = colors.bg1, fg = colors.fg1, gui = "bold" },
            b = { bg = colors.bg1, fg = colors.fg1 },
            c = { bg = colors.bg1, fg = colors.fg2 },
            z = { bg = colors.bg1, fg = colors.fg1 },
        },
        insert = {
            a = { bg = colors.blue, fg = colors.black, gui = "bold" },
            b = { bg = colors.bg1, fg = colors.fg1 },
            c = { bg = colors.bg1, fg = colors.fg2 },
            z = { bg = colors.bg1, fg = colors.fg1 },
        },
        visual = {
            a = { bg = colors.yellow, fg = colors.black, gui = "bold" },
            b = { bg = colors.bg1, fg = colors.fg1 },
            c = { bg = colors.bg1, fg = colors.fg2 },
            z = { bg = colors.bg1, fg = colors.fg1 },
        },
        replace = {
            a = { bg = colors.red, fg = colors.black, gui = "bold" },
            b = { bg = colors.bg1, fg = colors.fg1 },
            c = { bg = colors.bg1, fg = colors.fg2 },
            z = { bg = colors.bg1, fg = colors.fg1 },
        },
        command = {
            a = { bg = colors.green, fg = colors.black, gui = "bold" },
            b = { bg = colors.bg1, fg = colors.fg1 },
            c = { bg = colors.bg1, fg = colors.fg2 },
            z = { bg = colors.bg1, fg = colors.fg1 },
        },
        inactive = {
            a = { bg = colors.bg1, fg = colors.gray, gui = "bold" },
            b = { bg = colors.bg1, fg = colors.gray },
            c = { bg = colors.bg1, fg = colors.fg2 },
            z = { bg = colors.bg1, fg = colors.gray },
        },
    }
end

-- Bubbles config for lualine
-- Author: lokesh-krishna
-- MIT license, see LICENSE for more details.

local lsp_server = function()
    local msg = ""
    local buf_ft = vim.api.nvim_buf_get_option(0, "filetype")
    local clients = vim.lsp.get_clients()
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

local arrow = require("arrow.statusline")
local colors = theme_colors()

require("lualine").setup({
    options = {
        theme = (function()
            if string.find(vim.g.colors_name, "rose-") then
                return "rose-pine-alt"
            else
                return colors
            end
        end)(),
        component_separators = "|",
        section_separators = { left = "", right = "" },
    },
    sections = {
        lualine_a = {
            { "mode", right_padding = 2 },
        },
        lualine_b = {
            -- 'filename',
            "branch",
            "diff",
            {
                "diagnostics",
                sources = { "nvim_lsp" },
                symbols = { error = " ", warn = " ", info = " ", hint = "󰨹 " },
            },
            {
                function()
                    local bufnr = vim.api.nvim_get_current_buf()
                    return arrow.text_for_statusline_with_icons(bufnr)
                end,
            },
            { "overseer" },
            { "macro_recording", "%S" },
        },
        lualine_c = { { "%=", separator = "" }, "filename" },
        lualine_x = {},
        lualine_y = {
            cc_entry,
            "copilot",
            {
                lsp_server,
                icon = "󰿘",
            },
            "filetype",
            "progress",
            "encoding",
            {
                "fileformat",
                right_padding = 2,
            },
        },
        lualine_z = {
            { "location", left_padding = 2 },
        },
    },
    inactive_sections = {
        -- these are to remove the defaults
        lualine_a = {},
        lualine_b = {},
        lualine_y = {},
        lualine_z = {},
        lualine_c = {},
        lualine_x = {},
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
})
