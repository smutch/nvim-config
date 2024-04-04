return {
    {
        'mfussenegger/nvim-dap',
        lazy = "VeryLazy",
        config = function()
            local dap = require 'dap'
            -- local Path = require 'plenary.path'

            vim.keymap.set("n", "<leader>dc", require 'dap'.continue, { silent = true, noremap = true })
            vim.keymap.set("n", "<leader>dn", require 'dap'.step_over, { silent = true, noremap = true })
            vim.keymap.set("n", "<leader>di", require 'dap'.step_into, { silent = true, noremap = true })
            vim.keymap.set("n", "<leader>do", require 'dap'.step_out, { silent = true, noremap = true })
            vim.keymap.set("n", "<Leader>db", require 'dap'.toggle_breakpoint, { silent = true, noremap = true })
            vim.keymap.set("n", "<Leader>dB",
                function() require 'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: ')) end,
                { silent = true, noremap = true })
            vim.keymap.set("n", "<Leader>dm",
                function() require 'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end,
                { silent = true, noremap = true })
            vim.keymap.set("n", "<Leader>dr", require 'dap'.repl.open, { silent = true, noremap = true })
            vim.keymap.set("n", "<Leader>dl", require 'dap'.run_last, { silent = true, noremap = true })

            vim.keymap.set({ 'n', 'v' }, '<Leader>dh', function()
                require('dap.ui.widgets').hover()
            end)
            vim.keymap.set({ 'n', 'v' }, '<Leader>dp', function()
                require('dap.ui.widgets').preview()
            end)
            vim.keymap.set('n', '<Leader>dw', function()
                local widgets = require('dap.ui.widgets')
                widgets.centered_float(widgets.frames)
            end)
            vim.keymap.set('n', '<Leader>ds', function()
                local widgets = require('dap.ui.widgets')
                widgets.centered_float(widgets.scopes)
            end)


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

            -- dap.configurations.rust = {
            --     {
            --         type = "codelldb",
            --         request = "launch",
            --         cwd = '${workspaceFolder}',
            --         console = 'integratedTerminal',
            --         stopOnEntry = false,
            --         program = function()
            --             local program
            --             vim.ui.input({ prompt = 'executable: ' }, function(input)
            --                 program = Path:new(input):absolute()
            --             end)
            --             return program
            --         end,
            --         args = function()
            --             local args
            --             vim.ui.input({ prompt = 'arguments: ' }, function(input) args = vim.split(input, " ") end)
            --             return args
            --         end
            --         -- args = function()
            --         --     return vim.ui.input({ prompt = 'args: ' }, function(input) return vim.split(input, " ") end)
            --         -- end
            --     }
            -- }

            dap.adapters.python = {
                type = 'executable',
                command = vim.fn.stdpath('data') .. '/mason/packages/debugpy/venv/bin/python',
                args = { '-m', 'debugpy.adapter' }
            }

            dap.configurations.python = {
                {
                    -- The first three options are required by nvim-dap
                    type = 'python',     -- the type here established the link to the adapter definition: `dap.adapters.python`
                    request = 'launch',
                    name = "Launch file",

                    -- Options below are for debugpy, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for supported options

                    program = "${file}",     -- This configuration will launch the current file if used.
                    pythonPath = function()
                        local cwd = vim.fn.getcwd()
                        if vim.env.CONDA_PREFIX ~= nil then
                            return vim.env.CONDA_PREFIX .. '/bin/python'
                        elseif vim.fn.executable(cwd .. '/venv/bin/python') == 1 then
                            return cwd .. '/venv/bin/python'
                        elseif vim.fn.executable(cwd .. '/.venv/bin/python') == 1 then
                            return cwd .. '/.venv/bin/python'
                        else
                            return '/usr/bin/python'
                        end
                    end
                }
            }
        end
    },
    {
        'rcarriga/nvim-dap-ui',
        dependencies = {"nvim-neotest/nvim-nio"},
        init = function()
            local dap, dapui = require("dap"), require("dapui")
            dapui.setup()
            dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
            dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
            -- dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end
        end,
        config = function()
            vim.keymap.set("n", "<leader>dR", require 'dapui'.toggle, { silent = true, noremap = true })
        end
    },
    {
        'theHamsta/nvim-dap-virtual-text',
        opts = true,
    }
}
