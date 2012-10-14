" Vim config file
set nocompatible

if filereadable(expand("~/.vimrc.before"))
  source ~/.vimrc.before
endif

" Syntastic options
let g:syntastic_mode_map = { 'mode': 'passive',
                           \ 'active_filetypes': [],
                           \ 'passive_filetypes': [] }

" Deal with gnu screen
let g:pathogen_disabled = []
if match($TERM, "screen")!=-1
    set term=xterm-256color
    call add(g:pathogen_disabled, 'vitality')
endif
if has("gui_macvim")
    call add(g:pathogen_disabled, 'vitality')
endif

" Powerline options
set encoding=utf-8
let g:Powerline_symbols = 'unicode'
let g:Powerline_colorscheme = 'solarizedDark'


"------------------
"---- Pathogen ----
"------------------
" If we called vim using quickload then only enable some bundles
runtime bundle/pathogen/autoload/pathogen.vim
filetype off
if exists('quick_load')
    call add(g:pathogen_disabled, 'fugitive')
    call add(g:pathogen_disabled, 'gist')
    call add(g:pathogen_disabled, 'pyflakes')
    call add(g:pathogen_disabled, 'ropevim')
    call add(g:pathogen_disabled, 'gundo')
    call add(g:pathogen_disabled, 'conque')
    call add(g:pathogen_disabled, 'voom')
endif
call pathogen#infect()
"------------------

" Do system specific settings
let os = substitute(system('uname'), "\n", "", "")
if os == "Darwin"
    let Tlist_Ctags_Cmd="/usr/local/bin/ctags"
    set clipboard=unnamed
end

" Use an interactive shell to allow command line aliases to work
" set shellcmdflag=-ic

if has("gui_macvim")
  " set guifont=Bitstream\ Vera\ Sans\ Mono:h12
  " set guifont=Inconsolata-dz\ for\ Powerline:h14
  set guifont=Menlo:h14
  set guioptions-=T  " remove toolbar
  " set stal=2 " turn on tabs by default
  set anti
  set linespace=3 "Increase the space between lines for better readability
  " In order for the ropevim quick keybindings to work (i.e. 'M-/')
  " we must allow MacVim to interpret the option key as Meta...
  set invmmta
  set transparency=5
else
  " Remap meta-keys to work with ropevim.
  set <M-/>=/
  imap / <M-/>
  " Set the ttymouse value to allow window resizing with mouse
  set ttymouse=xterm2
end

" -------------------
" --- Colorscheme ---
" -------------------
set background=dark
if has("gui_running")
    set background=dark
    colorscheme solarized
elseif &t_Co >= 256
    colorscheme solarized
else
    colorscheme ir_black
end
syntax on " Use syntax highlighting
" -------------------

set autoindent
set nosmartindent  " Turning this off as messes with python comment indents.
set tabstop=4
set shiftwidth=4
set showmatch
set vb t_vb=
set ruler
set incsearch

set wrap "Wrap lines
set linebreak "Wrap at breaks
set textwidth=0
set wrapmargin=0
set display=lastline
set formatoptions+=l "Dont mess with the wrapping of existing lines

set expandtab
set backspace=indent,eol,start
set cmdheight=1

" set virtualedit=onemore 	   	" allow for cursor beyond last character
set history=1000  				" Store a ton of history (default is 20)

set ignorecase					" case insensitive search
set smartcase					" case sensitive when uc present
set wildmenu					" show list instead of just completing
set gdefault                    " g flag on sed subs automatically
set hidden
set hlsearch

set wildignore+=*.o,*.obj,.git,*.pyc,*.pdf,*.ps,*.png,*.jpg,*.aux
set autoread

" Turn off annoying backups!
set nobackup
set nowb
set noswapfile

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
" Bring up tabs list
" nnoremap ,t :tabs<CR>
" Bring up buffers list
" nnoremap ,b :ls<CR>

" Leave cursor at end of yank after yanking text with lowercase y in visual mode
" (disabled) and after yanking full lines with capital Y in normal mode. (disabled)
vnoremap y y`>
" nnoremap Y Y`]

" Capital Y yank in normal mode yanks from cursor to end of line, just like
" capital D does.
nnoremap Y y$

" Easy on the fingers save binding
nnoremap ;' :w<CR>

" Another easier on the fingers binding
nmap ,w <C-w>
nmap ,. <C-w>w

" Quick binding to quick switch back to alternate file 
nmap ,, <C-S-^>

" Next and previous quickfix entries
nnoremap ,cn :cn<CR>
nnoremap ,cp :cp<CR>

" Use omnicompletion!
set ofu=syntaxcomplete#Complete
au FileType python set omnifunc=pythoncomplete#Complete

" Disable increment number up / down - *way* too dangerous...
nmap <C-a> <Nop>
nmap <C-x> <Nop>

" Trim trailing whitespace when saving python file
autocmd BufWritePre *.py normal m`:%s/\s\+$//e``

" Shortcut function for removing trailing whitespace
command! TrimWhitespace execute ':%s/\s\+$//'

" Use virtualenv for python
py << EOF
import os.path
import sys
import vim
if 'VIRTUAL_ENV' in os.environ:
    project_base_dir = os.environ['VIRTUAL_ENV']
    sys.path.insert(0, project_base_dir)
    activate_this = os.path.join(project_base_dir, 'bin/activate_this.py')
    execfile(activate_this, dict(__file__=activate_this))
EOF

" ,j ,k inserts blank line below/above.
nnoremap <silent>,j :set paste<CR>m`o<Esc>``:set nopaste<CR>
nnoremap <silent>,k :set paste<CR>m`O<Esc>``:set nopaste<CR>

" Map ,h to turn off highlighting
nmap ,h <Esc>:noh<CR>

" Repeat last : command
nnoremap ,: @:

" Let us see the current git branch we are on
" set statusline=%<%f\ %{fugitive#statusline()}\ %h%m%r%=%-14.(%l,%c%V%)\ %P
" if exists('quick_load')
"     set statusline=%<\ %n:%f\ %m%r%y%=%-35.(line:\ %l\ of\ %L,\ col:\ %c%V\ (%P)%)
" else
"     set statusline=%<\ %n:%f\ %{fugitive#statusline()}\ %m%r%y%=%-35.(line:\ %l\ of\ %L,\ col:\ %c%V\ (%P)%)
" endif
set laststatus=2

" Use f4 for the taglist
nmap <silent> ,@ :TlistToggle<CR>

" Bash like keys for the command line
inoremap <C-a>      <Home>
inoremap <C-e>      <End>
inoremap <silent> <C-k> <C-r>=<SID>KillLine()<CR>
inoremap <silent> <C-y> <C-o>:call <SID>ResetKillRing()<CR><C-r><C-o>"

" Grep will sometimes skip displaying the file name if you
" search in a singe file. Set grep
" program to always generate a file-name.
set grepprg=grep\ -nH\ $*

filetype plugin on
filetype indent on

function! <SID>KillLine()
  if col('.') > strlen(getline('.'))
      " At EOL; join with next line
      return "\<Del>"
  else
      " Not at EOL; kill until end of line
      return "\<C-o>d$"
  endif
endfunction

function! <SID>ResetKillRing()
  let s:kill_ring_position = 3
endfunction

" Can use this to paste without auto indent
nnoremap <F2> :set invpaste paste?<CR>
set pastetoggle=<F2>
set showmode

" Show syntax highlighting groups for word under cursor
nmap <C-S-P> :call <SID>SynStack()<CR>
function! <SID>SynStack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc

" Scons files
au BufNewFile,BufRead SConscript,SConstruct set filetype=scons
set makeprg=scons

" Markdown files
au BufNewFile,BufRead *.md set filetype=markdown
command! -nargs=+ MyGrep execute 'silent vimgrep <args> %' | copen 10

nnoremap ,g :MyGrep

" copy and paste to temp file
" copy to buffer
set cpoptions-=A
vmap ,c :w! ~/.vimbuffer<CR>
nmap ,c :.w! ~/.vimbuffer<CR>
" paste from buffer
set cpoptions-=a
nmap ,v :r ~/.vimbuffer<CR>

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

