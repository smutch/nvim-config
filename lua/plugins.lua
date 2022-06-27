-- begin by ensure packer is actually installed!
local fn = vim.fn

local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
    PACKER_BOOTSTRAP = fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
    vim.cmd [[packadd packer.nvim]]
end
require 'packer'.init({ max_jobs = 50 })


-- configure plugins
return require 'packer'.startup(function(use, use_rocks)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    -- Utility stuff used by lots of plugins
    use 'nvim-lua/plenary.nvim'

    -- lsp {{{
    use 'neovim/nvim-lspconfig'
    use 'williamboman/nvim-lsp-installer'
    use { 'ray-x/lsp_signature.nvim', config = require "plugins.lsp_signature".config }
    use 'jose-elias-alvarez/null-ls.nvim'
    use 'nvim-lua/lsp_extensions.nvim'
	use 'kosayoda/nvim-lightbulb'
    use { 'folke/lsp-trouble.nvim', config = function() require("trouble").setup() end }

    -- Disabled just now as it doesn't work with pylsp (see winbar setup too)
    -- use 'SmiteshP/nvim-navic'

    -- The rockspec for this is currently broken. Need to wait for a fix.
    -- use_rocks {'luaformatter', server = 'https://luarocks.org/dev'}
    -- }}}

    -- completion {{{
    use 'hrsh7th/cmp-nvim-lsp'
    use 'hrsh7th/cmp-buffer'
    use { 'Saecki/crates.nvim', config = function() require "crates".setup() end }
    use 'hrsh7th/cmp-path'
    use 'hrsh7th/cmp-nvim-lua'
    use 'kdheepak/cmp-latex-symbols'
	use 'f3fora/cmp-spell'
	use 'hrsh7th/cmp-calc'
	use 'ray-x/cmp-treesitter'
	use 'hrsh7th/cmp-emoji'
	use 'hrsh7th/cmp-omni'
	use 'hrsh7th/cmp-cmdline'
    use 'lukas-reineke/cmp-under-comparator'
    use { 'hrsh7th/nvim-cmp', config = require "plugins.cmp".config }
    -- }}}

    -- snippets {{{
    use 'saadparwaiz1/cmp_luasnip'
	use 'rafamadriz/friendly-snippets'
	use 'onsails/lspkind-nvim'
    use { 'L3MON4D3/LuaSnip', config = require "plugins.luasnip".config }
    -- }}}

    -- editing {{{
    use { 'windwp/nvim-autopairs', config = require "plugins.autopairs".config }
    use { 'github/copilot.vim', opt = true, setup = require "plugins.copilot".setup }
    use 'tpope/vim-rsi'
    use { 'ggandor/leap.nvim', config = function() require('leap').set_default_keymaps() end }

    use 'tpope/vim-repeat'
    use { 'numToStr/Comment.nvim', config = require "plugins.comment".config }
    use { 'junegunn/vim-easy-align', config = require "plugins.easy-align".config }
    use 'michaeljsmith/vim-indent-object'
    use { 'tpope/vim-surround', config = require "plugins.vim-surround".config }
    use { 'jeffkreeftmeijer/vim-numbertoggle', opt = true }
    use { 'chrisbra/unicode.vim', opt = true }
    use 'wellle/targets.vim'
    use { 'edluffy/specs.nvim', config = require "plugins.specs".config }
    use { 'editorconfig/editorconfig-vim', config = require "plugins.editorconfig-vim".config }
    -- }}}

    -- treesitter {{{
    use {
        'nvim-treesitter/nvim-treesitter',
        requires = 'nvim-treesitter/nvim-treesitter-textobjects',
        run = ':TSUpdate',
        config = require "plugins.nvim-treesitter".config
    }
    use 'nvim-treesitter/nvim-treesitter-context'
    use { 'SmiteshP/nvim-gps', config = function() require("nvim-gps").setup() end }
    use { 'nvim-treesitter/playground', opt = true }
    use { 'tpope/vim-dispatch', config = require "plugins.vim-dispatch".config }
    -- }}}

    -- utils {{{
    use 'tpope/vim-unimpaired'
    use 'tpope/vim-eunuch'
    use { 'rmagatti/auto-session', config = require "plugins.auto-session".config }
    use 'chrisbra/vim-diff-enhanced'
    use { 'moll/vim-bbye', config = require "plugins.vim-bbye".config }

    use {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v2.x",
        requires = {
            "nvim-lua/plenary.nvim",
            "kyazdani42/nvim-web-devicons",
            "MunifTanjim/nui.nvim",
            {
                's1n7ax/nvim-window-picker',
                tag = "1.*",
                config = require "plugins.nvim-window-picker".config
            }
        },
        config = require "plugins.neo-tree".config
    }

    use "elihunter173/dirbuf.nvim"

    -- telescope {{{
    use { "AckslD/nvim-neoclip.lua", config = require "plugins.nvim-neoclip".config }
    use { 'nvim-telescope/telescope-fzy-native.nvim', run = 'make -C deps/fzy-lua-native' }
    use 'xiyaowong/telescope-emoji.nvim'
	use 'nvim-telescope/telescope-packer.nvim'
	use 'nvim-telescope/telescope-symbols.nvim'
    use { 'nvim-telescope/telescope-ui-select.nvim' }
    use { 'nvim-telescope/telescope.nvim', config = require "plugins.telescope".config }
    -- }}}

    use { "antoinemadec/FixCursorHold.nvim" }
    use { 'folke/todo-comments.nvim', config = function() require("todo-comments").setup {} end }
    use { 'norcalli/nvim-colorizer.lua', opt = true, config = function() require 'colorizer'.setup() end }
    use { 'majutsushi/tagbar', opt = true , config = require "plugins.tagbar".config }
    use 'christoomey/vim-tmux-navigator'
    use {
        "rcarriga/neotest",
        requires = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
            "antoinemadec/FixCursorHold.nvim",
            "rcarriga/neotest-python"
        },
        config = require "plugins.neotest".config
    }
    use { 'rcarriga/nvim-notify', config = function() vim.notify = require 'notify' end }

    -- git {{{
    use {
        'tpope/vim-fugitive',
        requires = 'tpope/vim-git',
        config = require "plugins.vim-fugitive".config
    }
    use 'junegunn/gv.vim'
    use { 'lewis6991/gitsigns.nvim', config = function() require('gitsigns').setup() end }
    use { 'f-person/git-blame.nvim', config = require "plugins.git-blame".config }
    -- }}}

    use { 'numToStr/FTerm.nvim', config = require "plugins.fterm".config }
    use { 'neomake/neomake', opt = true }
    use { 'kkoomen/vim-doge', run = ':call doge#install()', config = require "plugins.vim-dodge".config }
    use {'kevinhwang91/nvim-ufo', requires = 'kevinhwang91/promise-async', config = require "plugins.nvim-ufo".config }

    -- prose {{{
    use { 'reedes/vim-wordy', opt = true, ft = { 'markdown', 'tex', 'latex' } }
    use { 'davidbeckingsale/writegood.vim', opt = true, ft = { 'tex', 'markdown', 'latex' } }
    use { 'folke/zen-mode.nvim', opt = true, cmd = 'ZenMode', config = function() require("zen-mode").setup {} end }
    -- }}}

    -- }}}

    -- looking good {{{

    -- colorschemes {{{
    use { 'navarasu/onedark.nvim', opt = true }
    use { 'EdenEast/nightfox.nvim' }
    use { 'Shatur/neovim-ayu', opt = true }
    use { 'projekt0n/github-nvim-theme', opt = true, config = function() require 'github-theme'.setup { theme_style = 'dark' } end }
    use { 'rmehri01/onenord.nvim' }
    -- }}}

    use {
        'nvim-lualine/lualine.nvim',
        requires = { 'kyazdani42/nvim-web-devicons' },
        config = require 'plugins.lualine'.config
    }
    use { 'lukas-reineke/indent-blankline.nvim', config = require "plugins.indent-blankline".config }
    use { 'gcmt/taboo.vim', config = require "plugins.taboo".config }
    use { 'https://gitlab.com/yorickpeterse/nvim-pqf.git', config = function() require('pqf').setup() end }
    use { 'petertriho/nvim-scrollbar', requires = 'kevinhwang91/nvim-hlslens', config = require "plugins.nvim-scrollbar".config }
    -- }}}

    -- filetypes {{{

    -- python {{{
    use { 'vim-python/python-syntax', ft = { 'python' } }
    use { 'Vimjas/vim-python-pep8-indent', ft = { 'python' } }
    use { 'anntzer/vim-cython', ft = { 'python', 'cython' } }
    -- }}}

    use { 'adamclaxon/taskpaper.vim', opt = true, ft = { 'taskpaper', 'tp' } }
    use { 'lervag/vimtex', opt = true, ft = 'tex', config = require "plugins.vimtex".config, requires = 'jbyuki/nabla.nvim' }
    use { 'vim-scripts/scons.vim', opt = true, ft = { 'scons' } }
    use { 'Glench/Vim-Jinja2-Syntax', opt = true, ft = { 'html' } }
    use { 'mattn/emmet-vim', opt = true, ft = { 'html', 'css', 'sass', 'jinja.html' } }
    use { 'cespare/vim-toml', opt = true, ft = { 'toml' } }
    use { 'tikhomirov/vim-glsl', opt = true }
    use { 'DingDean/wgsl.vim', opt = true }
    use { 'snakemake/snakemake', rtp = 'misc/vim' }
    use 'NoahTheDuke/vim-just'
    use { 'alaviss/nim.nvim', ft = { 'nim' } }
    -- }}}

    if PACKER_BOOTSTRAP then
        require('packer').sync()
    end
end)

-- vim: set fdm=marker:
