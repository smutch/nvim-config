" Vim config file
runtime bundle/pathogen/autoload/pathogen.vim
set nocompatible
filetype off
let g:pathogen_disabled = []

" Remap task list key (must be done before loading plugin)
map <leader>T <Plug>TaskList

" Syntastic options
let g:syntastic_mode_map = { 'mode': 'passive',
                           \ 'active_filetypes': [],
                           \ 'passive_filetypes': [] }

" Deal with gnu screen
if match($TERM, "screen")!=-1
      set term=xterm-256color
      call add(g:pathogen_disabled, 'vitality')
endif

"------------------
"---- Pathogen ----
"------------------
" If we called vim using quickload then only enable some bundles
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
    let Tlist_Ctags_Cmd="/opt/local/bin/ctags"
    set clipboard=unnamed
end

" Use an interactive shell to allow command line aliases to work
" set shellcmdflag=-ic

if has("gui_macvim")
  " set guifont=Bitstream\ Vera\ Sans\ Mono:h12
  set guifont=Inconsolata:h16
  set guioptions-=T  " remove toolbar
  set stal=2 " turn on tabs by default
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
set smartindent
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

set wildignore+=*.o,*.obj,.git,*.pyc,*.pdf,*.ps,*.png,*.jpg,*.aux
set autoread

" Quick bind for saving a file
nnoremap \s :w<CR>

" Cycle through buffers quickly
" Buffers - next/previous: F12, Shift-F12.
nnoremap <silent> <F12> :bn<CR>
nnoremap <silent> <S-F12> :bp<CR>

" Quick switch to directory of current file
nnoremap ,cd :lcd %:p:h<CR>:pwd<CR>
" Bring up marks list
nnoremap ,m :marks<CR>
" Bring up tabs list
" nnoremap ,t :tabs<CR>
" Bring up buffers list
" nnoremap ,b :ls<CR>

" Leave cursor at end of yank after yanking text with lowercase y in visual mode
" and after yanking full lines with capital Y in normal mode.
vnoremap y y`>
nnoremap Y Y`]

" Use omnicompletion!
set ofu=syntaxcomplete#Complete
au FileType python set omnifunc=pythoncomplete#Complete

" Pydoc
if has("gui_macvim")
    let g:pydoc_cmd = "/opt/local/bin/pydoc"
elseif has("mac")
    let g:pydoc_cmd = "/opt/local/bin/pydoc"
elseif has("unix")
    let g:pydoc_cmd = "/usr/local/python-2.7.1/bin/pydoc"
endif

" " Set cwd to that of current file
" if exists('+autochdir')
"     set autochdir
" else
"     autocmd BufEnter * silent! lcd %:p:h:gs/ /\\ /
" endif

" Let NERDTree ignore certain filetypes
let NERDTreeIgnore=['\.o$', '\~$', '^_', '\.tmproj$', '^\..*']
let NERDTreeQuitOnOpen=1
let NERDTreeShowHidden=1

" " MiniBufExplorer options
" let g:miniBufExplMapCTabSwitchBufs = 1
" let g:miniBufExplUseSingleClick = 1
let g:miniBufExplorerMoreThanOne=100

" Set the list of tags to search for in tasklist
let g:tlTokenList = ['FIXME', 'TODO', 'CHANGED', 'DEBUG', 'TEMPORARY']

" Highlight warning comments
highlight Warning guibg=red ctermbg=red guifg=white ctermfg=white
autocmd BufEnter * match Warning /WARNING/

" Highlight continue here comments
highlight ContHere guibg=purple ctermbg=164 guifg=white ctermfg=white
autocmd BufEnter * 2match ContHere /CONT HERE/

" Highlight lines
highlight LineHighlight guibg=green ctermbg=green guifg=white ctermfg=white
autocmd BufEnter * 3match LineHighlight /\!\$\$\_.\{-}\$\$\!/

" Set showmarks bundle to off by default
let g:showmarks_enable = 0

" Make gists private by default
let g:gist_show_privates = 1

" Turn off annoying backups!
set nobackup
set nowb
set noswapfile

set hlsearch

" Python syntax highlighting
let python_highlight_all = 1
let python_highlight_space_errors = 0

" Pyflakes options
let g:pyflakes_autostart = 1
let g:pyflakes_use_quickfix = 0

" Trim trailing whitespace when saving python file
autocmd BufWritePre *.py normal m`:%s/\s\+$//e``

" Shortcut function for removing trailing whitespace
command! TrimWhitespace execute ':%s/\s\+$//'

" Use my virtualenv for python
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

" Supertab options
let g:SuperTabDefaultCompletionType = "context"
" au FileType Python let g:SuperTabContextDefaultCompletionType = "<c-x><c-o>"

" Rope settings
let ropevim_vim_completion = 1
let ropevim_enable_shortcuts = 1
let ropevim_enable_autoimport = 1
let ropevim_goto_def_newwin = 1
let ropevim_extended_complete = 1

" ConqueTerm settings
augroup MyConqueTerm
  autocmd!
  " start Insert mode on BufEnter
  autocmd BufEnter *
        \ if &l:filetype ==# 'conque_term' |
        \   startinsert! |
        \ endif
  autocmd BufLeave *
        \ if &l:filetype ==# 'conque_term' |
        \   stopinsert! |
        \ endif
augroup END

let g:ConqueTerm_Color         = 1
let g:ConqueTerm_TERM          = 'xterm-256color'
let g:ConqueTerm_Syntax        = 'conque'
let g:ConqueTerm_ReadUnfocused = 1
let g:ConqueTerm_CWInsert      = 1

nnoremap <silent><leader>C <Esc>:ConqueTermSplit zsh<CR><Esc>:set wfh<CR>i


" Alt-j/k deletes blank line below/above, and Crtl-j/k inserts.
" nnoremap <silent><A-j> m`:silent +g/\m^\s*$/d<CR>``:noh<CR>
" nnoremap <silent><A-k> m`:silent -g/\m^\s*$/d<CR>``:noh<CR>
nnoremap <silent><C-j> :set paste<CR>m`o<Esc>``:set nopaste<CR>
nnoremap <silent><C-k> :set paste<CR>m`O<Esc>``:set nopaste<CR>

" Ctrl-j/k/h/l selects windows
" nnoremap <silent><C-j> <Esc><C-w>j
" nnoremap <silent><C-k> <Esc><C-w>k
" nnoremap <silent><C-h> <Esc><C-w>h
" nnoremap <silent><C-l> <Esc><C-w>l

" Tlist options
let Tlist_Auto_Update = 1
let Tlist_Auto_Highlight_Tag = 0
let Tlist_Display_Prototype = 1
let Tlist_GainFocus_On_ToggleOpen = 1
let Tlist_File_Fold_Auto_Close = 1

" Map <leader>h to turn off highlighting
nmap <leader>h <Esc>:noh<CR>

" Map keys for Ack
nmap <leader>A <Esc>:Ack!
" Ack for current word under cursor
nmap <leader>w yiw<Esc>:Ack! <C-r>"<CR>

" Map keys for rainbow_parenthesis
nmap ,r <Esc>:RainbowParenthesesToggle<CR>

" Map keys for Gundo
map <leader>g :GundoToggle<CR>

" Map keys for command-T
nnoremap <silent> ,t :CommandT<CR>
nnoremap <silent> ,b :CommandTBuffer<CR>

" Repeat last : command
nnoremap ;; @:

" Let us see the current git branch we are on
" set statusline=%<%f\ %{fugitive#statusline()}\ %h%m%r%=%-14.(%l,%c%V%)\ %P
if exists('quick_load')
    set statusline=%<\ %n:%f\ %m%r%y%=%-35.(line:\ %l\ of\ %L,\ col:\ %c%V\ (%P)%)
else
    set statusline=%<\ %n:%f\ %{fugitive#statusline()}\ %m%r%y%=%-35.(line:\ %l\ of\ %L,\ col:\ %c%V\ (%P)%)
endif
set laststatus=2

" Useful shortcut for git commands
nnoremap git :Git
nnoremap gca :Gcommit -a<CR>
nnoremap gst :Gstatus<CR>

" Use f5 or TextMate equivalent to open NERDTree
nmap <silent> <F5> :NERDTreeToggle<CR>
nmap <silent> <leader>n :NERDTreeToggle<CR>
let NERDTreeHijackNetrw = 1

" Use f4 for the taglist
nmap <silent> <F4> :TlistToggle<CR>

" Vimux bindings
ruby << EOF
class Object
  def flush; end unless Object.new.respond_to?(:flush)
  end
EOF
let VimuxHeight = "20"
let VimuxOrientation = "v"
map <Leader>rp :PromptVimTmuxCommand<CR>
map <Leader>rl :RunLastVimTmuxCommand<CR>
map <Leader>ri :InspectVimTmuxRunner<CR>
map <Leader>rx :CloseVimTmuxPanes<CR>
map <Leader>rs :InterruptVimTmuxRunner<CR>

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

" Latex options
let g:tex_flavor='latex'
let g:LatexBox_Folding=0
let g:LatexBox_viewer = "open -a Skim"
" map <silent> <Leader>ls :silent !/Applications/Skim.app/Contents/SharedSupport/displayline
"         \ <C-R>=line('.')<CR> "<C-R>=LatexBox_GetOutputFile()<CR>" "%:p" <CR>

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

" NERDCommenter
let NERDSpaceDelims=1
map <leader><leader> <plug>NERDCommenterToggle
let NERD_c_alt_style=1 " This doesn't seem to do anything but it should!?!

" Scons files
au BufNewFile,BufRead SConscript,SConstruct set filetype=scons
set makeprg=scons

" Markdown files
nnoremap <leader>m :silent !open -a Marked.app '%:p'<cr>
au BufRead,BufNewFile *.md set filetype=markdown
command! -nargs=+ MyGrep execute 'silent vimgrep <args> %' | copen 10
autocmd FileType markdown let b:surround_109 = "\\\\(\r\\\\)"
autocmd FileType markdown let b:surround_115 = "~~\r~~"
nnoremap ,m :MyGrep

" " Reset some keybindings
" noremap <script> <silent> \be :BufExplorer<CR>
" noremap <script> <silent> \bs :BufExplorerHorizontalSplit<CR>
" noremap <script> <silent> \bv :BufExplorerVerticalSplit<CR>

" Move lines up or down (doesn't work in ssh terminal)
nnoremap <M-j> :m+<CR>==
nnoremap <M-k> :m-2<CR>==
inoremap <M-j> <Esc>:m+<CR>==gi
inoremap <M-k> <Esc>:m-2<CR>==gi
vnoremap <M-j> :m'>+<CR>gv=gv
vnoremap <M-k> :m-2<CR>gv=gv

" copy and paste to temp file
" copy to buffer
set cpoptions-=A
vmap <C-x> :w! ~/.vimbuffer<CR>
nmap <C-x> :.w! ~/.vimbuffer<CR>
" paste from buffer
set cpoptions-=a
nmap <C-i> :r ~/.vimbuffer<CR>

" mapping to make movements operate on 1 screen line in wrap mode
function! ScreenMovement(movement)
  if !exists("b:gmove")
    let b:gmove = "yes"
  endif
  if &wrap && b:gmove == 'yes'
    return "g" . a:movement
  else
    return a:movement
  endif
endfunction
nnoremap <silent> <expr> k ScreenMovement("k")
nnoremap <silent> <expr> j ScreenMovement("j")
inoremap <buffer> <Up> <C-O>gk
inoremap <buffer> <Down> <C-O>gj
function! TYShowBreak()
  if &showbreak == ''
    set showbreak=>
  else
    set showbreak=
  endif
endfunction
let b:gmove = "yes"
function! TYToggleBreakMove()
  if exists("b:gmove") && b:gmove == "yes"
    let b:gmove = "no"
    inoremap <buffer> <Up> <Up>
    inoremap <buffer> <Down> <Down>
  else
    let b:gmove = "yes"
    inoremap <buffer> <Up> <C-O>gk
    inoremap <buffer> <Down> <C-O>gj
  endif
endfunction

" Ranger function
function! Ranger()
  if $VIRTUAL_ENV!=""
    silent !$VIRTUAL_ENV/bin/python $VIRTUAL_ENV/bin/ranger --choosefile=/tmp/chosen
  else
    silent !ranger --choosefile=/tmp/chosen
  endif
  if filereadable('/tmp/chosen')
    exec 'edit ' . system('cat /tmp/chosen')
    call system('rm /tmp/chosen')
  endif
  redraw!
endfun
map <leader>r :call Ranger()<CR>

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
map ,w :call WrapToggle()<CR>

