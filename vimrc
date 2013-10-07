" Vim config file
set nocompatible

" Do system specific settings
let os = substitute(system('uname'), "\n", "", "")
if os == "Darwin"
    set showcmd                          " Show info for current command
    let Tlist_Ctags_Cmd="/usr/local/bin/ctags"
end

if filereadable(expand("~/.vim/vimrc.before"))
  source ~/.vim/vimrc.before
endif

" Load all plugins
if filereadable(expand("~/.vim/vimrc.bundles"))
  source ~/.vim/vimrc.bundles
endif

" Source plugin specific settings
runtime! plugin/settings/*.vim

filetype plugin on
filetype indent on

if has("gui_macvim")
  set guifont=Menlo:h12
  set guioptions-=T  " remove toolbar
  set anti
  set linespace=2 "Increase the space between lines for better readability
  " In order for the ropevim quick keybindings to work (i.e. 'M-/')
  " we must allow MacVim to interpret the option key as Meta...
  set invmmta
else
  " Remap meta-keys to work with ropevim.
  set <M-/>=/
  imap / <M-/>
  " Set the ttymouse value to allow window resizing with mouse
  set ttymouse=xterm2
end

" -----------
" Colorscheme 
" -----------
syntax on " Use syntax highlighting
if exists('$SOLARIZED_THEME')
    if $SOLARIZED_THEME=="light"
        set background=light
    endif
else
    set background=dark
endif
if has("gui_running")
    colorscheme Monokai
elseif &t_Co >= 256
    colorscheme solarized
else
    set background=dark
    colorscheme ir_black
end

" highlight the 80th column
" In Vim >= 7.3, also highlight columns 120+
" if exists('+colorcolumn')
"   let &colorcolumn="80,".join(range(120,320),",")
" else
"   " fallback for Vim < v7.3
"   autocmd BufWinEnter * let w:m2=matchadd('ErrorMsg', '\%>80v.\+', -1)
" endif


"  --------------
"  Basic settings
"  --------------
set autoindent                       " Autoindent
set nosmartindent                    " Turning this off as messes with python comment indents.
set incsearch                        " Highlight matches as you type
set hlsearch                         " Highlight matches
set showmatch                        " Show matching paren
set laststatus=2
set clipboard=unnamed                " To work in tmux

set vb t_vb=                         " Turn off visual beep
set mouse=a                          " enable mouse for all modes settings
set cmdheight=1                      " Command line height
set history=1000                     " Store a ton of history (default is 20)

set wrap                             " Wrap lines
set linebreak                        " Wrap at breaks
set textwidth=0 wrapmargin=0
set display=lastline
set formatoptions+=l                 " Dont mess with the wrapping of existing lines

set expandtab tabstop=4 shiftwidth=4 " 4 spaces for tabs
set backspace=indent,eol,start       " Sane backspace

set ignorecase                       " case insensitive search
set smartcase                        " case sensitive when uc present
set wildmenu                         " show list instead of just completing
set gdefault                         " g flag on sed subs automatically
set hidden                           " Don't unload a buffer when abandoning it

set autoread                         " Automatically re-read changed files
set wildignore+=*.o,*.obj,*/.git/*,*.pyc,*.pdf,*.ps,*.png,*.jpg,
            \*.aux,*.log,*.blg,*.fls,*.blg,*.fdb_latexmk,*.latexmain,.DS_Store,
            \Session.vim,Project.vim,tags,*.hdf5
set suffixes+=,,                     " Prefer files that have an extension

" mksession options
" set sessionoptions=blank,buffers,sesdir,folds,globals,help,localoptions,options,resize,tabpages,winsize

" Backup and swapfile locations
set backupdir=~/.vim_backup
set directory=~/.vim_backup
set undodir=~/.vim/.vim_backup/undo  " where to save undo histories
set undofile                         " Save undo's after file closes

" Use an interactive shell to allow command line aliases to work
" set shellcmdflag=-ic

" Grep will sometimes skip displaying the file name if you
" search in a singe file. Set grep
" program to always generate a file-name.
set grepprg=grep\ -nH\ $*

" British spelling
set spelllang=en_gb

"  --------------------------------------
"  Personal bindings and simple functions
"  --------------------------------------

" Quick bind for saving a file
nnoremap \s :w<CR>

" Reformat paragraph
nnoremap ,l gqip
vnoremap ,l gq

" Cycle through buffers quickly
nnoremap <silent> ,x :bn<CR>
nnoremap <silent> ,z :bp<CR>

" Quick switch to directory of current file
nnoremap ,cd :lcd %:p:h<CR>:pwd<CR>
" Bring up marks list
nnoremap ,m :marks<CR>

" Leave cursor at end of yank after yanking text with lowercase y in visual mode
" (disabled) and after yanking full lines with capital Y in normal mode. (disabled)
vnoremap y y`>
" nnoremap Y Y`]

" Easy on the fingers save and window manipulation bindings
nnoremap ;' :w<CR>
nnoremap ,w <C-w>
nnoremap ,. <C-w>p

" Toggle to last active tab
let g:lasttab = 1
nnoremap ,/ :exe "tabn ".g:lasttab<CR>
au TabLeave * let g:lasttab = tabpagenr()

" Quick binding to quick switch back to alternate file 
nnoremap ,, <C-S-^>

" Disable increment number up / down - *way* too dangerous...
nmap <C-a> <Nop>
nmap <C-x> <Nop>

" ,j ,k inserts blank line below/above.
nnoremap <silent>,j :set paste<CR>m`o<Esc>``:set nopaste<CR>
nnoremap <silent>,k :set paste<CR>m`O<Esc>``:set nopaste<CR>

" Map ,h to turn off highlighting
nmap ,h <Esc>:noh<CR>

" Can use this to paste without auto indent
nnoremap <F2> :set invpaste paste?<CR>
set pastetoggle=<F2>
set showmode

" Show syntax highlighting groups for word under cursor
function! <SID>SynStack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc
nmap ,csp :call <SID>SynStack()<CR>

command! -nargs=+ MyGrep execute 'silent grep! <args> %' | copen 10
nnoremap ,g :MyGrep

" Shortcut function for removing trailing whitespace
command! TrimWhitespace execute ':%s/\s\+$//'

" Useful wrapping functions
function! WrapToggle()
    if exists("b:wrapToggleFlag") && b:wrapToggleFlag==1
        setlocal tw=0 fo=cq wm=0 colorcolumn=0
        let b:wrapToggleFlag=0
    else
        setlocal tw=80 fo=cqt wm=0 colorcolumn=80
        let b:wrapToggleFlag=1
    endif
endfun
map ,sw :call WrapToggle()<CR>

" copy and paste to temp file
" copy to buffer
set cpoptions-=A
vmap ,c :w! ~/.vimbuffer<CR>
nmap ,c :.w! ~/.vimbuffer<CR>
" paste from buffer
set cpoptions-=a
nmap ,v :r ~/.vimbuffer<CR>

" Allow us to move to windows by number using the leader key
let i = 1
while i <= 9
    execute 'nnoremap <Leader>' . i . ' :' . i . 'wincmd w<CR>'
    let i = i + 1
endwhile
function! WindowNumber()
    let str=tabpagewinnr(tabpagenr())
    return str
endfunction

" Cags command
function! GenCtags()
    let s:cmd = ' -R --fields=+iaS --extra=+q'
    if exists("g:Tlist_Ctags_Cmd")
        execute ':!'.g:Tlist_Ctags_Cmd.s:cmd
    else
        execute ':! ctags'.s:cmd
    endif
endfun


"  ------------------------------
"  Settings for various filetypes
"  ------------------------------

" Scons files
au BufNewFile,BufRead SConscript,SConstruct set filetype=scons
set makeprg=scons

" Markdown files
au BufNewFile,BufRead *.md set filetype=markdown

" Python files
let python_highlight_all = 1
let python_highlight_space_errors = 0

" Trim trailing whitespace when saving python file
autocmd BufWritePre *.py normal m`:%s/\s\+$//e``

