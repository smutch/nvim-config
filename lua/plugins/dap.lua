-- See https://github.com/ViRu-ThE-ViRuS/configs/blob/master/nvim/lua/plug-config/dap.lua for some good examples
local M = {}

function M.config()
    local dap = require 'dap'
    local Path = require'plenary.path'

    vim.keymap.set("n", "<leader>dc", require'dap'.continue, {silent=true, noremap=true})
    vim.keymap.set("n", "<leader>ds", require'dap'.step_over, {silent=true, noremap=true})
    vim.keymap.set("n", "<leader>di", require'dap'.step_into, {silent=true, noremap=true})
    vim.keymap.set("n", "<leader>do", require'dap'.step_out, {silent=true, noremap=true})
    vim.keymap.set("n", "<Leader>db", require'dap'.toggle_breakpoint, {silent=true, noremap=true})
    vim.keymap.set("n", "<Leader>dB", function() require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, {silent=true, noremap=true})
    vim.keymap.set("n", "<Leader>dl", function() require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end, {silent=true, noremap=true})
    vim.keymap.set("n", "<Leader>dr", require'dap'.repl.open, {silent=true, noremap=true})
    vim.keymap.set("n", "<Leader>dp", require'dap'.run_last, {silent=true, noremap=true})

    local api = vim.api
    local keymap_restore = {}
    dap.listeners.after['event_initialized']['me'] = function()
        for _, buf in pairs(api.nvim_list_bufs()) do
            local keymaps = api.nvim_buf_get_keymap(buf, 'n')
            for _, keymap in pairs(keymaps) do
                if keymap.lhs == "K" then
                    table.insert(keymap_restore, keymap)
                    api.nvim_buf_del_keymap(buf, 'n', 'K')
                end
            end
        end
        api.nvim_set_keymap(
        'n', 'K', '<Cmd>lua require("dap.ui.widgets").hover()<CR>', { silent = true })
    end

    dap.listeners.after['event_terminated']['me'] = function()
        for _, keymap in pairs(keymap_restore) do
            api.nvim_buf_set_keymap(
            keymap.buffer,
            keymap.mode,
            keymap.lhs,
            keymap.rhs,
            { silent = keymap.silent == 1 }
            )
        end
        keymap_restore = {}
    end

    local extension_path = vim.env.HOME .. '/.local/share/nvim/mason/packages/codelldb/extension/'
    local codelldb_path = extension_path .. 'adapter/codelldb'
    local liblldb_path = extension_path .. 'lldb/lib/liblldb.dylib'

    dap.adapters.codelldb = {
        type = "server",
        port = "${port}",
        host = "127.0.0.1",
        executable = {
            command = codelldb_path,
            args = { "--liblldb", liblldb_path, "--port", "${port}" }

            -- On windows you may have to uncomment this:
            -- detached = false,
        }
    }

    dap.configurations.rust = {
        {
            type = "codelldb",
            request = "launch",
            cwd = '${workspaceFolder}',
            console = 'integratedTerminal',
            stopOnEntry = false,
            program = function()
                local program
                vim.ui.input({ prompt = 'executable: ' }, function(input) program = Path:new(input):absolute() end)
                return program
            end,
            args = function()
                local args
                vim.ui.input({ prompt = 'arguments: ' }, function(input) args = vim.split(input, " ") end)
                return args
            end,
            -- args = function()
            --     return vim.ui.input({ prompt = 'args: ' }, function(input) return vim.split(input, " ") end)
            -- end
        }
    }
end

return M
