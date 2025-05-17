return {
    {
        "mfussenegger/nvim-dap",
        event = "VeryLazy",
        dependencies = {
            {
                "rcarriga/nvim-dap-ui",
                dependencies = { "nvim-neotest/nvim-nio" },
                init = function()
                    local dap, dapui = require("dap"), require("dapui")
                    dapui.setup()
                    dap.listeners.after.event_initialized["dapui_config"] = function()
                        dapui.open()
                    end
                    dap.listeners.before.event_terminated["dapui_config"] = function()
                        dapui.close()
                    end
                end,
                config = function()
                    vim.keymap.set("n", "<leader>dR", require("dapui").toggle, { silent = true, noremap = true })
                end,
            },
            {
                "theHamsta/nvim-dap-virtual-text",
                opts = true,
            },
        },
        config = function()
            local dap = require("dap")
            -- local Path = require 'plenary.path'

            local extension_path = vim.env.HOME .. "/.local/share/nvim/mason/packages/codelldb/extension/"
            local codelldb_path = extension_path .. "adapter/codelldb"
            local liblldb_path = extension_path .. "lldb/lib/liblldb.dylib"

            dap.adapters.codelldb = {
                type = "server",
                port = "${port}",
                host = "127.0.0.1",
                executable = {
                    command = codelldb_path,
                    args = { "--liblldb", liblldb_path, "--port", "${port}" },

                    -- On windows you may have to uncomment this:
                    -- detached = false,
                },
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
                type = "executable",
                command = vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python",
                args = { "-m", "debugpy.adapter" },
            }

            dap.configurations.python = {
                {
                    -- The first three options are required by nvim-dap
                    type = "python", -- the type here established the link to the adapter definition: `dap.adapters.python`
                    request = "launch",
                    name = "Launch file",

                    -- Options below are for debugpy, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for supported options

                    program = "${file}", -- This configuration will launch the current file if used.
                    pythonPath = require("helpers").python_interpreter_path,
                },
            }
        end,
        keys = {
            {
                "<leader>dc",
                function()
                    require("dap").continue()
                end,
                desc = "DAP Continue",
                mode = "n",
            },
            {
                "<leader>dn",
                function()
                    require("dap").step_over()
                end,
                desc = "DAP Step Over",
                mode = "n",
            },
            {
                "<leader>di",
                function()
                    require("dap").step_into()
                end,
                desc = "DAP Step Into",
                mode = "n",
            },
            {
                "<leader>do",
                function()
                    require("dap").step_out()
                end,
                desc = "DAP Step Out",
                mode = "n",
            },
            {
                "<Leader>db",
                function()
                    require("dap").toggle_breakpoint()
                end,
                desc = "DAP Toggle Breakpoint",
                mode = "n",
            },
            {
                "<Leader>dB",
                function()
                    require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
                end,
                desc = "DAP Set Conditional Breakpoint",
                mode = "n",
            },
            {
                "<Leader>dm",
                function()
                    require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
                end,
                desc = "DAP Set Log Point",
                mode = "n",
            },
            {
                "<Leader>dr",
                function()
                    require("dap").repl.open()
                end,
                desc = "DAP Open REPL",
                mode = "n",
            },
            {
                "<Leader>dl",
                function()
                    require("dap").run_last()
                end,
                desc = "DAP Run Last",
                mode = "n",
            },
            {
                "<Leader>dh",
                function()
                    require("dap.ui.widgets").hover()
                end,
                desc = "DAP Hover",
                mode = { "n", "v" },
            },
            {
                "<Leader>dp",
                function()
                    require("dap.ui.widgets").preview()
                end,
                desc = "DAP Preview",
                mode = { "n", "v" },
            },
            {
                "<Leader>dw",
                function()
                    local widgets = require("dap.ui.widgets")
                    widgets.centered_float(widgets.frames)
                end,
                desc = "DAP Frames",
                mode = "n",
            },
            {
                "<Leader>ds",
                function()
                    local widgets = require("dap.ui.widgets")
                    widgets.centered_float(widgets.scopes)
                end,
                desc = "DAP Scopes",
                mode = "n",
            },
        },
    },
}
