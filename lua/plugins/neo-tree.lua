local M = {}

function M.config()
    vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])

    vim.fn.sign_define("DiagnosticSignError", {text = " ", texthl = "DiagnosticSignError"})
    vim.fn.sign_define("DiagnosticSignWarn", {text = " ", texthl = "DiagnosticSignWarn"})
    vim.fn.sign_define("DiagnosticSignInfo", {text = " ", texthl = "DiagnosticSignInfo"})
    vim.fn.sign_define("DiagnosticSignHint", {text = "", texthl = "DiagnosticSignHint"})

    require("neo-tree").setup({
        filesystem = {
            window = {
                mappings = {
                    ["-"] = "navigate_up",
                    ["<bs>"] = nil,
                    ["S"] = "split_with_window_picker",
                    ["s"] = "vsplit_with_window_picker",
                    ["<cr>"] = "open_with_window_picker"
                }
            },
            hijack_netrw_behavior = "disabled"
        }
    })
    vim.api.nvim_set_keymap('n', '<leader>F', '<cmd>Neotree reveal<cr>', { noremap = true })
end

return M

