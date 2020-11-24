" Load all plugins
call plug#begin('~/.config/nvim/plugged')

if !empty(glob("~/code/note-system"))
    Plug '~/code/note-system'
endif

" lsp and completion {{{
Plug 'neovim/nvim-lsp'
Plug 'nvim-lua/completion-nvim'
" Plug 'steelsojka/completion-buffers'
" Plug 'nvim-lua/diagnostic-nvim'
" }}}

" movement {{{
Plug 'tpope/vim-rsi'
Plug 'easymotion/vim-easymotion'
" Plug 'danilamihailov/beacon.nvim'
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
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-obsession'
Plug 'Shougo/echodoc.vim'
" Plug 'ncm2/float-preview.nvim'
Plug 'chrisbra/vim-diff-enhanced'
Plug 'moll/vim-bbye'
" Plug 'tpope/vim-vinegar'
Plug 'justinmk/vim-dirvish'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' } | Plug 'junegunn/fzf.vim'
" Plug 'ludovicchabant/vim-gutentags'
Plug 'michaeljsmith/vim-indent-object'
" Plug 'chrisbra/Colorizer'
Plug 'majutsushi/tagbar'
Plug 'kassio/neoterm'
" Plug 'glacambre/firenvim', { 'do': { _ -> firenvim#install(0) } }
" }}}

" tmux {{{
Plug 'tpope/vim-tbone'
Plug 'christoomey/vim-tmux-navigator'
Plug 'benmills/vimux'
" }}}

" git {{{
Plug 'tpope/vim-fugitive' | Plug 'tpope/vim-git' | Plug 'junegunn/gv.vim'
Plug 'airblade/vim-gitgutter'
Plug 'lambdalisue/vim-gista'
Plug 'rhysd/git-messenger.vim'
" }}}

" linting {{{
Plug 'neomake/neomake'
" }}}

" looking good {{{
" Plug 'vim-airline/vim-airline' | Plug 'vim-airline/vim-airline-themes'
Plug 'ryanoasis/vim-devicons'
Plug 'hardcoreplayers/spaceline.vim' ", {'commit': 'd5ae1bf8968b504e5ad3a21f97cb73052a5d99e5'}
Plug 'gcmt/taboo.vim'
" }}}

" prose {{{
Plug 'reedes/vim-wordy', { 'for': ['markdown', 'tex', 'latex'] }
Plug 'davidbeckingsale/writegood.vim', { 'for': ['tex', 'markdown', 'latex'] }
Plug 'junegunn/goyo.vim', { 'on': 'Goyo' }
" }}}

" colorschemes {{{
Plug 'morhetz/gruvbox'
" Plug 'w0ng/vim-hybrid'
Plug 'reedes/vim-colors-pencil'
Plug 'NLKNguyen/papercolor-theme'
Plug 'rakr/vim-one'
Plug 'sonph/onehalf', {'rtp': 'vim/'}
Plug 'drewtempelmeyer/palenight.vim'
Plug 'arcticicestudio/nord-vim'
Plug 'cormacrelf/vim-colors-github'
" Plug 'mhartington/oceanic-next'
Plug 'rakr/vim-two-firewatch'
" Plug 'dracula/vim'
" Plug 'ayu-theme/ayu-vim'
Plug 'owickstrom/vim-colors-paramount'
Plug 'andreypopp/vim-colors-plain'
" }}}

" filetypes {{{
" python {{{
Plug 'vim-python/python-syntax', { 'for': 'python' }
Plug 'Vimjas/vim-python-pep8-indent', { 'for': 'python'}
" Plug 'davidhalter/jedi-vim', { 'for': 'python' }
Plug 'tmhedberg/SimpylFold', { 'for': 'python' }
Plug 'anntzer/vim-cython', { 'for': ['python', 'cython'] }
" }}}

" other {{{
Plug 'adamclaxon/taskpaper.vim', { 'for': ['taskpaper', 'tp'] }
Plug 'lervag/vimtex', { 'for': 'tex' }
Plug 'vim-scripts/scons.vim'
Plug 'Glench/Vim-Jinja2-Syntax', { 'for': 'html' }
" Plug 'sheerun/vim-polyglot'
Plug 'mattn/emmet-vim', { 'for': ['html', 'css', 'sass', 'jinja.html'] }
Plug 'cespare/vim-toml'
" Plug 'vim-pandoc/vim-pandoc-syntax'
" }}}
" }}}

call plug#end()

filetype plugin on
filetype indent on
