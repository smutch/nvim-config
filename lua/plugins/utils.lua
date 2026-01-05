return {
    { "nvim-lua/plenary.nvim", lazy = true },
    { "tpope/vim-eunuch", event = "VeryLazy" },
    {
        "stevearc/resession.nvim",
        config = function()
            local resession = require("resession")
            resession.setup({
                extensions = {
                    overseer = {},
                },
            })
            vim.api.nvim_create_autocmd("VimEnter", {
                callback = function()
                    -- Only load the session if nvim was started with no args
                    if vim.fn.argc(-1) == 0 then
                        -- Save these to a different directory, so our manual sessions don't get polluted
                        resession.load(vim.fn.getcwd(), { dir = "dirsession", silence_errors = true })
                    end
                end,
                nested = true,
            })
            vim.api.nvim_create_autocmd("VimLeavePre", {
                callback = function()
                    resession.save(vim.fn.getcwd(), { dir = "dirsession", notify = false })
                end,
            })

            vim.api.nvim_create_user_command("SessionSave", function()
                require("resession").save()
            end, { desc = "Save session" })
            vim.api.nvim_create_user_command("SessionLoad", function()
                require("resession").load()
            end, { desc = "Load session" })
            vim.api.nvim_create_user_command("SessionDelete", function()
                require("resession").delete()
            end, { desc = "Delete session" })
        end,
    },
    {
        "RRethy/vim-illuminate",
        event = "VeryLazy",
        config = function()
            require("illuminate").configure({
                providers = {
                    -- 'lsp',
                    "treesitter",
                    "regex",
                },
            })
        end,
    },
    {
        "stevearc/oil.nvim",
        config = function()
            require("oil").setup({
                columns = {
                    "icon",
                    "permissions",
                    "size",
                    "mtime",
                },
                win_options = {
                    signcolumn = "auto:2",
                },
            })
            vim.keymap.set("n", "-", require("oil").open, { desc = "Open parent directory" })
        end,
    },
    {
        "refractalize/oil-git-status.nvim",
        dependencies = {
            "stevearc/oil.nvim",
        },
        config = true,
    },
    { "uga-rosa/ccc.nvim", opts = {}, ft = { "astro", "html", "css", "scss", "lua", "vim" } },
    {
        "rcarriga/neotest",
        lazy = true,
        dependencies = {
            "rcarriga/neotest-python",
            "rouge8/neotest-rust",
        },
        config = function()
            require("neotest").setup({ ---@diagnostic disable-line:missing-fields
                adapters = {
                    require("neotest-python"),
                    require("neotest-rust"),
                },
            })
        end,
        keys = {
            {
                "<localleader>tr",
                function()
                    require("neotest").run.run()
                end,
                desc = "Run nearest test",
            },
            {
                "<localleader>tR",
                function()
                    require("neotest").run.run(vim.fn.expand("%"))
                end,
                desc = "Run all tests in file",
            },
            {
                "<localleader>tc",
                function()
                    require("neotest").run.stop()
                end,
                desc = "Stop test run",
            },
            {
                "<localleader>ts",
                function()
                    require("neotest").summary.toggle()
                end,
                desc = "Toggle test summary",
            },
            {
                "[t",
                function()
                    require("neotest").jump.prev({ status = "failed" })
                end,
                desc = "Jump to previous failed test",
            },
            {
                "]t",
                function()
                    require("neotest").jump.next({ status = "failed" })
                end,
                desc = "Jump to next failed test",
            },
        },
    },
    {
        "folke/which-key.nvim",
        config = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
            require("which-key").setup({})
        end,
    },
    {
        "jpalardy/vim-slime",
        lazy = false,
        init = function()
            vim.g.slime_target = "tmux"
            vim.g.slime_no_mappings = 1
            vim.g.slime_bracketed_paste = 1
            vim.g.slime_python_ipython = 1
        end,
        keys = {
            { "gz", "<Plug>SlimeRegionSend", mode = "v", desc = "Send region" },
            { "gz", "<Plug>SlimeMotionSend", desc = "Send motion" },
            { "gZ", "<Plug>SlimeLineSend", desc = "Send line" },
        },
    },
    {
        "mrjones2014/smart-splits.nvim",
        config = true,
        lazy = false,
        keys = {
            {
                "<A-h>",
                function()
                    require("smart-splits").resize_left()
                end,
                desc = "smart-splits - resize left",
            },
            {
                "<A-j>",
                function()
                    require("smart-splits").resize_down()
                end,
                desc = "smart-splits - resize down",
            },
            {
                "<A-k>",
                function()
                    require("smart-splits").resize_up()
                end,
                desc = "smart-splits - resize up",
            },
            {
                "<A-l>",
                function()
                    require("smart-splits").resize_right()
                end,
                desc = "smart-splits - resize right",
            },
            {
                "<C-h>",
                function()
                    require("smart-splits").move_cursor_left()
                end,
                desc = "smart-splits - move cursor left",
            },
            {
                "<C-j>",
                function()
                    require("smart-splits").move_cursor_down()
                end,
                desc = "smart-splits - move cursor down",
            },
            {
                "<C-k>",
                function()
                    require("smart-splits").move_cursor_up()
                end,
                desc = "smart-splits - move cursor up",
            },
            {
                "<C-l>",
                function()
                    require("smart-splits").move_cursor_right()
                end,
                desc = "smart-splits - move cursor right",
            },
            {
                "<leader>bh",
                function()
                    require("smart-splits").swap_buf_left()
                end,
                desc = "smart-splits - swap buffer left",
            },
            {
                "<leader>bj",
                function()
                    require("smart-splits").swap_buf_down()
                end,
                desc = "smart-splits - swap buffer down",
            },
            {
                "<leader>bk",
                function()
                    require("smart-splits").swap_buf_up()
                end,
                desc = "smart-splits - swap buffer up",
            },
            {
                "<leader>bl",
                function()
                    require("smart-splits").swap_buf_right()
                end,
                desc = "smart-splits - swap buffer right",
            },
        },
    },
    { "tiagovla/scope.nvim", config = true },
    {
        "shortcuts/no-neck-pain.nvim",
        config = function()
            require("no-neck-pain").setup({
                width = 120,
            })
        end,
        cmd = { "NoNeckPain" },
    },
    {
        "MagicDuck/grug-far.nvim",
        opts = {},
        cmd = function()
            vim.api.nvim_create_user_command("GrugFarWord", function()
                require("grug-far").grug_far({ prefills = { search = vim.fn.expand("<cword>") } })
            end, { desc = "Grug - replace current word" })
            vim.api.nvim_create_user_command("GrugFarCurFile", function()
                require("grug-far").grug_far({ prefills = { flags = vim.fn.expand("%") } })
            end, { desc = "Grug - limit to current file" })
            return { "GrugFarWord", "GrugFarCurFile", "GrugFar" }
        end,
    },
    {
        "stevearc/overseer.nvim",
        event = "VeryLazy",
        opts = {
            task_list = {
                bindings = {
                    ["<C-l>"] = false,
                    ["<C-h>"] = false,
                    ["L"] = "IncreaseDetail",
                    ["H"] = "DecreaseDetail",
                    ["gL"] = "IncreaseAllDetail",
                    ["gH"] = "DecreaseAllDetail",
                    ["<C-k>"] = false,
                    ["<C-j>"] = false,
                    ["<C-u>"] = "ScrollOutputUp",
                    ["<C-d>"] = "ScrollOutputDown",
                },
            },
        },
        keys = {
            { "<leader>ot", "<CMD>OverseerToggle<CR>", desc = "Overseer - toggle" },
            { "<leader>or", "<CMD>OverseerRun<CR>", desc = "Overseer - run" },
            { "<leader>oo", function() require"overseer".list_tasks()[1]:restart(true) end, desc = "Overseer - restart" },
            { "<leader>ob", "<CMD>OverseerLoadBundle<CR>", desc = "Overseer - load bundle" },
        },
    },
    {
        "otavioschwanck/arrow.nvim",
        dependencies = {
            { "echasnovski/mini.icons" },
        },
        opts = {
            show_icons = true,
            leader_key = "M", -- Recommended to be a single key
            buffer_leader_key = "m", -- Per Buffer Mappings
        },
    },
    {
        "nvim-tree/nvim-tree.lua",
        keys = {
            { "g-", "<CMD>NvimTreeToggle<CR>", desc = "NvimTree - Toggle" },
        },
        cmd = "NvimTreeToggle",
        config = function()
            -- local HEIGHT_RATIO = 0.8
            -- local WIDTH_RATIO = 0.5

            -- require('nvim-tree').setup({
            --     view = {
            --         float = {
            --             enable = true,
            --             open_win_config = function()
            --                 local screen_w = vim.opt.columns:get()
            --                 local screen_h = vim.opt.lines:get() - vim.opt.cmdheight:get()
            --                 local window_w = screen_w * WIDTH_RATIO
            --                 local window_h = screen_h * HEIGHT_RATIO
            --                 local window_w_int = math.floor(window_w)
            --                 local window_h_int = math.floor(window_h)
            --                 local center_x = (screen_w - window_w) / 2
            --                 local center_y = ((vim.opt.lines:get() - window_h) / 2)
            --                     - vim.opt.cmdheight:get()
            --                 return {
            --                     border = 'rounded',
            --                     relative = 'editor',
            --                     row = center_y,
            --                     col = center_x,
            --                     width = window_w_int,
            --                     height = window_h_int,
            --                 }
            --             end,
            --         },
            --         width = function()
            --             return math.floor(vim.opt.columns:get() * WIDTH_RATIO)
            --         end,
            --     },
            -- })
            require("nvim-tree").setup({
                view = {
                    width = function()
                        return math.max(20, math.floor(vim.opt.columns:get() * 0.15))
                    end,
                },
            })

            vim.api.nvim_create_autocmd({ "BufEnter" }, {
                pattern = "NvimTree*",
                callback = function()
                    local api = require("nvim-tree.api")
                    local view = require("nvim-tree.view")

                    if not view.is_visible() then
                        api.tree.open()
                    end
                end,
            })
        end,
    },
    {
        "stevearc/quicker.nvim",
        event = "FileType qf",
        opts = {
            keys = {
                {
                    ">",
                    function()
                        require("quicker").expand({ before = 2, after = 2, add_to_existing = true })
                    end,
                    desc = "Expand quickfix context",
                },
                {
                    "<",
                    function()
                        require("quicker").collapse()
                    end,
                    desc = "Collapse quickfix context",
                },
            },
        },
        keys = {
            {
                "<leader>Q",
                function()
                    require("quicker").toggle()
                end,
                desc = "Toggle quickfix",
            },
            {
                "<leader>L",
                function()
                    require("quicker").toggle({ loclist = true })
                end,
                desc = "Toggle loclist",
            },
        },
    },
    {
        "folke/snacks.nvim",
        priority = 1000,
        lazy = false,
        opts = {
            bigfile = { enabled = true },
            bufdelete = { enabled = true },
            gh = { enabled = true },
            image = { enabled = true, doc = { enabled = false } },
            indent = {
                enabled = true,
                indent = {
                    enabled = false,
                    only_scope = true,
                    only_current = true,
                },
                chunk = {
                    enabled = true,
                    only_current = true,
                    char = {
                        horizontal = "━",
                        vertical = "┃",
                        corner_top = "┏",
                        corner_bottom = "┗",
                        arrow = "━",
                    },
                },
            },
            lazygit = { enabled = true },
            notifier = {
                enabled = true,
                top_down = false,
            },
            picker = {
                enabled = true,
            },
            quickfile = { enabled = true },
            scratch = {
                ft = "markdown",
            },
            scroll = { enabled = false },
            statuscolumn = { enabled = true },
            styles = {
                notification = {
                    style = "minimal",
                    wo = { wrap = true }, -- Wrap notifications
                },
                zen = {
                    backdrop = { transparent = false, blend = 40 },
                }
            },
            terminal = { enabled = true },
            zen = { enabled = true },
        },
        keys = {
            {
                "Q",
                function()
                    Snacks.bufdelete()
                end,
                desc = "Delete buffer",
            },
            {
                "<leader>gl",
                function()
                    Snacks.lazygit()
                end,
                desc = "Lazygit",
            },
            {
                [[<M-|>]],
                function()
                    Snacks.terminal.toggle(nil, { win = { position = "left" } })
                end,
                desc = "Toggle Terminal (left)",
            },
            {
                [[<M-\>]],
                function()
                    Snacks.terminal.toggle(nil, { win = { position = "bottom" } })
                end,
                desc = "Toggle Terminal (bottom)",
                mode = { "n", "t" },
            },
            {
                "<leader>nh",
                function()
                    Snacks.notifier.show_history()
                end,
                desc = "(N)otify (h)istory",
            },
            {
                "<leader>nc",
                function()
                    Snacks.notifier.hide()
                end,
                desc = "(N)otify (c)lear",
            },
            {
                "<leader>.",
                function()
                    Snacks.scratch()
                end,
                desc = "Toggle Scratch Buffer",
            },
            {
                "<leader>S",
                function()
                    Snacks.scratch.select()
                end,
                desc = "Select Scratch Buffer",
            },
            {
                "<leader>f<leader>",
                function()
                    Snacks.picker.smart()
                end,
                desc = "Smart Find Files",
            },
            {
                "<leader>fb",
                function()
                    Snacks.picker.buffers()
                end,
                desc = "Buffers",
            },
            {
                "<leader>fc",
                function()
                    Snacks.picker.files({ cwd = vim.fn.stdpath("config") })
                end,
                desc = "Find Config File",
            },
            {
                "<leader>ff",
                function()
                    Snacks.picker.files({ hidden = true, ignored = true })
                end,
                desc = "Find Files",
            },
            {
                "<leader>fg",
                function()
                    Snacks.picker.git_files()
                end,
                desc = "Find Git Files",
            },
            {
                "<leader>fp",
                function()
                    Snacks.picker.projects()
                end,
                desc = "Projects",
            },
            {
                "<leader>fr",
                function()
                    Snacks.picker.recent()
                end,
                desc = "Recent",
            },
            {
                "<leader>f/",
                function()
                    Snacks.picker.grep()
                end,
                desc = "Grep",
            },
            {
                "<leader>f*",
                function()
                    Snacks.picker.grep_word()
                end,
                desc = "Visual selection or word",
                mode = { "n", "x" },
            },
            {
                '<leader>f"',
                function()
                    Snacks.picker.registers()
                end,
                desc = "Registers",
            },
            {
                "<leader>f:",
                function()
                    Snacks.picker.commands()
                end,
                desc = "Commands",
            },
            {
                "<leader>fh",
                function()
                    Snacks.picker.help()
                end,
                desc = "Help Pages",
            },
            {
                "<leader>fH",
                function()
                    Snacks.picker.highlights()
                end,
                desc = "Highlights",
            },
            {
                "<leader>fi",
                function()
                    Snacks.picker.icons()
                end,
                desc = "Icons",
            },
            {
                "<leader>fj",
                function()
                    Snacks.picker.jumps()
                end,
                desc = "Jumps",
            },
            {
                "<leader>fk",
                function()
                    Snacks.picker.keymaps()
                end,
                desc = "Keymaps",
            },
            {
                "<leader>fl",
                function()
                    Snacks.picker.loclist()
                end,
                desc = "Location List",
            },
            {
                "<leader>f,",
                function()
                    Snacks.picker.marks()
                end,
                desc = "Marks",
            },
            {
                "<leader>fP",
                function()
                    Snacks.picker.lazy()
                end,
                desc = "Search for Plugin Spec",
            },
            {
                "<leader>fR",
                function()
                    Snacks.picker.resume()
                end,
                desc = "Resume",
            },
            {
                "<leader>fu",
                function()
                    Snacks.picker.undo()
                end,
                desc = "Undo History",
            },
            {
                "<leader>ls",
                function()
                    Snacks.picker.lsp_symbols({ layout = { preset = "vscode", preview = "main" } })
                end,
                desc = "LSP Symbols",
            },
            {
                "<leader>lw",
                function()
                    Snacks.picker.lsp_workspace_symbols({ layout = { preset = "vscode", preview = "main" } })
                end,
                desc = "LSP Workspace Symbols",
            },
            {
                "<leader>lc",
                function()
                    Snacks.picker.lsp_config({ layout = { preset = "vscode", preview = "main" } })
                end,
                desc = "LSP Configs",
            },
            {
                "<leader>zt",
                function()
                    Snacks.zen.zen()
                end,
                desc = "Toggle Zen Mode",
            },
            {
                "<leader>zz",
                function()
                    Snacks.zen.zoom()
                end,
                desc = "Toggle Zen Mode",
            },
        },
    },
}
