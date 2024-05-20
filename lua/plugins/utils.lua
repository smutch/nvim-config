return {
    { 'nvim-lua/plenary.nvim', lazy = true },
    { 'tpope/vim-unimpaired' },
    { 'tpope/vim-eunuch' },
    {
        'stevearc/resession.nvim',
        config = function()
            local resession = require("resession")
            resession.setup({
                extensions = {
                    overseer = {
                    }
                }
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

            vim.api.nvim_create_user_command('SessionSave', resession.save, { desc = "Save session" })
            vim.api.nvim_create_user_command('SessionLoad', resession.load, { desc = "Load session" })
            vim.api.nvim.create_user_command('SessionDelete', resession.delete, { desc = "Delete session" })
        end
    },
    {
        'bfredl/nvim-luadev',
        config = function()
            local augroup = vim.api.nvim_create_augroup("LuadDev", {})

            vim.api.nvim_create_autocmd("BufEnter", {
                pattern = "*nvim-lua*",
                group = augroup,
                callback = function()
                    local buffer = vim.api.nvim_get_current_buf()
                    vim.keymap.set("n", "<localleader>r", "<PLug>(Luadev-Run)", { buffer = buffer })
                    vim.keymap.set("n", "<localleader>l", "<Plug>(Luadev-RunLine)", { buffer = buffer })
                    vim.keymap.set("n", "<localleader>w", "<Plug>(Luadev-RunWord)", { buffer = buffer })
                end
            })
        end
    },
    {
        'RRethy/vim-illuminate',
        lazy = "VeryLazy",
        config = function()
            require 'illuminate'.configure {
                providers = {
                    -- 'lsp',
                    'treesitter',
                    'regex',
                }

            }
        end
    },
    { 'sindrets/diffview.nvim', lazy = "VeryLazy" },
    {
        'stevearc/oil.nvim',
        config = function()
            require("oil").setup()
            vim.keymap.set("n", "-", require("oil").open, { desc = "Open parent directory" })
        end
    },
    { 'uga-rosa/ccc.nvim',      config = true,    ft = { "astro", "html", "css", "scss", "lua", "vim" } },
    {
        "rcarriga/neotest",
        lazy = true,
        dependencies = {
            'rcarriga/neotest-python',
            'rouge8/neotest-rust',
        },
        config = function()
            require("neotest").setup({
                adapters = {
                    require("neotest-python"),
                    require("neotest-rust"),
                },
            })

            vim.keymap.set('n', '<localleader>tr', require("neotest").run.run)
            vim.keymap.set('n', '<localleader>tR', function() return require("neotest").run.run(vim.fn.expand("%")) end)
            vim.keymap.set('n', '<localleader>tc', require("neotest").run.stop)
            vim.keymap.set('n', '<localleader>ts', require("neotest").summary.toggle)
            vim.keymap.set('n', '[t', function() return require("neotest").jump.prev({ status = "failed" }) end,
                { noremap = true, silent = true })
            vim.keymap.set('n', ']t', function() return require("neotest").jump.next({ status = "failed" }) end,
                { noremap = true, silent = true })
        end
    },
    {
        'folke/zen-mode.nvim',
        cmd = 'ZenMode',
        config = function()
            require("zen-mode").setup {
                wezterm = {
                    enabled = true
                }
            }
        end
    },
    {
        'numToStr/FTerm.nvim',
        config = function()
            vim.keymap.set('n', [[<M-\>]], '<CMD>lua require("FTerm").toggle()<CR>', { noremap = true })
            vim.keymap.set('t', [[<M-\>]], '<CMD>lua require("FTerm").toggle()<CR>', { noremap = true })
            vim.keymap.set('n', '<leader>gl', '<CMD>lua require("FTerm").scratch({ cmd = "lazygit" })<CR>')
        end
    },
    {
        'kevinhwang91/nvim-ufo',
        dependencies = {
            'kevinhwang91/promise-async',
        },
        config = function()
            -- TODO: Set this to '1' when when https://github.com/neovim/neovim/pull/17446 is merged
            vim.wo.foldcolumn = '0'

            vim.o.foldlevelstart = 99
            vim.wo.foldenable = true
            vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]

            local handler = function(virtText, lnum, endLnum, width, truncate)
                local newVirtText = {}
                local suffix = (' 󰁂 %d '):format(endLnum - lnum)
                local sufWidth = vim.fn.strdisplaywidth(suffix)
                local targetWidth = width - sufWidth
                local curWidth = 0
                for _, chunk in ipairs(virtText) do
                    local chunkText = chunk[1]
                    local chunkWidth = vim.fn.strdisplaywidth(chunkText)
                    if targetWidth > curWidth + chunkWidth then
                        table.insert(newVirtText, chunk)
                    else
                        chunkText = truncate(chunkText, targetWidth - curWidth)
                        local hlGroup = chunk[2]
                        table.insert(newVirtText, { chunkText, hlGroup })
                        chunkWidth = vim.fn.strdisplaywidth(chunkText)
                        -- str width returned from truncate() may less than 2nd argument, need padding
                        if curWidth + chunkWidth < targetWidth then
                            suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
                        end
                        break
                    end
                    curWidth = curWidth + chunkWidth
                end
                table.insert(newVirtText, { suffix, 'MoreMsg' })
                return newVirtText
            end

            require('ufo').setup({ fold_virt_text_handler = handler })
        end
    },
    {
        -- WARNING: Don't use this if barbar is enabled
        'moll/vim-bbye',
        config = function()
            vim.api.nvim_set_keymap('n', 'Q', ':Bdelete<CR>', { noremap = true, silent = true })
        end
    },
    {
        "folke/which-key.nvim",
        config = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
            require("which-key").setup {}
        end,
    },
    {
        'hkupty/iron.nvim',
        cmd = { "IronRepl" },
        config = function()
            local iron = require("iron.core")

            iron.setup {
                config = {
                    -- Whether a repl should be discarded or not
                    scratch_repl = true,
                    repl_definition = {
                        python = {
                            -- Can be a table or a function that
                            -- returns a table
                            command = { "ipython", "--profile=interactive" }
                        }
                    },
                    -- How the repl window will be displayed
                    repl_open_cmd = "vertical botright 80 split",
                },
                keymaps = {
                    send_motion = "gz",
                    visual_send = "gz",
                    cr = "gZ",
                },
                ignore_blank_lines = true,
            }
        end
    },
    {
        'mrjones2014/smart-splits.nvim',
        config = true,
        keys = {
            { '<A-h>',      function() require('smart-splits').resize_left() end,       desc = "smart-splits - resize left" },
            { '<A-j>',      function() require('smart-splits').resize_down() end,       desc = "smart-splits - resize down" },
            { '<A-k>',      function() require('smart-splits').resize_up() end,         desc = "smart-splits - resize up" },
            { '<A-l>',      function() require('smart-splits').resize_right() end,      desc = "smart-splits - resize right" },
            { '<C-h>',      function() require('smart-splits').move_cursor_left() end,  desc = "smart-splits - move cursor left" },
            { '<C-j>',      function() require('smart-splits').move_cursor_down() end,  desc = "smart-splits - move cursor down" },
            { '<C-k>',      function() require('smart-splits').move_cursor_up() end,    desc = "smart-splits - move cursor up" },
            { '<C-l>',      function() require('smart-splits').move_cursor_right() end, desc = "smart-splits - move cursor right" },
            { '<leader>bh', function() require('smart-splits').swap_buf_left() end,     desc = "smart-splits - swap buffer left" },
            { '<leader>bj', function() require('smart-splits').swap_buf_down() end,     desc = "smart-splits - swap buffer down" },
            { '<leader>bk', function() require('smart-splits').swap_buf_up() end,       desc = "smart-splits - swap buffer up" },
            { '<leader>bl', function() require('smart-splits').swap_buf_right() end,    desc = "smart-splits - swap buffer right" },
            { '<leader>R',  function() require('smart-splits').start_resize_mode() end, desc = "smart-splits - enter resize mode" },
        }
    },
    { 'tiagovla/scope.nvim', config = true },
    {
        'shortcuts/no-neck-pain.nvim',
        config = function()
            require "no-neck-pain".setup {
                width = 120,
            }
        end,
        lazy = true,
        cmd = { 'NoNeckPain' }
    },
    {
        'MagicDuck/grug-far.nvim',
        opts = {},
        keys = {
            { '<leader>s*', function() require('grug-far').grug_far({ prefills = { search = vim.fn.expand("<cword>") } }) end, desc = 'Grug - replace cursor word' },
            { '<leader>s%', function() require('grug-far').grug_far({ prefills = { flags = vim.fn.expand("%") } }) end,        desc = 'Grug - limit to current file' },
        },
        cmd = { 'GrugFar' }
    },
    {
        'stevearc/overseer.nvim',
        lazy = "VeryLazy",
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
                }
            },
        },
        keys = {
            { '<leader>ot', '<CMD>OverseerToggle<CR>',              desc = "Overseer - toggle" },
            { '<leader>or', '<CMD>OverseerRun<CR>',                 desc = "Overseer - run" },
            { '<leader>oo', '<CMD>OverseerQuickAction restart<CR>', desc = "Overseer - restart" },
        }
    },
    {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" },
        lazy = "VeryLazy",
        config = function()
            local harpoon = require "harpoon"
            harpoon:setup {}

            local conf = require("telescope.config").values
            local function toggle_telescope(harpoon_files)
                local file_paths = {}
                for _, item in ipairs(harpoon_files.items) do
                    table.insert(file_paths, item.value)
                end

                require("telescope.pickers").new({}, {
                    prompt_title = "Harpoon",
                    finder = require("telescope.finders").new_table({
                        results = file_paths,
                    }),
                    previewer = conf.file_previewer({}),
                    sorter = conf.generic_sorter({}),
                }):find()
            end

            vim.keymap.set("n", "<leader>hq", function()
                toggle_telescope(harpoon:list())
            end, { noremap = true, desc = "Harpoon - Toggle Quick Menu" })
            vim.keymap.set("n", "<leader>ha", function()
                harpoon:list():add()
            end, { noremap = true, desc = "Harpoon - Add" })
            vim.keymap.set("n", "<leader>hl", function()
                harpoon:list():next()
            end, { noremap = true, desc = "Harpoon - Next" })
            vim.keymap.set("n", "<leader>hh", function()
                harpoon:list():prev()
            end, { noremap = true, desc = "Harpoon - Prev" })
            for ii = 1, 9 do
                vim.keymap.set("n", "<leader>h" .. ii, function()
                    require "harpoon":list():select(ii)
                end, { noremap = "true", desc = "Harpoon - Select " .. ii }
                )
            end
        end
    },
    {
        'nvim-tree/nvim-tree.lua',
        keys = {
            { "g-", "<CMD>NvimTreeToggle<CR>", desc = "NvimTree - Toggle" },
        },
        config = function()
            local HEIGHT_RATIO = 0.8
            local WIDTH_RATIO = 0.5

            require('nvim-tree').setup({
                view = {
                    float = {
                        enable = true,
                        open_win_config = function()
                            local screen_w = vim.opt.columns:get()
                            local screen_h = vim.opt.lines:get() - vim.opt.cmdheight:get()
                            local window_w = screen_w * WIDTH_RATIO
                            local window_h = screen_h * HEIGHT_RATIO
                            local window_w_int = math.floor(window_w)
                            local window_h_int = math.floor(window_h)
                            local center_x = (screen_w - window_w) / 2
                            local center_y = ((vim.opt.lines:get() - window_h) / 2)
                                - vim.opt.cmdheight:get()
                            return {
                                border = 'rounded',
                                relative = 'editor',
                                row = center_y,
                                col = center_x,
                                width = window_w_int,
                                height = window_h_int,
                            }
                        end,
                    },
                    width = function()
                        return math.floor(vim.opt.columns:get() * WIDTH_RATIO)
                    end,
                },
            })

            vim.api.nvim_create_autocmd({ 'BufEnter' }, {
                pattern = 'NvimTree*',
                callback = function()
                    local api = require('nvim-tree.api')
                    local view = require('nvim-tree.view')

                    if not view.is_visible() then
                        api.tree.open()
                    end
                end,
            })
        end,
    },
    {
        "Makaze/watch.nvim",
        cmd = { "WatchStart", "WatchStop", "WatchFile" },
    },
    { 'danymat/neogen',      config = function() require('neogen').setup({ snippet_engine = "luasnip" }) end },
}
