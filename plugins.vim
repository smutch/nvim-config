" vim:ft=vim

call plug#begin('~/.vim/plugged')

Plug 'tpope/vim-repeat'
Plug 'ajh17/VimCompletesMe'
Plug 'junegunn/vim-easy-align'
Plug 'ctrlpvim/ctrlp.vim' | Plug 'd11wtq/ctrlp_bdelete.vim'
Plug 'FelikZ/ctrlp-py-matcher'
Plug 'tpope/vim-fugitive' | Plug 'tpope/vim-git' | Plug 'junegunn/gv.vim'
Plug 'scrooloose/nerdcommenter'
Plug 'jiangmiao/auto-pairs'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-abolish'
Plug 'neomake/neomake'
Plug 'kassio/neoterm'
Plug 'tpope/vim-dispatch'
Plug 'radenling/vim-dispatch-neovim'
Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'
Plug 'davidhalter/jedi-vim', { 'for': 'python' }
Plug '5long/pytest-vim-compiler', { 'for': 'python' }
Plug 'tmhedberg/SimpylFold', { 'for': 'python' }
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-rsi'
Plug 'tpope/vim-tbone'
Plug 'jeffkreeftmeijer/vim-numbertoggle'
Plug 'moll/vim-bbye'
Plug 'justinmk/vim-sneak'
Plug 'justinmk/vim-dirvish'
Plug 'vim-airline/vim-airline' | Plug 'vim-airline/vim-airline-themes'
" Plug 'git@github.com:smutch/note-system.git'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' } | Plug 'junegunn/fzf.vim'
Plug 'reedes/vim-pencil', { 'for': ['markdown', 'text', 'tex', 'latex'] }
Plug 'reedes/vim-wordy', { 'for': ['markdown', 'tex', 'latex'] }
Plug 'davidbeckingsale/writegood.vim', { 'for': ['tex', 'markdown', 'latex'] }
Plug 'vim-scripts/OmniCppComplete', { 'for': ['c', 'cpp'] }
Plug 'tpope/vim-eunuch'
Plug 'chrisbra/unicode.vim'
Plug 'wellle/targets.vim'
Plug 'ludovicchabant/vim-gutentags'
Plug 'christoomey/vim-tmux-navigator'
Plug 'benmills/vimux'
Plug 'junegunn/goyo.vim', { 'on': 'Goyo' }
Plug 'lervag/vimtex', { 'for': 'tex' }
Plug 'mattn/emmet-vim'
Plug 'michaeljsmith/vim-indent-object'
Plug 'dyng/ctrlsf.vim'

" colorschemes
Plug 'morhetz/gruvbox'
Plug 'w0ng/vim-hybrid'
Plug 'rakr/vim-one'
Plug 'reedes/vim-colors-pencil'
Plug 'NLKNguyen/papercolor-theme'
Plug 'ryanoasis/vim-devicons'
Plug 'nightsense/seabird'

" filetypes
Plug 'vim-python/python-syntax', { 'for': 'python' }
Plug 'vim-scripts/scons.vim'
Plug 'sheerun/vim-polyglot'
Plug 'kchmck/vim-coffee-script', { 'for': 'coffee' }

call plug#end()
