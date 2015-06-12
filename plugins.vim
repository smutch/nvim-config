" vim:ft=vim

call plug#begin('~/.vim/plugged')

Plug 'mileszs/ack.vim'
Plug 'vim-scripts/Align'
Plug 'b4winckler/vim-angry'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'vim-scripts/delimitMate.vim'
Plug 'tpope/vim-fugitive'
Plug 'git@github.com:smutch/vim-gf-diff.git'
Plug 'kana/vim-gf-user'
Plug 'mattn/gist-vim', { 'on': 'Gist' }
Plug 'tpope/vim-git'
Plug 'gregsexton/gitv', { 'on': 'Gitv' }
Plug 'sjl/gundo.vim', { 'on': 'Gundo' }
Plug 'austintaylor/vim-indentobject'
Plug 'scrooloose/nerdcommenter'
" Plug 'fs111/pydoc.vim'
Plug 'vim-scripts/python_match.vim'
" Plug 'kien/rainbow_parentheses.vim'
Plug 'vim-scripts/scons.vim'
Plug 'mtth/scratch.vim', { 'on': 'Scratch' }
Plug 'zakj/vim-showmarks', {'on': ['ShowMarksOn', 'ShowMarksToggle']}
Plug 'tpope/vim-surround'
if has("nvim")
    Plug 'benekastah/neomake'
else
    Plug 'scrooloose/syntastic'
    Plug 'tpope/vim-dispatch'
endif
Plug 'vim-scripts/taglist.vim'
Plug 'vim-scripts/TaskList.vim', { 'on': 'TaskList' }
" Plug 'benmills/vimux'
Plug 'SirVer/ultisnips'
Plug 'davidhalter/jedi-vim', { 'for': 'python' }
Plug 'natw/vim-pythontextobj'
Plug 'kana/vim-textobj-function'
Plug 'kana/vim-textobj-user'
Plug 'Yggdroot/indentLine'
Plug 'airblade/vim-gitgutter'
Plug 'Shougo/vimproc'
Plug 'ivanov/vim-ipython', { 'on': 'Ipython' }
Plug 'tpope/vim-obsession', { 'on': 'Obsession' }
Plug 'smutch/gfplaintasks.vim'
Plug 'tpope/vim-tbone'
Plug 'git@github.com:smutch/vim-tmuxify.git'
Plug 'jeffkreeftmeijer/vim-numbertoggle'
Plug 'moll/vim-bbye'
Plug 'Lokaltog/vim-easymotion'
Plug 'rhysd/clever-f.vim'
Plug 'tpope/vim-repeat'
Plug 'rking/ag.vim'
Plug 'goldfeld/vim-seek'
Plug 'tpope/vim-vinegar'
Plug 'tmhedberg/SimpylFold'
Plug 'bling/vim-airline'
" Plug 'gcmt/wildfire.vim'
Plug 'tpope/vim-unimpaired'
Plug 'honza/vim-snippets'
Plug 'sheerun/vim-polyglot'
Plug 'machakann/vim-textobj-delimited'
Plug 'edkolev/tmuxline.vim'
Plug 'kana/vim-textobj-fold'
Plug 'haya14busa/incsearch.vim'
Plug 'FelikZ/ctrlp-py-matcher'
Plug 'Konfekt/FastFold'
Plug 'talek/obvious-resize'
" Plug 'git@github.com:smutch/note-system.git'
Plug 'ajh17/VimCompletesMe'
Plug 'sjl/clam.vim'
Plug 'junegunn/vim-peekaboo'
Plug 'd11wtq/ctrlp_bdelete.vim'
Plug 'chrisbra/NrrwRgn'
Plug 'fisadev/vim-ctrlp-cmdpalette'
Plug 'milkypostman/vim-togglelist'
Plug 'godlygeek/tabular'  " N.B. This must come BEFORE vim-markdown
Plug 'plasticboy/vim-markdown'
" Plug 'neilagabriel/vim-geeknote'

" colorschemes
Plug 'morhetz/gruvbox'
Plug 'git@github.com:smutch/vim-colors-solarized.git'

" These bundles are unlikely to be required anywhere other than on my mac
if os == "Darwin"
    Plug 'rizzatti/funcoo.vim'
    Plug 'rizzatti/dash.vim'
    Plug 'Glench/Vim-Jinja2-Syntax'
    Plug 'mattn/webapi-vim'
    Plug 'git@github.com:smutch/RST-Tables.git', { 'for': 'rst' }
    " Plug 'git@github.com:smutch/LaTeX-Box.git'
    Plug 'lervag/vim-latex', { 'for': 'tex' }
    " Plug 'kchmck/vim-coffee-script'
    Plug 'tyru/open-browser.vim'
    Plug 'davidbeckingsale/writegood.vim'
    Plug 'junegunn/goyo.vim', { 'on': 'Goyo' }
    " Plug 'vim-scripts/JavaScript-Indent'

    " colorschemes
    Plug 'git@github.com:smutch/vim-monokai.git'
    Plug 'reedes/vim-colors-pencil'
    Plug 'jonathanfilip/vim-lucius'
    Plug 'freeo/vim-kalisi'
    Plug 'DAddYE/soda.vim'
    Plug 'whatyouhide/vim-gotham'
    Plug 'chriskempson/base16-vim'
    Plug 'chankaward/vim-railscasts-theme'
    Plug 'junegunn/limelight.vim'
    Plug 'NLKNguyen/papercolor-theme'
endif

call plug#end()
