" vim:ft=vim

call plug#begin('~/.vim/plugged')

Plug 'Shougo/vimproc'
Plug 'junegunn/vim-easy-align'
Plug 'ctrlpvim/ctrlp.vim' | Plug 'd11wtq/ctrlp_bdelete.vim'
Plug 'FelikZ/ctrlp-py-matcher'
Plug 'jiangmiao/auto-pairs'
Plug 'tpope/vim-fugitive' | Plug 'tpope/vim-git' | Plug 'junegunn/gv.vim'
Plug 'austintaylor/vim-indentobject'
Plug 'scrooloose/nerdcommenter'
Plug 'vim-scripts/scons.vim'
" Plug 'zakj/vim-showmarks', {'on': ['ShowMarksOn', 'ShowMarksToggle']}
Plug 'tpope/vim-surround'
Plug 'neomake/neomake'
if os == 'Darwin'
    Plug 'tpope/vim-dispatch'
else
    Plug 'smutch/vim-dispatch', { 'branch' : 'extra_env_vars' }
endif
Plug 'radenling/vim-dispatch-neovim'
Plug 'vim-scripts/TaskList.vim', { 'on': 'TaskList' }
Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'
Plug 'davidhalter/jedi-vim', { 'for': 'python' }
Plug 'tmhedberg/SimpylFold', { 'for': 'python' }
Plug 'kana/vim-textobj-function'
Plug 'kana/vim-textobj-user'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-obsession', { 'on': 'Obsession' }
Plug 'tpope/vim-rsi'
" Plug 'smutch/gfplaintasks.vim'
Plug 'tpope/vim-tbone'
" Plug 'git@github.com:smutch/vim-tmuxify.git'
Plug 'jeffkreeftmeijer/vim-numbertoggle'
Plug 'moll/vim-bbye'
Plug 'justinmk/vim-sneak'
Plug 'tpope/vim-repeat'
Plug 'justinmk/vim-dirvish'
Plug 'vim-airline/vim-airline' | Plug 'vim-airline/vim-airline-themes'
Plug 'tpope/vim-unimpaired'
Plug 'sheerun/vim-polyglot'
Plug 'edkolev/tmuxline.vim', { 'on': 'Tmuxline' }
Plug 'kana/vim-textobj-fold'
Plug 'git@github.com:smutch/note-system.git'
Plug 'ajh17/VimCompletesMe'
Plug 'junegunn/vim-peekaboo'
Plug 'davidoc/taskpaper.vim', { 'for': 'taskpaper' }
Plug 'nelstrom/vim-markdown-folding', { 'for': 'markdown' }
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' } | Plug 'junegunn/fzf.vim'
Plug 'reedes/vim-pencil'
Plug 'reedes/vim-wordy'
Plug 'tpope/vim-eunuch'
Plug 'chrisbra/unicode.vim'
Plug 'wellle/targets.vim'
Plug 'OmniCppComplete'
Plug 'ludovicchabant/vim-gutentags'
Plug 'christoomey/vim-tmux-navigator'

" colorschemes
Plug 'morhetz/gruvbox'
Plug 'w0ng/vim-hybrid'
" Plug 'git@github.com:smutch/vim-hybrid-material.git'
if exists('&termguicolors')
    Plug 'dikiaap/minimalist'
    Plug 'junegunn/vim-emoji'
    Plug 'rakr/vim-one'
    Plug 'joshdick/onedark.vim'
    Plug 'NLKNguyen/papercolor-theme'
    Plug 'reedes/vim-colors-pencil'
    Plug 'rakr/vim-two-firewatch'
    Plug 'tyrannicaltoucan/vim-deep-space'
    Plug 'raphamorim/lucario'
    Plug 'owickstrom/vim-colors-paramount'
    Plug 'jdkanani/vim-material-theme'
    Plug 'dracula/vim'
endif

" These bundles are unlikely to be required anywhere other than on my mac
if os == "Darwin"
    " Plug 'hail2u/vim-css3-syntax', { 'for': ['scss', 'css', 'sass'] }
    " Plug 'cakebaker/scss-syntax.vim', { 'for': 'scss' }
    " Plug 'Glench/Vim-Jinja2-Syntax'
    Plug 'mattn/webapi-vim'
    Plug 'lervag/vimtex'
    Plug 'kchmck/vim-coffee-script', { 'for': 'coffee' }
    Plug 'davidbeckingsale/writegood.vim', { 'for': 'tex' }
    Plug 'junegunn/goyo.vim', { 'on': 'Goyo' }
    " Plug 'vim-scripts/JavaScript-Indent'
    Plug 'lilydjwg/colorizer'
    Plug 'ternjs/tern_for_vim', { 'for': 'javascript' }
    Plug 'KabbAmine/vCoolor.vim'
    Plug 'junegunn/limelight.vim'
    Plug 'mattn/emmet-vim'
endif

Plug 'ryanoasis/vim-devicons'

call plug#end()
