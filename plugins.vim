" vim:ft=vim

call plug#begin('~/.vim/plugged')

Plug 'Shougo/vimproc'
Plug 'junegunn/vim-easy-align'
Plug 'ctrlpvim/ctrlp.vim' | Plug 'd11wtq/ctrlp_bdelete.vim'
Plug 'FelikZ/ctrlp-py-matcher'
" Plug 'JazzCore/ctrlp-cmatcher', {'do': 'export CFLAGS=-Qunused-arguments && export CPPFLAGS=-Qunused-arguments && ./install.sh'}
Plug 'jiangmiao/auto-pairs'
Plug 'tpope/vim-fugitive' | Plug 'tpope/vim-git' | Plug 'junegunn/gv.vim'
Plug 'sjl/gundo.vim', { 'on': 'GundoToggle' }
Plug 'austintaylor/vim-indentobject'
Plug 'scrooloose/nerdcommenter'
" Plug 'vim-scripts/python_match.vim', { 'for': 'Python' }
" Plug 'cjrh/vim-conda'
" Plug '$HOME/code/vim-plugins/vim-ipython'
Plug 'vim-scripts/scons.vim'
Plug 'zakj/vim-showmarks', {'on': ['ShowMarksOn', 'ShowMarksToggle']}
Plug 'tpope/vim-surround'
Plug 'scrooloose/syntastic'
if os == 'Darwin'
    Plug 'tpope/vim-dispatch'
    Plug 'radenling/vim-dispatch-neovim'
else
    Plug 'smutch/vim-dispatch', { 'branch' : 'extra_env_vars' }
endif
Plug 'vim-scripts/TaskList.vim', { 'on': 'TaskList' }
Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'
Plug 'davidhalter/jedi-vim', { 'for': 'python' }
Plug 'natw/vim-pythontextobj', { 'for': 'python' }
Plug 'kana/vim-textobj-function'
Plug 'kana/vim-textobj-user'
Plug 'Yggdroot/indentLine'
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
Plug 'mhinz/vim-grepper'
Plug 'tpope/vim-vinegar'
" Plug 'justinmk/vim-dirvish'
Plug 'tmhedberg/SimpylFold', { 'for': 'python' }
Plug 'vim-airline/vim-airline' | Plug 'vim-airline/vim-airline-themes'
Plug 'tpope/vim-unimpaired'
Plug 'sheerun/vim-polyglot'
Plug 'edkolev/tmuxline.vim', { 'on': 'Tmuxline' }
Plug 'kana/vim-textobj-fold'
" Plug 'Konfekt/FastFold'
Plug 'git@github.com:smutch/note-system.git'
Plug 'ajh17/VimCompletesMe'
Plug 'junegunn/vim-peekaboo'
Plug 'davidoc/taskpaper.vim', { 'for': 'taskpaper' }
Plug 'nelstrom/vim-markdown-folding', { 'for': 'markdown' }
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' } | Plug 'junegunn/fzf.vim'
Plug 'reedes/vim-pencil'
Plug 'reedes/vim-wordy'
" Plug 'hail2u/vim-css3-syntax', { 'for': ['scss', 'css', 'sass'] }
" Plug 'cakebaker/scss-syntax.vim', { 'for': 'scss' }
Plug 'majutsushi/tagbar', { 'on': 'TagbarToggle' }
Plug 'tpope/vim-eunuch'
Plug 'heavenshell/vim-pydocstring', { 'for': 'python' }
Plug 'chrisbra/unicode.vim'
Plug 'wellle/targets.vim'

" colorschemes
Plug 'morhetz/gruvbox'
" if has('nvim')
"     Plug 'frankier/neovim-colors-solarized-truecolor-only'
" else
"     Plug 'git@github.com:smutch/vim-colors-solarized.git'
" endif
Plug 'git@github.com:smutch/vim-hybrid-material.git'
Plug 'junegunn/vim-emoji'
Plug 'w0ng/vim-hybrid'
Plug 'joshdick/onedark.vim', { 'on': 'Colors' }
Plug 'joshdick/airline-onedark.vim', { 'on': 'Colors' }
" Plug 'git@github.com:smutch/vim-monokai.git'
" Plug 'tomasr/molokai'
Plug 'reedes/vim-colors-pencil', { 'on': 'Colors' }

" These bundles are unlikely to be required anywhere other than on my mac
if os == "Darwin"
    Plug 'rizzatti/funcoo.vim' | Plug 'rizzatti/dash.vim'
    " Plug 'Glench/Vim-Jinja2-Syntax'
    Plug 'mattn/webapi-vim'
    Plug 'git@github.com:smutch/RST-Tables.git', { 'for': 'rst' }
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
