" vim:ft=vim

call plug#begin('~/.vim/plugged')

" Plug 'mileszs/ack.vim'
" Plug 'vim-scripts/Align'
Plug 'junegunn/vim-easy-align'
" Plug 'ctrlpvim/ctrlp.vim'
" Plug 'd11wtq/ctrlp_bdelete.vim'
" Plug 'fisadev/vim-ctrlp-cmdpalette'
" Plug 'FelikZ/ctrlp-py-matcher'
Plug 'jiangmiao/auto-pairs'
" Plug 'vim-scripts/delimitMate.vim'
Plug 'tpope/vim-fugitive'
Plug 'git@github.com:smutch/vim-gf-diff.git'
Plug 'kana/vim-gf-user'
Plug 'mattn/gist-vim', { 'on': 'Gist' }
Plug 'tpope/vim-git'
Plug 'gregsexton/gitv', { 'on': 'Gitv' }
Plug 'sjl/gundo.vim', { 'on': 'GundoToggle' }
Plug 'austintaylor/vim-indentobject'
Plug 'scrooloose/nerdcommenter'
Plug 'vim-scripts/python_match.vim', { 'for': 'Python' }
" Plug 'kien/rainbow_parentheses.vim'
Plug 'vim-scripts/scons.vim'
Plug 'mtth/scratch.vim', { 'on': 'Scratch' }
Plug 'zakj/vim-showmarks', {'on': ['ShowMarksOn', 'ShowMarksToggle']}
Plug 'tpope/vim-surround'
" if has("nvim")
    " Plug 'benekastah/neomake'
" else
    Plug 'scrooloose/syntastic'
    Plug 'tpope/vim-dispatch'
    Plug 'radenling/vim-dispatch-neovim'
" endif
Plug 'vim-scripts/TaskList.vim', { 'on': 'TaskList' }
Plug 'SirVer/ultisnips'
Plug 'davidhalter/jedi-vim', { 'for': 'python' }
Plug 'natw/vim-pythontextobj', { 'for': 'python' }
Plug 'kana/vim-textobj-function'
Plug 'kana/vim-textobj-user'
Plug 'Yggdroot/indentLine'
Plug 'airblade/vim-gitgutter'
Plug 'Shougo/vimproc'
Plug 'git@github.com:smutch/vim-ipython.git', { 'for': 'python' }
Plug 'tpope/vim-obsession', { 'on': 'Obsession' }
Plug 'tpope/vim-rsi'
" Plug 'smutch/gfplaintasks.vim'
Plug 'tpope/vim-tbone'
Plug 'git@github.com:smutch/vim-tmuxify.git'
Plug 'jeffkreeftmeijer/vim-numbertoggle'
Plug 'moll/vim-bbye'
" Plug 'Lokaltog/vim-easymotion'
Plug 'justinmk/vim-sneak'
Plug 'tpope/vim-repeat'
" Plug 'rking/ag.vim'
Plug 'mhinz/vim-grepper'
" Plug 'goldfeld/vim-seek'
Plug 'tpope/vim-vinegar'
Plug 'tmhedberg/SimpylFold', { 'for': 'python' }
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'tpope/vim-unimpaired'
Plug 'honza/vim-snippets'
Plug 'sheerun/vim-polyglot'
Plug 'edkolev/tmuxline.vim', { 'on': 'Tmuxline' }
Plug 'kana/vim-textobj-fold'
" Plug 'Konfekt/FastFold'
Plug 'talek/obvious-resize'
" Plug 'git@github.com:smutch/note-system.git'
Plug 'ajh17/VimCompletesMe'
Plug 'junegunn/vim-peekaboo'
Plug 'chrisbra/NrrwRgn', {'on': 'NrrwrgnDo'}
Plug 'milkypostman/vim-togglelist'
Plug 'davidoc/taskpaper.vim'
Plug 'nelstrom/vim-markdown-folding'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'vim-scripts/Conque-GDB', { 'on': 'ConqueGdb' }
Plug 'reedes/vim-pencil'
Plug 'reedes/vim-wordy'
Plug 'hail2u/vim-css3-syntax', { 'for': ['scss', 'css', 'sass'] }
Plug 'cakebaker/scss-syntax.vim', { 'for': 'scss' }
Plug 'majutsushi/tagbar'
Plug 'tpope/vim-eunuch'
Plug 'heavenshell/vim-pydocstring'
if has("nvim")
    Plug 'cjrh/vim-conda'
endif
Plug 'christoomey/vim-tmux-navigator'
Plug 'chrisbra/unicode.vim'
Plug 'AndrewRadev/splitjoin.vim'
Plug 'wellle/targets.vim'
Plug 'gorkunov/smartpairs.vim'
Plug 'severin-lemaignan/vim-minimap'

" colorschemes
Plug 'morhetz/gruvbox'
Plug 'git@github.com:smutch/vim-colors-solarized.git'
" Plug 'vim-scripts/CSApprox'
" Plug 'chriskempson/base16-vim'
Plug 'NLKNguyen/papercolor-theme'
Plug 'sjl/badwolf'
Plug 'git@github.com:smutch/vim-hybrid-material.git'
Plug 'junegunn/vim-emoji'
Plug 'w0ng/vim-hybrid'
Plug 'noahfrederick/vim-noctu'

" These bundles are unlikely to be required anywhere other than on my mac
if os == "Darwin"
    Plug 'rizzatti/funcoo.vim'
    Plug 'rizzatti/dash.vim'
    " Plug 'Glench/Vim-Jinja2-Syntax'
    Plug 'mattn/webapi-vim'
    Plug 'git@github.com:smutch/RST-Tables.git', { 'for': 'rst' }
    Plug 'lervag/vim-latex' ", { 'for': 'tex' }
    Plug 'kchmck/vim-coffee-script', { 'for': 'coffee' }
    Plug 'tyru/open-browser.vim'
    Plug 'davidbeckingsale/writegood.vim', { 'for': 'tex' }
    Plug 'junegunn/goyo.vim', { 'on': 'Goyo' }
    " Plug 'vim-scripts/JavaScript-Indent'
    Plug 'lilydjwg/colorizer'
    Plug 'ternjs/tern_for_vim'
    Plug 'KabbAmine/vCoolor.vim'

    " colorschemes
    Plug 'git@github.com:smutch/vim-monokai.git'
    Plug 'tomasr/molokai'
    Plug 'reedes/vim-colors-pencil'
    Plug 'jonathanfilip/vim-lucius'
    Plug 'chankaward/vim-railscasts-theme'
    Plug 'junegunn/limelight.vim'
    Plug 'joshdick/onedark.vim'
    Plug 'joshdick/airline-onedark.vim'
endif

Plug 'ryanoasis/vim-devicons'

call plug#end()
