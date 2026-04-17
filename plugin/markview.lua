---@diagnostic disable: missing-fields
local gh = require("load").gh

vim.pack.add(gh({
    "mini.nvim/mini.icons",
    "OXY2DEV/markview.nvim",
}))

local markview_filetypes = { "markdown", "pandoc", "quarto", "markdown.pandoc", "Avante", "codecompanion" }

require("markview").setup({
    experimental = { check_rtp_message = false },
    preview = {
        enable = false,
        hybrid_modes = {},
        ignore_buftypes = {},
        filetypes = markview_filetypes,
    },
    markdown = {
        list_items = {
            shift_width = function(buffer, item)
                --- Reduces the `indent` by 1 level.
                ---
                ---         indent                      1
                --- ------------------------- = 1 ÷ --------- = new_indent
                --- indent * (1 / new_indent)       new_indent
                ---
                local parent_indnet = math.max(1, item.indent - vim.bo[buffer].shiftwidth)

                return item.indent * (1 / (parent_indnet * 2))
            end,
            marker_minus = {
                ---@diagnostic disable-next-line: assign-type-mismatch
                add_padding = function(_, item)
                    return item.indent > 1
                end,
            },
        },
        horizontal_rules = {
            enable = true,

            parts = {
                {
                    type = "repeating",
                    direction = "left",

                    repeat_amount = function(buffer)
                        local utils = require("markview.utils")
                        local window = utils.buf_getwin(buffer)

                        local width = vim.api.nvim_win_get_width(window)
                        local textoff = vim.fn.getwininfo(window)[1].textoff

                        return math.floor(width - textoff)
                    end,

                    text = "─",

                    hl = {
                        "MarkviewGradient7",
                    },
                },
            },
        },
        code_blocks = {
            enable = true,
            style = "simple",
        },
    },
})

require("markview.extras.checkboxes").setup()
require("markview.extras.editor").setup()
require("lsp_hover").setup()

vim.keymap.set("n", "<localleader>m", function()
    require("markview").commands.Toggle()
end, { desc = "Toggle Markview" })

vim.api.nvim_create_autocmd("FileType", {
    pattern = markview_filetypes,
    callback = function(args)
        local bufnr = args.buf
        vim.keymap.set("n", "<tab>", function()
            vim.cmd("Checkbox toggle")
        end, { buffer = bufnr, desc = "Toggle checkbox" })
        vim.keymap.set("n", "<localleader><tab>", function()
            vim.cmd("Checkbox interactive")
        end, { buffer = bufnr, desc = "Change checkbox interactively" })
        vim.keymap.set("n", "<localleader>e", function()
            vim.cmd("Editor edit")
        end, { buffer = bufnr, desc = "Edit code block" })
    end,
})
