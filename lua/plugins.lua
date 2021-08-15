-- begin by ensure packer is actually installed!
local execute = vim.api.nvim_command
local fn = vim.fn

local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
  fn.system({'git', 'clone', 'https://github.com/wbthomason/packer.nvim', install_path})
  execute 'packadd packer.nvim'
end

-- configure plugins
return require('packer').startup(function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    -- lsp and completion
    use 'neovim/nvim-lsp'
    use {
        'hrsh7th/nvim-compe',
        config = function()
            -- Use <Tab> and <S-Tab> to navigate through popup menu
            local function t(str)
                return vim.api.nvim_replace_termcodes(str, true, true, true)
            end
            function _G.smart_tab()
                return vim.fn.pumvisible() == 1 and t'<C-n>' or t'<Tab>'
            end
            function _G.smart_shift_tab()
                return vim.fn.pumvisible() == 1 and t'<C-p>' or t'<S-Tab>'
            end
            vim.api.nvim_set_keymap('i', '<TAB>', 'v:lua.smart_tab()', {expr = true, noremap = true})
            vim.api.nvim_set_keymap('i', '<S-TAB>', 'v:lua.smart_shift_tab()', {expr = true, noremap = true})

            -- use ctrl-space for manual completion
            vim.api.nvim_set_keymap('i', '<C-Space>', 'compe#complete()', {expr = true, noremap = true, silent = true})

            -- Set completeopt to have a better completion experience
            vim.go.completeopt = {'menuone', 'noinsert', 'noselect'}

            -- Avoid showing message extra message when using completion
            vim.go.shortmess:append({ c = true })
        end
    }
    use 'ray-x/lsp_signature.nvim'
    use 'folke/lsp-trouble.nvim'
    use 'kabouzeid/nvim-lspinstall'

    -- movement
    use 'tpope/vim-rsi'
    use 'ggandor/lightspeed.nvim'

    -- editing
    use 'tpope/vim-repeat'
    use 'scrooloose/nerdcommenter'
    use {
        'junegunn/vim-easy-align',
        config = function()
            vim.api.nvim_set_keymap('v', '<Enter>', '<Plug>(EasyAlign)')
            vim.api.nvim_set_keymap('n', 'gA', '<Plug>(EasyAlign)')
        end
    }
    use {
        'jiangmiao/auto-pairs',
        config = function()
            vim.g.AutoPairsFlyMode = 0
            vim.g.AutoPairsShortcutToggle = ''
            vim.g.AutoPairsShortcutBackInsert = '<A-b>'
        end
    }
    use 'tpope/vim-surround'
    use {'SirVer/ultisnips', requires = 'honza/vim-snippets'}
    use 'jeffkreeftmeijer/vim-numbertoggle'
    use 'chrisbra/unicode.vim'
    use 'wellle/targets.vim'
    use 'bfredl/nvim-miniyank'


    -- utils
    use 'nvim-treesitter/nvim-treesitter'
    use 'nvim-treesitter/playground'
    use {
        'tpope/vim-dispatch',
        config = function()
            vim.g.dispatch_compilers = {
                markdown = 'doit',
                python = 'python %'
            }

            -- remove iterm from the list of handlers (don't like it removing focus when run)
            vim.g.dispatch_handlers = {'tmux', 'screen', 'windows', 'x11', 'headless'}
        end
    }
    use 'tpope/vim-unimpaired'
    use 'tpope/vim-eunuch'
    use 'tpope/vim-obsession'
    use 'chrisbra/vim-diff-enhanced'
    use {
        'moll/vim-bbye',
        config = function()
            vim.api.nvim_set_keymap('n', 'Q', ':Bdelete<CR>', { noremap = true, silent = true })
        end
    }
    use 'justinmk/vim-dirvish'
    use {
        'junegunn/fzf',
        run = function() vim.fn['fzf#install']() end,
        requires='junegunn/fzf.vim'
    }
    use 'nvim-lua/plenary.nvim'
    use 'folke/todo-comments.nvim'
    use 'michaeljsmith/vim-indent-object'
    use 'norcalli/nvim-colorizer.lua'
    use 'majutsushi/tagbar'
    use 'kassio/neoterm'
    use 'christoomey/vim-tmux-navigator'
    use 'vim-test/vim-test'
    -- use 'rcarriga/vim-ultest', { 'do': ':UpdateRemoteuseins', 'for': 'python' }

    -- git
    use {
        'tpope/vim-fugitive',
        requires = {'tpope/vim-git', 'junegunn/gv.vim'},
        config = function()
            vim.api.nvim_set_keymap('n', 'git', ':Git ', {noremap = true})
            vim.api.nvim_set_keymap('n', '<leader>git', ':Git<CR>', {noremap = true})
            vim.api.nvim_set_keymap('n', '<leader>ga', ':Git commit -a<CR>', {noremap = true})
            vim.api.nvim_set_keymap('n', '<leader>gd', ':Git diff<CR>', {noremap = true})
            vim.api.nvim_set_keymap('n', '<leader>gP', ':Git pull<CR>', {noremap = true})
            vim.api.nvim_set_keymap('n', '<leader>gp', ':Git push<CR>', {noremap = true})
            vim.api.nvim_set_keymap('n', '<leader>g/', ':Git grep<CR>', {noremap = true})
        end
    }
    use 'lewis6991/gitsigns.nvim'
    use 'rhysd/git-messenger.vim'


    -- linting
    use 'neomake/neomake'


    -- looking good
    use 'kyazdani42/nvim-web-devicons'
    use 'nvim-lua/lsp-status.nvim'
    use 'glepnir/galaxyline.nvim'
    use 'gcmt/taboo.vim'
    use 'lukas-reineke/indent-blankline.nvim'


    -- prose
    use {
        'reedes/vim-wordy',
        opt = true,
        ft = {'markdown', 'tex', 'latex'}
    }
    use {
        'davidbeckingsale/writegood.vim',
        opt = true,
        ft = {'tex', 'markdown', 'latex'}
    }
    use {
        'folke/zen-mode.nvim',
    }


    -- colorschemes
    use 'navarasu/onedark.nvim'
    -- use 'KeitaNakamura/neodark.vim'


    -- filetypes
    -- python
    use {
        'vim-python/python-syntax',
        ft = { 'python' }
    }
    use {
        'Vimjas/vim-python-pep8-indent',
        ft = { 'python'}
    }
    use {
        'tmhedberg/SimpylFold',
        ft = { 'python' }
    }
    use {
        'anntzer/vim-cython',
        ft = { 'python', 'cython' }
    }


    -- other
    use {
        'adamclaxon/taskpaper.vim',
        opt = true,
        ft = { 'taskpaper', 'tp' }
    }
    use {
        'lervag/vimtex',
        ft = { 'tex' }
    }
    use {
        'vim-scripts/scons.vim',
        opt = true,
        ft = { 'scons' }
    }
    use {
        'Glench/Vim-Jinja2-Syntax',
        ft = { 'html' }
    }
    use {
        'mattn/emmet-vim',
        ft = { 'html', 'css', 'sass', 'jinja.html' }
    }
    use {
        'cespare/vim-toml',
        ft = { 'toml' }
    }
    use {'tikhomirov/vim-glsl', opt = true}
    use {'DingDean/wgsl.vim', opt = true}
    use 'NoahTheDuke/vim-just'


end)
