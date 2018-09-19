" vim:ft=vim:fdm=marker

call plug#begin('~/.vim/plugged')

if !empty(glob("~/code/note-system"))
    Plug '~/code/note-system'
endif

" completion {{{
" Plug 'smutch/ncm2', { 'branch': 'hackfix' }
Plug 'ncm2/ncm2'
Plug 'roxma/nvim-yarp'  " ncm2 requires nvim-yarp

" some completion sources
Plug 'ncm2/ncm2-bufword'
Plug 'ncm2/ncm2-tmux'
Plug 'ncm2/ncm2-path'
Plug 'ncm2/ncm2-jedi'
Plug 'ncm2/ncm2-ultisnips'
Plug 'ncm2/ncm2-pyclang'
Plug 'ncm2/ncm2-tagprefix'
" }}}

" movement {{{
Plug 'tpope/vim-rsi'
Plug 'justinmk/vim-sneak'
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
" Plug 'chrisbra/unicode.vim'
Plug 'wellle/targets.vim'
Plug 'dyng/ctrlsf.vim'
" }}}

" utils {{{
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-obsession'
Plug 'Shougo/echodoc.vim'
Plug 'chrisbra/vim-diff-enhanced'
Plug 'moll/vim-bbye'
Plug 'justinmk/vim-dirvish'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' } | Plug 'junegunn/fzf.vim'
Plug 'ludovicchabant/vim-gutentags'
Plug 'michaeljsmith/vim-indent-object'
Plug 'chrisbra/Colorizer'
Plug 'majutsushi/tagbar'
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
" }}}

" linting {{{
Plug 'w0rp/ale'
" }}}

" looking good {{{
Plug 'vim-airline/vim-airline' | Plug 'vim-airline/vim-airline-themes'
" Plug 'ryanoasis/vim-devicons'
" }}}

" prose {{{
Plug 'reedes/vim-wordy', { 'for': ['markdown', 'tex', 'latex'] }
Plug 'davidbeckingsale/writegood.vim', { 'for': ['tex', 'markdown', 'latex'] }
Plug 'junegunn/goyo.vim', { 'on': 'Goyo' }
" }}}

" colorschemes {{{
Plug 'morhetz/gruvbox'
Plug 'w0ng/vim-hybrid'
Plug 'reedes/vim-colors-pencil'
Plug 'NLKNguyen/papercolor-theme'
Plug 'rakr/vim-one'
Plug 'arcticicestudio/nord-vim'
" }}}

" filetypes {{{
" python {{{
Plug 'vim-python/python-syntax', { 'for': 'python' }
Plug 'Vimjas/vim-python-pep8-indent', { 'for': 'python'}
Plug 'davidhalter/jedi-vim', { 'for': 'python' }
Plug 'tmhedberg/SimpylFold', { 'for': 'python' }
Plug 'anntzer/vim-cython', { 'for': ['python', 'cython'] }
" }}}

" rust {{{
Plug 'racer-rust/vim-racer', { 'for': 'rust' }
Plug 'roxma/nvim-cm-racer', { 'for': 'rust' }
" }}}

" other {{{
Plug 'adamclaxon/taskpaper.vim', { 'for': ['taskpaper', 'tp'] }
Plug 'lervag/vimtex', { 'for': 'tex' }
Plug 'vim-scripts/scons.vim'
" Plug 'sheerun/vim-polyglot'
Plug 'mattn/emmet-vim'
Plug 'vim-pandoc/vim-pandoc-syntax'
" }}}
" }}}

call plug#end()
