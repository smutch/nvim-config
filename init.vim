" vim:fdm=marker

" Initialisation {{{

" If we have true color support available
if exists('&termguicolors')
    set termguicolors
endif

" We don't want to mimic vi
set nocompatible

" Set the encoding
set encoding=utf-8

" Use virtualenv for python
" py << EOF
" import os.path
" import sys
" import vim
" if 'VIRTUAL_ENV' in os.environ:
"     project_base_dir = os.environ['VIRTUAL_ENV']
"     sys.path.insert(0, project_base_dir)
"     activate_this = os.path.join(project_base_dir, 'bin/activate_this.py')
"     execfile(activate_this, dict(__file__=activate_this))
" EOF

" Deal with gnu screen
if (match($TERM, "screen")!=-1) && !exists('&termguicolors')
    set term=screen-256color
endif

" }}}
" System specific {{{

" Do system specific settings
let os = substitute(system('uname'), "\n", "", "")
if os == "Darwin"
    let Tlist_Ctags_Cmd="/usr/local/bin/ctags"
    let cscope_cmd="/usr/local/bin/cscope"
    " set tags+=$HOME/.vim/ctags-system-mac
    " let g:python3_host_prog = '/usr/local/Caskroom/miniconda/base/envs/nvim/bin/python'
    let g:cmake_opts = '-DHDF5_ROOT=/usr/local -DMPI_C_COMPILER=/usr/local/bin/mpicc'
else
    let g:cmake_opts = ''
    let cscope_cmd="/usr/bin/cscope"
end

" What machine are we on?
let hostname = substitute(system('hostname'), '\n', '', '')

" if (hostname =~ "sstar") || (hostname =~ "gstar")
    " set shell=/home/smutch/.vim/g2shell.sh
    " let &shellpipe="|& tee"
    " set t_ut=
" endif
if (hostname =~ "farnarkle") || (hostname =~ "ozstar")
    let $PATH = '/fred/oz013/smutch/conda_envs/nvim/bin' . $PATH
    let g:coc_node_path = '/fred/oz013/smutch/conda_envs/nvim/bin/node'
elseif (hostname =~ "Rabbie")
    set shell=/usr/local/bin/zsh
endif

" GUI settings {{{
if exists('g:vv')
  VVset fontfamily=Hack
endif
" }}}

" }}}
" vim-plug {{{

" Load all plugins
call plug#begin('~/.config/nvim/plugged')

if !empty(glob("~/code/note-system"))
    Plug '~/code/note-system'
endif

" completion {{{
Plug 'neoclide/coc.nvim', {'branch': 'release'}
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
" Plug 'ncm2/float-preview.nvim'
Plug 'chrisbra/vim-diff-enhanced'
Plug 'moll/vim-bbye'
Plug 'tpope/vim-vinegar'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' } | Plug 'junegunn/fzf.vim'
" Plug 'ludovicchabant/vim-gutentags'
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
Plug 'rhysd/git-messenger.vim'
" }}}

" linting {{{
" Plug 'w0rp/ale'
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
Plug 'sonph/onehalf', {'rtp': 'vim/'}
Plug 'drewtempelmeyer/palenight.vim'
Plug 'arcticicestudio/nord-vim'
Plug 'cormacrelf/vim-colors-github'
Plug 'mhartington/oceanic-next'
Plug 'rakr/vim-two-firewatch'
Plug 'dracula/vim'
Plug 'ayu-theme/ayu-vim'
" }}}

" filetypes {{{
" python {{{
Plug 'vim-python/python-syntax', { 'for': 'python' }
Plug 'Vimjas/vim-python-pep8-indent', { 'for': 'python'}
" Plug 'davidhalter/jedi-vim', { 'for': 'python' }
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
Plug 'Glench/Vim-Jinja2-Syntax', { 'for': 'html' }
" Plug 'sheerun/vim-polyglot'
Plug 'mattn/emmet-vim', { 'for': ['html', 'css', 'sass', 'jinja.html'] }
" Plug 'vim-pandoc/vim-pandoc-syntax'
" }}}
" }}}

call plug#end()

filetype plugin on
filetype indent on

" }}}
" Basic settings {{{
let mapleader="\<Space>"
let localleader='\'

set history=1000                     " Store a ton of history (default is 20)
set wildmenu                         " show list instead of just completing
set autoread                         " Automatically re-read changed files
set hidden                           " Don't unload a buffer when abandoning it
set mouse=a                          " enable mouse for all modes settings
set clipboard=unnamed                " To work in tmux
set spelllang=en_gb                  " British spelling
set noshowmode                         " Don't show the current mode
" set list                             " Show trailing & tab markers
" set showcmd                          " Show partial command in bottom right

set secure                           " Secure mode for reading vimrc, exrc files etc. in current dir
set exrc                             " Allow the use of folder dependent settings

let g:netrw_altfile = 1              " Prev buffer command excludes netrw buffers

" Use an interactive shell to allow command line aliases to work
" set shellcmdflag=-ic

" I tend to write c rather than c++
let g:c_syntax_for_h = 1

" Indent and wrapping {{{

set backspace=indent,eol,start       " Sane backspace
set autoindent                       " Autoindent
set nosmartindent                    " Turning this off as messes with python comment indents.
set wrap                             " Wrap lines
set linebreak                        " Wrap at breaks
set textwidth=0 wrapmargin=0
set display=lastline
set formatoptions+=l                 " Dont mess with the wrapping of existing lines
set expandtab tabstop=4 shiftwidth=4 " 4 spaces for tabs

" }}}
" Searching {{{
set incsearch                        " Highlight matches as you type
set hlsearch                         " Highlight matches
set showmatch                        " Show matching paren
set ignorecase                       " case insensitive search
set smartcase                        " case sensitive when uc present
set gdefault                         " g flag on sed subs automatically
" set tags+=./tags;$HOME                " recursively search up dir stack for tags file

" Live substitution
if exists('&inccommand')
  set inccommand=nosplit
endif

" Use ripgrep if possible, if not then ack, and fall back to grep if all else fails
if executable('rg')
    set grepprg=set grepprg=rg\ --vimgrep\ --no-heading\ --smart-case\ --trim
elseif executable('ack')
    set grepprg=ack\ -s\ -H\ --nocolor\ --nogroup\ --column
    set grepformat=%f:%l:%c:%m,%f:%l:%m
else
    " Grep will sometimes skip displaying the file name if you
    " search in a singe file. Set grep
    " program to always generate a file-name.
    set grepprg=grep\ -nHRI\ $*\ .
endif
nnoremap <leader>* :silent grep! "<C-r><C-w>"<CR>:copen<CR>:redraw!<CR>
command! -nargs=+ -complete=file -bar Grep silent grep! <args>|copen|redraw!
nnoremap <leader>/ :Grep 

" Load up last search in buffer into the location list and open it
nnoremap <leader>l :<C-u>lvim // % \| lopen<CR>

set wildignore+=*.o,*.obj,*.pyc,
            \*.aux,*.blg,*.fls,*.blg,*.fdb_latexmk,*.latexmain,.DS_Store,
            \Session.vim,Project.vim,tags,.tags,.sconsign.dblite,.ccls-cache

" Set suffixes that are ignored with multiple match
set suffixes=.bak,~,.o,.info,.swp,.obj

" cscope
if has("cscope")
    let &csprg = cscope_cmd
    set csto=0
    " set cst
    set nocsverb
    " add any database in current directory
    if filereadable("cscope.out")
        cs add cscope.out
    " else add database pointed to by environment
    elseif $CSCOPE_DB != ""
        cs add $CSCOPE_DB
    endif
    set csverb

    " put the cscope output in the quickfix window
    set cscopequickfix=s-,c-,d-,i-,t-,e-

    " map g<C-]> :cs find 3 <C-R>=expand("<cword>")<CR><CR>
    " map g<C-\> :cs find 0 <C-R>=expand("<cword>")<CR><CR>
    " map g<C-/> :cs find s <C-R>=expand("<cword>")<CR><CR>
endif

" handy mapping to fold around previous search results
" taken from http://vim.wikia.com/wiki/Folding_with_Regular_Expression
" \z to show previous search results
" zr to display more context
" zm to display less
function! s:SearchFold()
    if (!exists('b:searchfold_on') || b:searchfold_on==0)
        let b:old_foldexpr = &l:foldexpr
        let b:old_fdm = &l:fdm
        let b:old_foldlevel = &l:foldlevel
        let b:old_foldcolumn = &l:foldcolumn
        setlocal foldexpr=(getline(v:lnum)=~@/)?0:(getline(v:lnum-1)=~@/)\\|\\|(getline(v:lnum+1)=~@/)?1:2 foldmethod=expr foldlevel=0 foldcolumn=2
        let b:searchfold_on = 1
    else
        let &l:foldexpr = b:old_foldexpr
        let &l:foldmethod = b:old_fdm
        let &l:foldlevel = b:old_foldlevel
        let &l:foldcolumn = b:old_foldcolumn
        let b:searchfold_on = 0
    endif
endfunction
command! SearchFold call s:SearchFold()
nnoremap <localleader>z :SearchFold<CR>



" }}}
" Backup and swap files {{{
set backupdir=~/.vim_backup
set directory=~/.vim_backup
set undodir=~/.vim/.vim_backup/undo  " where to save undo histories
set undofile                         " Save undo's after file closes
" }}}

" }}}
" Visual settings {{{

set vb t_vb=                            " Turn off visual beep
set laststatus=2                        " Always display a status line
set cmdheight=1                         " Command line height
set listchars=tab:▸\ ,eol:↵,trail:·     " Set hidden characters
set number                              " Show line numbers
" set cursorline                          " highlight current line

if has("nvim") && exists("+pumblend")
    set pumblend=20                     " opacity for popupmenu
endif

" Colorscheme {{{

function! ReturnHighlightTerm(group, term)
    " taken from https://vi.stackexchange.com/a/12294
    " Store output of group to variable
    let output = execute('hi ' . a:group)

    " Find the term we're looking for
    return matchstr(output, a:term.'=\zs\S*')
endfunction

augroup CustomColors
    au!
    au ColorScheme hybrid if &background == 'dark' |
                \ hi! Normal guifg=#d9dbda |
                \ hi! TermNormal guibg=#1d1f21 |
                \ endif "|
                " \ hi! Normal guibg=NONE | 
                " \ hi! link pythonInclude Include
    au ColorScheme Tomorrow if &background == 'light' |
                \ hi! link Folded ColorColumn |
                \ endif
                " \ hi! Normal guibg=NONE | 
    au ColorScheme one if &background == 'light' |
                \ hi! Normal guibg=white |
                \ endif
    au ColorScheme one if &background == 'dark' |
                \ hi! Normal guifg=#cccccc |
                \ nnoremap <leader>cd :hi Normal guibg=<C-R>=(ReturnHighlightTerm('Normal', 'guibg') =~# "#282c34") ? '#1a1d23' : '#282c34'<CR><CR> |
                \ endif
    " au colorscheme one if &background == 'light' |
                " \ hi! normal guibg=#ffffff |
                " \ endif
                " \ hi! normal guibg=none | 
    au ColorScheme seagull,greygull
                \ hi! NonText ctermfg=7 guifg=#e6eaed
    au ColorScheme * hi! link Search DiffAdd |
                \ hi! link Conceal NonText
augroup END

" Properly switch colors {{{
" Taken from: https://github.com/altercation/solarized/issues/102#issuecomment-275269574

if !exists('s:known_links')
  let s:known_links = {}
endif

function! s:Find_links()
  " Find and remember links between highlighting groups.
  redir => listing
  try
    silent highlight
  finally
    redir END
  endtry
  for line in split(listing, "\n")
    let tokens = split(line)
    " We're looking for lines like "String xxx links to Constant" in the
    " output of the :highlight command.
    if len(tokens) == 5 && tokens[1] == 'xxx' && tokens[2] == 'links' && tokens[3] == 'to'
      let fromgroup = tokens[0]
      let togroup = tokens[4]
      let s:known_links[fromgroup] = togroup
    endif
  endfor
endfunction

function! s:Restore_links()
  " Restore broken links between highlighting groups.
  redir => listing
  try
    silent highlight
  finally
    redir END
  endtry
  let num_restored = 0
  for line in split(listing, "\n")
    let tokens = split(line)
    " We're looking for lines like "String xxx cleared" in the
    " output of the :highlight command.
    if len(tokens) == 3 && tokens[1] == 'xxx' && tokens[2] == 'cleared'
      let fromgroup = tokens[0]
      let togroup = get(s:known_links, fromgroup, '')
      if !empty(togroup)
        execute 'hi link' fromgroup togroup
        let num_restored += 1
      endif
    endif
  endfor
endfunction

function! s:AccurateColorscheme(colo_name)
  call <SID>Find_links()
  exec "colorscheme " a:colo_name
  call <SID>Restore_links()
endfunction

command! -nargs=1 -complete=color Cs call <SID>AccurateColorscheme(<q-args>)
" }}}

syntax on " Use syntax highlighting
function! SetTheme()
    " Setting this will turn off the guibg color
	" let g:hybrid_custom_term_colors = 1
    
    let g:hybrid_reduced_contrast = 1
    let g:seoul256_light_background = 255
    if (&t_Co >= 256)
        if (exists('g:light') && g:light==1) || (exists('$LIGHT') && $LIGHT==1)
            set background=light
            Cs one
            let g:airline_theme='one'
            let g:light=1
        else
            set background=dark
            Cs hybrid
            let g:airline_theme="hybrid"
            " Cs one
            " let g:airline_theme="one"

            let g:light=0
        endif
    end
endfunction

let g:gruvbox_contrast_dark='medium'
let g:gruvbox_contrast_light='hard'

command! ToggleTheme let g:light=!g:light | call SetTheme() | AirlineRefresh
nnoremap cot :<C-u>ToggleTheme<CR> 

" use the presence of a file to determine if we want to start in light or dark mode
if !empty(glob(expand("~") . "/.vimlight"))
    let g:light=1
else
    let g:light=0
endif
call SetTheme()

" Neovim terminal colors
if has("nvim")
    let g:terminal_color_0 = "#252525"
    let g:terminal_color_1 = "#d06c76"
    let g:terminal_color_2 = "#99c27c"
    let g:terminal_color_3 = "#FFD740"
    let g:terminal_color_4 = "#40C4FF"
    let g:terminal_color_5 = "#FF4081"
    let g:terminal_color_6 = "#59b3be"
    let g:terminal_color_7 = "#F5F5F5"
    let g:terminal_color_8 = "#708284"
    let g:terminal_color_9 = "#d06c76"
    let g:terminal_color_10 = "#99c27c"
    let g:terminal_color_11 = "#FFD740"
    let g:terminal_color_12 = "#40C4FF"
    let g:terminal_color_13 = "#FF4081"
    let g:terminal_color_14 = "#59b3be"
    let g:terminal_color_15 = "#F5F5F5"
endif

" }}}

" Cursor configuration {{{
" ====================================================================
if has("nvim")
    " set guicursor=n-v-c:block-Cursor/lCursor-blinkon0,i-ci:ver25-Cursor/lCursor,r-cr:hor20-Cursor/lCursor
else
    let &t_SI = "\<Esc>[5 q"
    if exists("&t_SR")
        let &t_SR = "\<Esc>[3 q"
    endif
    let &t_EI = "\<Esc>[2 q"
endif
" }}}

" }}}
" Highlighting {{{

highlight link CheckWords DiffText

function! MatchCheckWords()
  match CheckWords /\c\<\(your\|Your\|it's\|they're\|halos\|Halos\|reionisation\|Reionisation\)\>/
endfunction

" autocmd FileType markdown,tex,rst call MatchCheckWords()
" autocmd BufWinEnter *.md,*.tex,*.rst call MatchCheckWords()
" autocmd BufWinLeave *.md,*.tex,*.rst call clearmatches()

" }}}
" Custom commands and functions {{{

" Edit remote files locally
command! -nargs=1 G2 execute ':e scp://g2/<args>'
command! -nargs=1 F1 execute ':e scp://f1/<args>'

" Yank and paste lines to a temp file
function! YankToTemp() range
    let s:save_cpoptions = &cpoptions
    set cpoptions-=A
    '<,'>write! ~/.vimbuffer
    let &cpoptions = s:save_cpoptions
    execute "silent !cat ~/.vimbuffer | ssh -p 4325 localhost pbcopy"
    redraw!
endfunction

function! PasteFromTemp()
    let s:save_cpoptions = &cpoptions
    set cpoptions-=a
    read ~/.vimbuffer
    let &cpoptions = s:save_cpoptions
endfunction

vmap <leader>Y :<C-u>call YankToTemp()<CR>
nmap <leader>Y V:<C-u>call YankToTemp()<CR>
nmap <leader>P :<C-u>call PasteFromTemp()<CR>

" Show syntax highlighting groups for word under cursor
function! <SID>SynStack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc
command! SynStack call <SID>SynStack()

" Remove trailing whitespace
command! TrimWhitespace execute ':%s/\s\+$// | :noh'

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

" Allow <CR> to be prefixed by a window number to use for the jump
function! QFOpenInWindow()
    if v:count is 0
        .cc
    else
        let s:linenumber = line('.')
        exec v:count . 'wincmd w'
        exec ':' . s:linenumber . 'cc'
    endif
endfunction
autocmd FileType quickfix,qf nnoremap <buffer> e :<C-u>call QFOpenInWindow()<CR>

" CMake
function! s:CMake()
    let src_dir = fnamemodify(findfile('CMakeLists.txt', '.;'), ':p:h')
    let build_dir = finddir('build', '.;')

    if build_dir =~ ""
        let build_dir = src_dir . '/build'
        echo build_dir
        call system('mkdir -p ' . build_dir)
    endif
    let &makeprg = 'make -j2 -C ' . build_dir

    exec 'Dispatch -dir=' . build_dir . ' cmake .. ' . g:cmake_opts
endfunction
command! CMake call <SID>CMake()

" Ctags command
function! GenCtags()
    let s:cmd = ' -R --fields=+iaS --extra=+q'
    if exists("g:Tlist_Ctags_Cmd")
        execute ':!'.g:Tlist_Ctags_Cmd.s:cmd
    else
        execute ':! ctags'.s:cmd
    endif
endfun

" Softwrap
command! SoftWrap execute ':g/./,-/\n$/j'

" Edit vimrc
command! Erc execute ':e ~/.config/nvim/init.vim'

" Capture output from a vim command (like :version or :messages) into a split
" scratch buffer. (credit: ctechols,
" https://gist.github.com/ctechols/c6f7c900b09be5a31dc8)
" Examples:
":Page version
":Page messages
":Page ls
"It also works with the :!cmd command and Ex special characters like % (cmdline-special)
":Page !wc %
"Capture and return the long output of a verbose command.
function! s:Redir(cmd)
   let output = ""
   redir =>> output
   silent exe a:cmd
   redir END
   return output
endfunction

"A command to open a scratch buffer.
function! s:Scratch()
   split Scratch
   setlocal buftype=nofile
   setlocal bufhidden=wipe
   setlocal noswapfile
   setlocal nobuflisted
   return bufnr("%")
endfunction

"Put the output of a command into a scratch buffer.
function! s:Page(command)
   let output = s:Redir(a:command)
   call s:Scratch()
   normal gg
   call append(1, split(output, "\n"))
endfunction

command! -nargs=+ -complete=command Page :call <SID>Page(<q-args>)

" quickly edit recorded macros
nnoremap <leader>m :<c-u><c-r><c-r>='let @'. v:register .' = '. string(getreg(v:register))<cr><c-f><left>

" make something like <c-l> that does more than just redraw the screen
nnoremap <leader>L :nohlsearch<cr>:diffupdate<cr>:syntax sync fromstart<cr><c-l>

" scrach buffers (taken from
" <http://dhruvasagar.com/2014/03/11/creating-custom-scratch-buffers-in-vim>)
function! ScratchEdit(cmd, options)
    exe a:cmd tempname()
    setl buftype=nofile bufhidden=wipe nobuflisted
    if !empty(a:options) | exe 'setl' a:options | endif
endfunction
command! -bar -nargs=* Sedit call ScratchEdit('edit', <q-args>)
command! -bar -nargs=* Ssplit call ScratchEdit('split', <q-args>)
command! -bar -nargs=* Svsplit call ScratchEdit('vsplit', <q-args>)
command! -bar -nargs=* Stabedit call ScratchEdit('tabe', <q-args>)

" store the current directory into register d
command! GrabPWD let @d = system("pwd")

" battery saving
function! s:SaveBattery()
    " let g:ncm2#auto_popup = 0

    let g:ale_lint_on_text_changed = 0
    let g:ale_lint_on_enter = 0
    let g:ale_lint_on_save = 0
    let g:ale_lint_on_filetype_changed = 0
    let g:ale_lint_on_insert_leave = 0
endfunction
command! SaveBattery :call <SID>SaveBattery()

function! s:DrainBattery()
    " let g:ncm2#auto_popup = 1

    let g:ale_lint_on_text_changed = 'normal'
    let g:ale_lint_on_enter = 1
    let g:ale_lint_on_save = 1
    let g:ale_lint_on_filetype_changed = 1
    let g:ale_lint_on_insert_leave = 1
endfunction
command! DrainBattery :call <SID>DrainBattery()

" }}}
" Keybindings {{{

imap <C-@> <C-Space>

" Quick escape from insert mode
inoremap kj <ESC>

" Cycle through buffers quickly
nnoremap <silent> gbn :bn<CR>
nnoremap <silent> gbp :bp<CR>

" Quick switch to directory of current file
nnoremap gcd :lcd %:p:h<CR>:pwd<CR>

" Quickly create a file in the directory of the current buffer
nmap <leader>e :<C-u>e <C-R>=expand("%:p:h") . "/" <CR>

" Leave cursor at end of yank after yanking text with lowercase y in visual 
" mode
vnoremap y y`>

" Make Y behave like other capital
nnoremap Y y$

" Easy on the fingers save and window manipulation bindings
nnoremap <leader>s :w<CR>
nnoremap <leader>w <C-w>

" Fit window height to contents and fix
command! SqueezeWindow execute('resize ' . line('$') . ' | set wfh')

" Toggle to last active tab
let g:lasttab = 1
nnoremap <CR>t :exe "tabn ".g:lasttab<CR>
au TabLeave * let g:lasttab = tabpagenr()

" Switch back to alternate file
nnoremap <CR><CR> <C-S-^>

" Disable increment number up / down - *way* too dangerous...
nmap <C-a> <Nop>
nmap <C-x> <Nop>

" Turn off highlighting
" nmap ,h <Esc>:noh<CR>
" nmap <backspace> <Esc>:noh<CR>
noremap \| <Esc>:<C-u>noh<CR>

" Paste without auto indent
nnoremap <F2> :set invpaste paste?<CR>
set pastetoggle=<F2>

" Toggle auto paragraph formatting
nnoremap coa :set <C-R>=(&formatoptions =~# "aw") ? 'formatoptions-=aw' : 'formatoptions+=aw'<CR><CR>

" Reformat chunks (chunks are defined per filetype basis in after/ftplugin)
" nmap ,; gwic
" nmap ,: gwac

" Neovim terminal mappings and settings
if has('nvim')
    let $LAUNCHED_FROM_NVIM = 1
    augroup MyTerm
        au!
        au BufWinEnter,WinEnter,TermOpen term://* startinsert 
        au TermOpen * setlocal winhighlight=Normal:TermNormal |
                    \ setlocal nocursorline nonumber norelativenumber
    augroup END

    if !exists('s:my_terminal_buffer')
        let s:my_terminal_buffer = -1
    endif
    if !exists('s:my_terminal_window')
        let s:my_terminal_window = -1
    endif
    if !exists('s:my_terminal_command')
        let s:my_terminal_command = &shell
    endif

    function! s:my_terminal_maps(floating)
        if a:floating
            tmap <buffer> <C-h> <C-\><C-n>:Tc!<CR>
            tmap <buffer> <C-j> <C-\><C-n>:Tc!<CR>
            tmap <buffer> <C-k> <C-\><C-n>:Tc!<CR>
            tmap <buffer> <C-l> <C-\><C-n>:Tc!<CR>
        else
            tmap <buffer> <C-h> <C-\><C-n><C-w>h
            tmap <buffer> <C-j> <C-\><C-n><C-w>j
            tmap <buffer> <C-k> <C-\><C-n><C-w>k
            tmap <buffer> <C-l> <C-\><C-n><C-w>l
        endif
    endfunction

    function! s:term_create(cmd, mods, bang)
        " If we are in our terminal then close it
        if bufnr('%') == s:my_terminal_buffer
            wincmd q
            redraw!
            return
        endif

        " get the desired position if we want a floating window
        let floating_opts = {
                    \ 'relative': 'editor',
                    \ 'width': &columns/4 * 3,
                    \ 'height': &lines/4 * 3,
                    \ 'col': &columns/8,
                    \ 'row': &lines/8,
                    \ 'anchor': 'NW',
                    \ 'style': 'minimal'
                    \ }

        if !bufexists(s:my_terminal_buffer)
            " our terminal buffer doesn't exist

            if a:bang
                " here we want a floating window
                let bufnr = nvim_create_buf(v:false, v:true)
                call nvim_open_win(bufnr, 1, floating_opts)

                " lots of options to set to make it like a terminal window
                setlocal winblend=20
                setlocal foldcolumn=1
                setlocal bufhidden=hide
                setlocal signcolumn=no
                setlocal nobuflisted
                setlocal nocursorline
                setlocal nonumber
                setlocal norelativenumber

                " spin up the terminal in the floating window, optionally with a command
                exe 'terminal ' . a:cmd

                call s:my_terminal_maps(1)
                
            else
                " here we want a standard split
                exe a:mods . ' split'
                exe 'terminal ' . a:cmd

                call s:my_terminal_maps(0)
            endif

            " always want to enter into insert mode
            startinsert

            " store the buffer, window and command info
            let s:my_terminal_command = a:cmd
            let s:my_terminal_window = win_getid()
            let s:my_terminal_buffer = bufnr('%')
        else
            " our terminal buffer already exists
            if !win_gotoid(s:my_terminal_window)
                " we can successfully change to our terminal window
                if a:bang
                    " we want a floating window so create one
                    call nvim_open_win(s:my_terminal_buffer, 1, floating_opts)

                    call s:my_terminal_maps(1)
                else
                    " we want a standard split so create one
                    exe a:mods . ' split'
                    exe 'buffer ' . s:my_terminal_buffer

                    call s:my_terminal_maps(0)
                endif

                " store the, potentially new, window and buffer info
                let s:my_terminal_window = win_getid()
                let s:my_terminal_buffer = bufnr('%')

                " if we have also provided a command then run that
                if a:cmd != ''
                    let s:my_terminal_command = a:cmd
                    put =a:cmd . ''
                else
                    startinsert
                endif
            endif
        endif
    endfunction

    command! -bar -complete=shellcmd -nargs=* -bang Tc call s:term_create(<q-args>, <q-mods>, <bang>0)
    nnoremap <leader>tv :vertical Tc<CR>
    nnoremap <leader>ts :belowright Tc<CR>
    nnoremap <leader>tV :vertical Tc 
    nnoremap <leader>tS :belowright Tc 
    nnoremap <leader>tc :Tc 
    nnoremap <leader>tt :Tc!<CR>

    tnoremap kj <C-\><C-n>
    tnoremap <C-h> <C-\><C-n><C-w>h
    tnoremap <C-j> <C-\><C-n><C-w>j
    tnoremap <C-k> <C-\><C-n><C-w>k
    tnoremap <C-l> <C-\><C-n><C-w>l
    tnoremap <C-w> <C-\><C-n><C-w>
    nnoremap <A-h> <C-w>h
    nnoremap <A-j> <C-w>j
    nnoremap <A-k> <C-w>k
    nnoremap <A-l> <C-w>l
endif


" }}}
" Autocommands {{{

" Scons files
au BufNewFile,BufRead SConscript,SConstruct set filetype=scons
" set makeprg=scons

" cython files
au BufRead,BufNewFile *.pxd,*.pxi,*.pyx set filetype=cython

" slurm files
au BufRead,BufNewFile *.slurm set filetype=slurm

" Trim trailing whitespace when saving python file
autocmd BufWritePre *.py normal m`:%s/\s\+$//e``

" enable spell checking on certain files
autocmd BufNewFile,BufRead COMMIT_EDITMSG set spell |
            \ setlocal nofoldenable

" pandoc
augroup pandoc_syntax
    au! BufNewFile,BufFilePre,BufRead *.md set filetype=markdown.pandoc |
                \ setlocal cole=0
augroup END

" Automatically reload vimrc when it's saved
" augroup AutoReloadVimRC
"   au!
"   au BufWritePost $MYVIMRC so $MYVIMRC
" augroup END

" If we have a wide window then put the preview window on the right
au BufAdd * if &previewwindow && &columns >= 160 && winnr("$") == 2 | silent! wincmd L | endif

" web related languages
autocmd FileType javascript,coffee,html,css,scss,sass setlocal ts=2 sw=2

" make sure all tex files are set to correct filetype
autocmd BufNewFile,BufRead *.tex set ft=tex

" make sure pbs scripts are set to the right filetype
autocmd BufNewFile,BufRead *.{qsub,pbs} set ft=sh

" set marks to jump between header and source files
autocmd BufLeave *.{c,cpp,cc} mark C
autocmd BufLeave *.{h,hpp,hh} mark H

" When switching colorscheme in terminal vim change the profile in iTerm as well.
" from: <https://github.com/vheon/home/blob/ea91f443b33bc15d0deaa34e172a0317db63a53d/.vim/vimrc#L330-L348>
if !has('gui_running')
  function! s:change_iterm2_profile()
      if &background == 'light'
          let profile = 'Light'
      else
          let profile = 'Local'
      endif
      let escape = '\033]50;SetProfile='.profile.'\x7'
      if exists('$TMUX')
        let escape = '\033Ptmux;'.substitute(escape, '\\033', '\\033\\033', 'g').'\033\\'
      endif
      silent call system("printf '".escape."' > /dev/tty")
  endfunction

  " autocmd VimEnter,ColorScheme * call s:change_iterm2_profile()
endif

" }}}
" Plugin settings {{{
" ale {{{

let g:ale_lint_on_text_changed = 'normal'

let g:ale_linters = {
\   'python': ['flake8'],
\   'c' : ['clangtidy', 'cppcheck', 'clang'],
\   'cpp' : ['clangtidy', 'cppcheck'],
\   'cuda': ['cppcheck']
\}
" \   'c' : ['cppcheck', 'ccls', 'clangtidy'],
" \   'cpp' : ['cppcheck', 'ccls'],

let g:ale_fixers = {
\   'c': ['clang-format']
\}

if (hostname =~ "farnarkle") || (hostname =~ "swin.edu.au")
    let g:ale_cpp_cppcheck_executable="/fred/oz013/smutch/3rd_party/cppcheck/bin/cppcheck"
    let g:ale_c_cppcheck_executable=g:ale_cpp_cppcheck_executable
    let g:ale_cuda_cppcheck_executable=g:ale_cpp_cppcheck_executable
    " let g:ale_cpp_clang_executable="/home/smutch/.conda/envs/gpu_test/bin/clang++"
    " let g:ale_c_clang_executable="/home/smutch/.conda/envs/gpu_test/bin/clang"
    let g:ale_c_ccls_executable="/home/smutch/freddos/meraxes/3rd_party/ccls/bin/ccls"
    " call remove(g:ale_linters['c'], 1, 2)
endif

let g:ale_c_build_dir_names=['build', 'cmake-build-debug']

" let g:ale_cpp_cppcheck_options="--project=compile_commands.json --enable=style"
let g:ale_c_clangtidy_checks = ['-*', 'google-*', '-google-runtime-references', '-google-readability-braces-around-statements', 'modernize-*', 'mpi-*', 'performance-*', 'clang-analyzer-*', 'bugprone-*']
let g:ale_cpp_clangtidy_checks = g:ale_c_clangtidy_checks + ['cppcoreguidelines-*', '-cppcoreguidelines-pro-*']
let g:ale_c_clangformat_options = "-style=WebKit"

let g:ale_python_flake8_options = "--ignore=E501,E402,E226,E203,W503"

let g:ale_tex_chktex_options = "-I -n 35"

let g:ale_sign_error = '✖'
let g:ale_sign_warning = '!'
let g:ale_sign_info = 'ℹ'
let g:ale_sign_style_error = 'S>'
let g:ale_sign_style_warning = 's>'

hi! ALEError cterm=underline gui=underline guisp=Red
hi! link ALEWarning WarningMsg
hi! link ALEInfo MoreMsg

let g:ale_virtualtext_cursor = 1
let g:ale_virtualtext_prefix = '» '

nmap <leader>ar <Plug>(ale_find_references)
nmap <leader>af <Plug>(ale_fix)
nmap <leader>ad <Plug>(ale_go_to_definition)
nmap <leader>aD <Plug>(ale_go_to_definition_in_split)
nmap <leader>at <Plug>(ale_go_to_type_definition)
nmap <leader>aT <Plug>(ale_go_to_type_definition_in_split)
nmap <leader>ak <Plug>(ale_hover)
nmap <leader>al <Plug>(ale_lint)

" Map movement through errors without wrapping.
nmap <silent> <leader>a[ <Plug>(ale_previous)
nmap <silent> <leader>a] <Plug>(ale_next)

" OR map keys to use wrapping.
nmap <silent> <leader>a{ <Plug>(ale_previous_wrap)
nmap <silent> <leader>a} <Plug>(ale_next_wrap)

" }}}
" airline {{{

let g:airline#extensions#tmuxline#enabled = 0
let g:airline#extensions#tabline#enabled = 0
let g:airline_powerline_fonts = 1
let g:airline_left_sep=''
let g:airline_right_sep=''

call airline#parts#define_function('winnum', 'WindowNumber')
function! MyPlugin(...)
    let s:my_part = airline#section#create(['winnum'])
    " let w:airline_section_x = get(w:, 'airline_section_x', g:airline_section_x) . g:airline_right_sep . ' [' . s:my_part . ']'
    let w:airline_section_x = get(w:, 'airline_section_x', g:airline_section_x) . ' [' . s:my_part . ']'
endfunction
silent call airline#add_statusline_func('MyPlugin')

" }}}
" auto-pairs {{{

let g:AutoPairsFlyMode = 0
let g:AutoPairsShortcutToggle = ''

" }}}
" bbye {{{

nnoremap Q :Bdelete<CR>

" }}}
" coc {{{

" Use tab for trigger completion with characters ahead and navigate.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gD <Plug>(coc-declaration)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nmap <silent> g> <Plug>(coc-diagnostic-next)
nmap <silent> g< <Plug>(coc-diagnostic-prev)
nmap          gs :<C-u>CocList symbols<CR>

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

" Commands
nmap <leader>cd  <Plug>(coc-codeaction)
nmap <leader>cr  <Plug>(coc-refactor)
nmap <leader>cf  <Plug>(coc-format)
nmap <leader>cF  <Plug>(coc-format-selected)
vmap <leader>cf  <Plug>(coc-format-selected)

" Airline integration
let g:airline#extensions#coc#enabled = 1

" }}}
" dispatch {{{

let g:dispatch_compilers = {
      \ 'markdown': 'doit',
      \ 'python': 'python %'}

" remove iterm from the list of handlers (don't like it removing focus when run)
let g:dispatch_handlers = ['tmux', 'screen', 'windows', 'x11', 'headless']

" }}}
" easy-align {{{

vmap <Enter> <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

" }}}
" echodoc {{{

" N.B. ensure noshowmode has been set above
let g:echodoc_enable_at_startup = 0
let g:echodoc#type = "floating"

" }}}
" float-preview {{{

let g:float_preview#docked = 0

" }}}
" fugitive {{{

" Useful shortcut for git commands
nnoremap git :Git
nmap <leader>gc :Gcommit<CR>
nnoremap <leader>ga :Gcommit -a<CR>
nnoremap <leader>gs :Gstatus<CR>
nnoremap <leader>gd :Gdiff<CR>
nnoremap <leader>gm :Gmerge<CR>
nnoremap <leader>gP :Gpull<CR>
nnoremap <leader>gp :Gpush<CR>
nnoremap <leader>gf :Gfetch<CR>
nnoremap <leader>gg :Ggrep<CR>
nnoremap <leader>gw :Gwrite<CR>
nnoremap <leader>gr :Gread<CR>
nnoremap <leader>gb :Gblame<CR>

" }}}
" fzf {{{

" Advanced customization using autoload functions
inoremap <expr> <c-x><c-k> fzf#vim#complete#word({'left': '15%'})

" This is the default extra key bindings
let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-o': 'split',
  \ 'ctrl-v': 'vsplit' }

" Default fzf layout
" - down / up / left / right
" - window (nvim only)
let g:fzf_layout = { 'up': '~40%' }

" Customize fzf colors to match your color scheme
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }

" For Commits and BCommits to customize the options used by 'git log':
let g:fzf_commits_log_options = '--graph --color=always --format="%C(auto)%h%d %s %C(black)%C(bold)%cr"'

" Mappings and commands
nmap <leader>fm <plug>(fzf-maps-n)
xmap <leader>fm <plug>(fzf-maps-x)
omap <leader>fm <plug>(fzf-maps-o)

" redefine some commands to use the preview feature
" command! -bang -nargs=* -complete=file Files call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)
" command! -bang -nargs=* -complete=dir Ag call fzf#vim#ag(<q-args>, fzf#vim#with_preview(), <bang>0)
" command! -bang History call fzf#vim#history(fzf#vim#with_preview(), <bang>0)

command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always '.shellescape(<q-args>), 1,
  \   <bang>0 ? fzf#vim#with_preview('up:60%')
  \           : fzf#vim#with_preview('right:50%:hidden', '?'),
  \   <bang>0)

nnoremap <leader>fb :Buffers<CR>
nnoremap <leader>ff :Files %:p:h<CR>
nnoremap <leader>fhf :History<CR>
nnoremap <leader>fh: :History:<CR>
nnoremap <leader>fh/ :History/<CR>
nnoremap <leader>f: :Commands<CR>
nnoremap <leader>fw :Windows<CR>
nnoremap <leader>fs :Snippets<CR>
nnoremap <leader>f? :Helptags<CR>
nnoremap <leader>fg :GitFiles?<CR>
nnoremap <leader>fl :Lines<CR>
nnoremap <leader>fL :BLines<CR>
nnoremap <leader>ft :Tags<CR>
nnoremap <leader>fT :BTags<CR>
nnoremap <leader>f/ :Rg<CR>

imap <c-x><c-k> <plug>(fzf-complete-word)
imap <c-x><c-f> <plug>(fzf-complete-path)
imap <c-x><c-j> <plug>(fzf-complete-file-ag)
imap <c-x><c-l> <plug>(fzf-complete-line)

" project files
function! s:find_git_root()
  return system('git rev-parse --show-toplevel 2> /dev/null')[:-2]
endfunction
" command! -bang FZFProjectFiles call fzf#vim#files(s:find_git_root(), fzf#vim#with_preview(), <bang>0)
command! -bang FZFProjectFiles call fzf#vim#files(s:find_git_root(), <bang>0)
nnoremap <leader>fp :FZFProjectFiles<CR>

" }}}
" gitgutter {{{

let g:gitgutter_map_keys = 0
autocmd BufNewFile,BufRead /Volumes/* let g:gitgutter_enabled = 0
nnoremap ]h :GitGutterNextHunk<CR>
nnoremap [h :GitGutterPrevHunk<CR>
nnoremap ghs :GitGutterStageHunk<CR>
nnoremap ghr :GitGutterRevertHunk<CR>
nnoremap ghp :GitGutterPreviewHunk<CR>
let g:gitgutter_realtime = 0

let g:gitgutter_sign_added = '┃'
let g:gitgutter_sign_modified = '┃'
let g:gitgutter_sign_removed = '┃'
let g:gitgutter_sign_modified_removed = '┃'

" }}}
" goyo {{{

let g:goyo_width = 82

" }}}
" {{{ gutentags

let g:gutentags_resolve_symlinks = 0
let g:gutentags_project_root = [".tagme"]
let g:gutentags_ctags_tagfile = ".tags"
let g:gutentags_enabled = 1

let g:gutentags_ctags_extra_args = ['--c++-kinds=+p', '--c-kinds=-p', '--fields=+iaS', '--extra=+q']
let g:gutentags_ctags_exclude = ['build']

" }}}
" jedi {{{

" ---
" UNCOMMENT TO DISABLE
" let g:jedi#auto_initialization = 0
" ---

" These two are required for neocomplete
" let g:jedi#completions_enabled = 0
" let g:jedi#auto_vim_configuration = 0

" Ensure conda paths are being used (see https://github.com/cjrh/vim-conda/issues/15)
" let s:custom_sys_paths = system('~/miniconda3/bin/python -c "import sys; print(sys.path)"') 
" py3 << EOF
" import vim, sys, ast
" sys.path.extend(ast.literal_eval(vim.eval("s:custom_sys_paths")))
" EOF

let g:jedi#force_py_version = 3
let g:jedi#popup_on_dot = 0
let g:jedi#show_call_signatures = 2  "May be too slow...
let g:jedi#auto_close_doc = 0
autocmd FileType python let b:did_ftplugin = 1
let g:jedi#goto_stubs_command = '<localleader>s'
let g:jedi#goto_assignments_command = '<localleader>g'
let g:jedi#goto_command = '<localleader>d'
let g:jedi#rename_command = '<localleader>r'
let g:jedi#usages_command = '<localleader>u'

" move documentation to the right if the window is big enough
" au BufAdd * if bufname(expand('<afile>')) ==# "'__doc__'" | silent! wincmd L | endif

" close the documentation window
autocmd FileType python nnoremap <buffer> <localleader>D :exec bufwinnr('__doc__') . "wincmd c"<CR>

" }}}
" matchit {{{

if !exists('g:loaded_matchit')
  runtime macros/matchit.vim
endif

" }}}
" nerd_commenter {{{

" Custom NERDCommenter mappings
let g:NERDCustomDelimiters = {
            \ 'scons': { 'left': '#' },
            \ 'jinja': { 'left': '<!--', 'right': '-->' },
            \ }

let g:NERDSpaceDelims = 1
let g:NERDAltDelims_c = 1
map <leader><leader> <plug>NERDCommenterToggle
nnoremap <leader>cp yy:<C-u>call NERDComment('n', 'comment')<CR>p
nnoremap <leader>cP yy:<C-u>call NERDComment('n', 'comment')<CR>P
vnoremap <leader>cp ygv:<C-u>call NERDComment('x', 'comment')<CR>`>p
vnoremap <leader>cP ygv:<C-u>call NERDComment('x', 'comment')<CR>`<P

" }}}
" note-system {{{

let g:notes_dir = '~/Dropbox/Notes'
let g:notes_assets_dir = 'img'

" }}}
" polyglot {{{

 let g:polyglot_disabled = ['tex', 'latex', 'python']

" }}}
" sneak {{{

let g:sneak#streak = 1

"replace 'f' with 1-char Sneak
nmap f <Plug>Sneak_f
nmap F <Plug>Sneak_F
xmap f <Plug>Sneak_f
xmap F <Plug>Sneak_F
omap f <Plug>Sneak_f
omap F <Plug>Sneak_F
"replace 't' with 1-char Sneak
nmap t <Plug>Sneak_t
nmap T <Plug>Sneak_T
xmap t <Plug>Sneak_t
xmap T <Plug>Sneak_T
omap t <Plug>Sneak_t
omap T <Plug>Sneak_T

" }}}
" surround {{{

" Extra surround mappings for particular filetypes

" Markdown
autocmd FileType markdown let b:surround_109 = "\\\\(\r\\\\)" "math
autocmd FileType markdown let b:surround_115 = "~~\r~~" "strikeout
autocmd FileType markdown let b:surround_98 = "**\r**" "bold
autocmd FileType markdown let b:surround_105 = "*\r*" "italics

" }}}
" tagbar {{{

nnoremap <leader>T :TagbarToggle<CR>

" }}}
" ultisnips {{{

let g:UltiSnipsUsePythonVersion = 3
let g:UltiSnipsExpandTrigger = '<C-k>'
let g:UltiSnipsJumpForwardTrigger = '<C-k>'
let g:UltiSnipsJumpBackwardTrigger = '<C-j>'
let g:ultisnips_python_style = 'numpy'

" }}}
" vimcompletesme {{{

" set noshowmode shortmess+=c
" autocmd FileType tex,python let b:vcm_tab_complete = "omni"

" }}}
" vimtex {{{

" Latex options
let g:vimtex_latexmk_build_dir = './build'
let g:vimtex_latexmk_continuous = 1
let g:vimtex_latexmk_background = 1
let g:vimtex_quickfix_mode = 1
let g:vimtex_quickfix_latexlog = {'default' : 0}
let g:vimtex_view_method = 'skim'
" let g:vimtex_view_general_viewer = '/Applications/Skim.app/Contents/SharedSupport/displayline'
" let g:vimtex_view_general_options = '@line @pdf @tex'
let g:vimtex_fold_enabled = 1
let g:vimtex_compiler_progname='nvr'

" Quick map for adding a new item to an itemize environment list
call vimtex#imaps#add_map({
  \ 'lhs' : '<A-CR>',
  \ 'rhs' : '\item ',
  \ 'leader' : '',
  \ 'wrapper' : 'vimtex#imaps#wrap_environment',
  \ 'context' : ["itemize", "enumerate"],
  \})

" }}}
" vimux {{{

 " Run the current file with python
 au! FileType python nnoremap <buffer> <LocalLeader>v :call VimuxRunCommand("clear; python " . bufname("%"))<CR>

 " Prompt for a command to run
 map <Leader>vc :VimuxPromptCommand<CR>

 " Run last command executed by VimuxRunCommand
 map <Leader>vl :VimuxRunLastCommand<CR>

 " Inspect runner pane
 map <Leader>vi :VimuxInspectRunner<CR>

 " Close vim tmux runner opened by VimuxRunCommand
 map <Leader>vq :VimuxCloseRunner<CR>

 " Interrupt any command running in the runner pane
 map <Leader>vx :VimuxInterruptRunner<CR>

 " Zoom the runner pane (use <bind-key> z to restore runner pane)
 map <Leader>vz :call VimuxZoomRunner()<CR>

 function! VimuxSlime()
  call VimuxSendText(@v)
  " call VimuxSendKeys("Enter")
 endfunction

 " If text is selected, save it in the v buffer and send that buffer it to tmux
 vnoremap <Leader>vs "vy :call VimuxSlime()<CR>

 " Select current paragraph and send it to tmux
 nnoremap <Leader>vs vip"vy :call VimuxSlime()<CR>

 " Select current line and send it to tmux
 nnoremap <Leader>vS ^v$"vy :call VimuxSlime()<CR>

 " Call OpenRunner to assign pane if not already
 nnoremap <Leader>vo :call VimuxOpenRunner()<CR>

 function! VimuxIPython()
     call VimuxSendText("%cpaste")
     call VimuxSendKeys("Enter")
     call VimuxSendText(@v."--")
     " call VimuxSendKeys("Enter")
 endfunction

 " If text is selected, save it in the v buffer and send that buffer it to ipython
 vnoremap <Leader>vi "vy :call VimuxIPython()<CR>

 " Select current paragraph and send it to ipython
 nnoremap <Leader>vi vip"vy :call VimuxIPython()<CR>

" }}}
" }}}
