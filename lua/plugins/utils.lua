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
     {
         'moll/vim-bbye',
         config = function()
             vim.api.nvim_set_keymap('n', 'Q', ':Bdelete<CR>', { noremap = true, silent = true })
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
    { "kyazdani42/nvim-web-devicons" },
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
            vim.api.nvim_set_keymap('n', '<leader>F', '<cmd>Neotree reveal<cr>', { noremap = true })
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
    {
        "rcarriga/neotest",
        config = function()
            require("neotest").setup({
                adapters = {
                    require("neotest-python"),
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
    { 'rcarriga/nvim-notify', config = true },
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
}
