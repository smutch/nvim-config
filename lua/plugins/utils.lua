return {
     { 'nvim-lua/plenary.nvim' },
     { 'tpope/vim-unimpaired' },
     { 'tpope/vim-eunuch' },
     {
         'rmagatti/auto-session',
         config = function()
             vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal"

             require('auto-session').setup {
                 pre_save_cmds = { "tabdo Neotree close" },
                 post_save_cmds = { "tabdo Neotree show" },
                 post_restore_cmds = { "stopinsert" },
             }
         end
     },
     -- {
     --     'moll/vim-bbye',
     --     config = function()
     --         vim.api.nvim_set_keymap('n', 'Q', ':Bdelete<CR>', { noremap = true, silent = true })
     --     end
     -- },
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
     { 'lewis6991/impatient.nvim', config = function() require 'impatient' end },
     { 'RRethy/vim-illuminate', config = function() require'illuminate'.configure {} end },
     { 'sindrets/diffview.nvim' },
     {
        'Canop/nvim-bacon',
        config = function()
            vim.keymap.set('n', '<leader>bn', ':BaconLoad<CR>:w<CR>:BaconNext<CR>', { noremap = true })
            vim.keymap.set('n', '<leader>bg', ':BaconList<CR>', { noremap = true })
        end
    },

    { "nvim-lua/plenary.nvim" },
    { "MunifTanjim/nui.nvim" },
    {
        's1n7ax/nvim-window-picker',
        version = "1.*",
        config = function()
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
    },
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v2.x",
        config = function()
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
                        },
                    },
                    hijack_netrw_behavior = "disabled"
                },
            })
            vim.api.nvim_set_keymap('n', '<leader>tt', '<cmd>Neotree reveal<cr>', { noremap = true })
        end
    },
    {
        'stevearc/oil.nvim',
        config = function()
            require("oil").setup()
            vim.keymap.set("n", "-", require("oil").open, { desc = "Open parent directory" })
        end
    },
    { "antoinemadec/FixCursorHold.nvim" },
    { 'folke/todo-comments.nvim', config = true },
    { 'uga-rosa/ccc.nvim', config = true },
    {
        'majutsushi/tagbar',
        config = function()
            vim.api.nvim_set_keymap('n', '<leader>T', ':TagbarToggle<CR>', {})
        end
    },
    { 'christoomey/vim-tmux-navigator' },
    { "nvim-lua/plenary.nvim" },
    { "nvim-treesitter/nvim-treesitter" },
    { "antoinemadec/FixCursorHold.nvim" },
    { 'rcarriga/neotest-python' },
    { 'rouge8/neotest-rust' },
    {
        "rcarriga/neotest",
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
            vim.keymap.set('n', '[f', function() return require("neotest").jump.prev({ status = "failed" }) end, {noremap = true, silent = true})
            vim.keymap.set('n', ']f', function() return require("neotest").jump.next({ status = "failed" }) end, {noremap = true, silent = true})
        end
    },
    {
        'rcarriga/nvim-notify', 
        config = function()
            require("notify").setup {
                top_down = false
            }
        end
    },
    { 'folke/zen-mode.nvim', cmd = 'ZenMode', config = function() require("zen-mode").setup {} end },
    {
        'numToStr/FTerm.nvim',
        config = function()
            vim.keymap.set('n', [[<M-\>]], '<CMD>lua require("FTerm").toggle()<CR>', {noremap = true})
            vim.keymap.set('t', [[<M-\>]], '<CMD>lua require("FTerm").toggle()<CR>', {noremap = true})
            vim.keymap.set('n', '<leader>gl', '<CMD>lua require("FTerm").scratch({ cmd = "lazygit" })<CR>')
        end
    },
    { 'neomake/neomake' },
    { 'kevinhwang91/promise-async' },
    {
        'kevinhwang91/nvim-ufo',
        config = function()
            vim.wo.foldcolumn = '0'  -- TODO: Set this to '1' when when https://github.com/neovim/neovim/pull/17446 is merged
            vim.o.foldlevelstart = 99
            vim.wo.foldenable = true
            vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]

            local handler = function(virtText, lnum, endLnum, width, truncate)
                local newVirtText = {}
                local suffix = ('  %d '):format(endLnum - lnum)
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
                        table.insert(newVirtText, {chunkText, hlGroup})
                        chunkWidth = vim.fn.strdisplaywidth(chunkText)
                        -- str width returned from truncate() may less than 2nd argument, need padding
                        if curWidth + chunkWidth < targetWidth then
                            suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
                        end
                        break
                    end
                    curWidth = curWidth + chunkWidth
                end
                table.insert(newVirtText, {suffix, 'MoreMsg'})
                return newVirtText
            end

            require('ufo').setup({
                fold_virt_text_handler = handler
            })
        end
    },
    { 'axvr/zepl.vim',
        config = function()
            vim.g.repl_config = {
                python = {
                    cmd = "python",
                    formatter = vim.fn['zepl#contrib#python#formatter']
                    }
                }
        end
    },
    { 'romgrk/barbar.nvim',
        dependencies = 'nvim-tree/nvim-web-devicons',
        config = function()
            require'bufferline'.setup {
                icon_pinned = '',
                icons = 'both'
            }

            vim.api.nvim_create_autocmd('FileType', {
                callback = function(tbl)
                    local set_offset = require('bufferline.api').set_offset

                    local bufwinid
                    local last_width
                    local autocmd = vim.api.nvim_create_autocmd('WinScrolled', {
                        callback = function()
                            bufwinid = bufwinid or vim.fn.bufwinid(tbl.buf)

                            local width = vim.api.nvim_win_get_width(bufwinid)
                            if width ~= last_width then
                                set_offset(width, 'FileTree')
                                last_width = width
                            end
                        end,
                    })

                    vim.api.nvim_create_autocmd('BufWipeout', {
                        buffer = tbl.buf,
                        callback = function()
                            vim.api.nvim_del_autocmd(autocmd)
                            set_offset(0)
                        end,
                        once = true,
                    })
                end,
                pattern = 'NvimTree', -- or any other filetree's `ft`
            })

            local map = vim.api.nvim_set_keymap
            local opts = { nnoremap = True, silent = True }
            -- Move to previous/next
            map('n', '[b', '<Cmd>BufferPrevious<CR>', opts)
            map('n', ']b', '<Cmd>BufferNext<CR>', opts)
            -- Re-order to previous/next
            map('n', '<b', '<Cmd>BufferMovePrevious<CR>', opts)
            map('n', '>b', '<Cmd>BufferMoveNext<CR>', opts)
            -- Goto buffer in position...
            map('n', '<BS>1', '<Cmd>BufferGoto 1<CR>', opts)
            map('n', '<BS>2', '<Cmd>BufferGoto 2<CR>', opts)
            map('n', '<BS>3', '<Cmd>BufferGoto 3<CR>', opts)
            map('n', '<BS>4', '<Cmd>BufferGoto 4<CR>', opts)
            map('n', '<BS>5', '<Cmd>BufferGoto 5<CR>', opts)
            map('n', '<BS>6', '<Cmd>BufferGoto 6<CR>', opts)
            map('n', '<BS>7', '<Cmd>BufferGoto 7<CR>', opts)
            map('n', '<BS>8', '<Cmd>BufferGoto 8<CR>', opts)
            map('n', '<BS>9', '<Cmd>BufferGoto 9<CR>', opts)
            -- map('n', '<BS><BS>', '<Cmd>BufferLast<CR>', opts)
            -- Pin/unpin buffer
            map('n', '<BS>p', '<Cmd>BufferPin<CR>', opts)
            -- Close buffer
            map('n', 'Q', '<Cmd>BufferClose<CR>', opts)
            -- Wipeout buffer
            --                 :BufferWipeout
            -- Close commands
            --                 :BufferCloseAllButCurrent
            --                 :BufferCloseAllButPinned
            --                 :BufferCloseAllButCurrentOrPinned
            --                 :BufferCloseBuffersLeft
            --                 :BufferCloseBuffersRight
            -- Magic buffer-picking mode
            map('n', '<BS>=', '<Cmd>BufferPick<CR>', opts)
            -- Sort automatically by...
            map('n', '<BS>b', '<Cmd>BufferOrderByBufferNumber<CR>', opts)
            map('n', '<BS>d', '<Cmd>BufferOrderByDirectory<CR>', opts)
            map('n', '<BS>l', '<Cmd>BufferOrderByLanguage<CR>', opts)
            map('n', '<BS>w', '<Cmd>BufferOrderByWindowNumber<CR>', opts)

            -- Other:
            -- :BarbarEnable - enables barbar (enabled by default)
            -- :BarbarDisable - very bad command, should never be used
        end
    },
    {
        "folke/which-key.nvim",
        config = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
            require("which-key").setup({
                -- your configuration comes here
                -- or leave it empty to use the default settings
                -- refer to the configuration section below
            })
        end,
    },
}
