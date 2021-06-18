" Load all plugins
call plug#begin('~/.config/nvim/plugged')

if !empty(glob("~/code/note-system"))
    Plug '~/code/note-system'
endif

" lsp and completion {{{
Plug 'neovim/nvim-lsp'
Plug 'hrsh7th/nvim-compe'
Plug 'ray-x/lsp_signature.nvim'
Plug 'folke/lsp-trouble.nvim'
Plug 'kabouzeid/nvim-lspinstall'
" }}}

" movement {{{
Plug 'tpope/vim-rsi'
Plug 'ggandor/lightspeed.nvim'
" }}}

" editing {{{
Plug 'tpope/vim-repeat'
" Plug 'tpope/vim-abolish'
Plug 'scrooloose/nerdcommenter'
Plug 'junegunn/vim-easy-align'
Plug 'jiangmiao/auto-pairs'
Plug 'tpope/vim-surround'
Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'
Plug 'jeffkreeftmeijer/vim-numbertoggle'
Plug 'chrisbra/unicode.vim'
Plug 'wellle/targets.vim'
Plug 'dyng/ctrlsf.vim'
Plug 'bfredl/nvim-miniyank'
" }}}

" utils {{{
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'nvim-treesitter/playground'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-obsession'
Plug 'Shougo/echodoc.vim'
Plug 'chrisbra/vim-diff-enhanced'
Plug 'moll/vim-bbye'
Plug 'justinmk/vim-dirvish'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' } | Plug 'junegunn/fzf.vim'
Plug 'nvim-lua/plenary.nvim'
Plug 'folke/todo-comments.nvim'
" Plug 'ludovicchabant/vim-gutentags'
Plug 'michaeljsmith/vim-indent-object'
Plug 'norcalli/nvim-colorizer.lua' 
Plug 'majutsushi/tagbar'
Plug 'kassio/neoterm'
Plug 'christoomey/vim-tmux-navigator'
Plug 'vim-test/vim-test'
Plug 'rcarriga/vim-ultest', { 'do': ':UpdateRemotePlugins' }
" }}}

" git {{{
Plug 'tpope/vim-fugitive' | Plug 'tpope/vim-git' | Plug 'junegunn/gv.vim'
Plug 'airblade/vim-gitgutter'
Plug 'rhysd/git-messenger.vim'
" }}}

" linting {{{
Plug 'neomake/neomake'
" }}}

" looking good {{{
Plug 'kyazdani42/nvim-web-devicons'
Plug 'folke/lsp-colors.nvim'
Plug 'nvim-lua/lsp-status.nvim'
Plug 'glepnir/galaxyline.nvim'
Plug 'gcmt/taboo.vim'
Plug 'lukas-reineke/indent-blankline.nvim', {'branch': 'lua'}
" }}}

" prose {{{
Plug 'reedes/vim-wordy', { 'for': ['markdown', 'tex', 'latex'] }
Plug 'davidbeckingsale/writegood.vim', { 'for': ['tex', 'markdown', 'latex'] }
Plug 'folke/zen-mode.nvim'
" }}}

" colorschemes {{{
Plug 'morhetz/gruvbox'
Plug 'NLKNguyen/papercolor-theme'
Plug 'rakr/vim-one'
Plug 'arcticicestudio/nord-vim'
Plug 'owickstrom/vim-colors-paramount'
Plug 'andreypopp/vim-colors-plain'
Plug 'folke/tokyonight.nvim'
Plug 'tjdevries/colorbuddy.nvim'
Plug 'folke/material.nvim'
Plug 'navarasu/onedark.nvim'
" }}}

" filetypes {{{
" python {{{
Plug 'vim-python/python-syntax', { 'for': 'python' }
Plug 'Vimjas/vim-python-pep8-indent', { 'for': 'python'}
Plug 'tmhedberg/SimpylFold', { 'for': 'python' }
Plug 'anntzer/vim-cython', { 'for': ['python', 'cython'] }
" }}}

" other {{{
Plug 'adamclaxon/taskpaper.vim', { 'for': ['taskpaper', 'tp'] }
Plug 'lervag/vimtex', { 'for': 'tex' }
Plug 'vim-scripts/scons.vim'
Plug 'Glench/Vim-Jinja2-Syntax', { 'for': 'html' }
Plug 'mattn/emmet-vim', { 'for': ['html', 'css', 'sass', 'jinja.html'] }
Plug 'cespare/vim-toml', { 'for': ['toml'] }
Plug 'tikhomirov/vim-glsl'
Plug 'DingDean/wgsl.vim'
Plug 'NoahTheDuke/vim-just'
" }}}
" }}}

call plug#end()

filetype plugin on
filetype indent on
