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

py3 pass

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
else
    let cscope_cmd="/usr/bin/cscope"
end

" What machine are we on?
let hostname = substitute(system('hostname'), '\n', '', '')

if (hostname =~ "hpc.swin.edu.au")
    set shell=/home/smutch/3rd_party/zsh-5.0.5/bin/zsh
    set t_ut=
endif

" }}}
" vim-plug {{{

" Load all plugins
if filereadable(expand("~/.vim/plugins.vim"))
  source ~/.vim/plugins.vim
endif

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
set showmode                         " Show the current mode
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
set tags+=./tags;$HOME                " recursively search up dir stack for tags file

" Use ag if possible, if not then ack, and fall back to grep if all else fails
if executable('ag')
    set grepprg=ag\ --nogroup\ --nocolor\ --column
    set grepformat=%f:%l:%c:%m
elseif executable('ack')
    set grepprg=ack\ -s\ -H\ --nocolor\ --nogroup\ --column
    set grepformat=%f:%l:%c:%m,%f:%l:%m
else
    " Grep will sometimes skip displaying the file name if you
    " search in a singe file. Set grep
    " program to always generate a file-name.
    set grepprg=grep\ -nH\ $*
endif
nnoremap <leader>* :silent grep! "<C-r><C-w>"<CR>:copen<CR>:redraw!<CR>
command! -nargs=+ -complete=file -bar Grep silent grep! <args>|copen|redraw!
nnoremap <leader>/ :Grep 

set wildignore+=*.o,*.obj,*.pyc,
            \*.aux,*.blg,*.fls,*.blg,*.fdb_latexmk,*.latexmain,.DS_Store,
            \Session.vim,Project.vim,tags,.sconsign.dblite

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

    map g<C-]> :cs find 3 <C-R>=expand("<cword>")<CR><CR>
    map g<C-\> :cs find 0 <C-R>=expand("<cword>")<CR><CR>
endif

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
" set listchars=tab:▸\ ,trail:·           " Set hidden characters
let g:tex_conceal = ""                  " Don't use conceal for latex equations
set number                              " Show line numbers

if has("gui_macvim")
  " set guifont=Monaco:h14
  " set guifont=Bitstream\ Vera\ Sans\ Mono:h17
  set guifont=Sauce\ Code\ Powerline\ Plus\ Nerd\ File\ Types\ Mono\ Plus\ Pomicons:h14
  set guioptions-=T  " remove toolbar
  set guioptions-=rL " remove right + left scrollbars
  set anti
  set linespace=3 "Increase the space between lines for better readability
elseif !has('nvim')
  " Set the ttymouse value to allow window resizing with mouse
  set ttymouse=xterm2
end

" Python files
let python_highlight_all = 1
let python_highlight_space_errors = 1

" Colorscheme {{{

syntax on " Use syntax highlighting
if (&t_Co >= 256)
    if exists('light') && light==1
        colorscheme Tomorrow
        let g:airline_theme='tomorrow'
    else
        " let g:hybrid_custom_term_colors = 1
        let g:hybrid_reduced_contrast = 1
        colorscheme hybrid
        let g:airline_theme="hybrid"
        " colorscheme two-firewatch
        " let g:airline_theme="twofirewatch"
    endif
    hi! link Search DiffAdd
    hi! link Conceal NonText
end

if exists('light') && light == 1
    set background=light
else
    set background=dark
endif

" Neovim terminal colors
if has("nvim")
    let g:terminal_color_0 = "#002b36"
    let g:terminal_color_1 = "#dc322f"
    let g:terminal_color_2 = "#859900"
    let g:terminal_color_3 = "#b58900"
    let g:terminal_color_4 = "#268bd2"
    let g:terminal_color_5 = "#6c71c4"
    let g:terminal_color_6 = "#2aa198"
    let g:terminal_color_7 = "#93a1a1"
    let g:terminal_color_8 = "#657b83"
    let g:terminal_color_9 = "#dc322f"
    let g:terminal_color_10 = "#859900"
    let g:terminal_color_11 = "#b58900"
    let g:terminal_color_12 = "#268bd2"
    let g:terminal_color_13 = "#6c71c4"
    let g:terminal_color_14 = "#2aa198"
    let g:terminal_color_15 = "#fdf6e3"
endif

" }}}

" Cursor configuration {{{
" ====================================================================
  let $NVIM_TUI_ENABLE_CURSOR_SHAPE=1
  let &t_SI = "\<Esc>[5 q"
  if exists("&t_SR")
      let &t_SR = "\<Esc>[3 q"
  endif
  let &t_EI = "\<Esc>[2 q"
" }}}

" }}}
" Highlighting {{{

highlight link CheckWords DiffText

function! MatchCheckWords()
  match CheckWords /\c\<\(your\|Your\|it's\|they're\|halos\|Halos\|reionisation\|Reionisation\)\>/
endfunction

autocmd FileType markdown,tex,rst call MatchCheckWords()
autocmd BufWinEnter *.md,*.tex,*.rst call MatchCheckWords()
autocmd BufWinLeave *.md,*.tex,*.rst call clearmatches()

" }}}
" Custom commands and functions {{{

" Edit g2 file locally
command! -nargs=1 G2 execute ':e scp://g2/<args>'

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

vmap <leader>y :<C-u>call YankToTemp()<CR>
nmap <leader>y V:<C-u>call YankToTemp()<CR>
nmap <leader>P :<C-u>call PasteFromTemp()<CR>

" Show syntax highlighting groups for word under cursor
function! <SID>SynStack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc
command! SynStack call <SID>SynStack()

" Toggle wrapping at 80 col
function! WrapToggle()
    if exists("b:wrapToggleFlag") && b:wrapToggleFlag==1
        let &l:tw = s:old_tw
        setlocal fo-=wt fo+=l wm=0 colorcolumn=0
        let b:wrapToggleFlag=0
    else
        let s:old_tw = &tw
        setlocal tw=80 fo+=wtn wm=0 fo-=l
        execute "setlocal colorcolumn=" . join(range(81,335), ',')
        let b:wrapToggleFlag=1
    endif
endfun
map coW :call WrapToggle()<CR>

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
command! Erc execute ':e ~/.vim/vimrc'
command! Eplug execute ':e ~/.vim/plugins.vim'

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

" make <c-l> do more than just redraw the screen
nnoremap <leader>l :nohlsearch<cr>:diffupdate<cr>:syntax sync fromstart<cr><c-l>

" }}}
" Keybindings {{{

" ctrl-space does omnicomplete or keyword complete if menu not already visible
" inoremap <expr> <C-Space> pumvisible() \|\| &omnifunc == '' ?
"             \ "\<lt>C-n>" :
"             \ "\<lt>C-x>\<lt>C-o><c-r>=pumvisible() ?" .
"             \ "\"\\<lt>c-n>\\<lt>c-p>\\<lt>c-n>\" :" .
"             \ "\" \\<lt>bs>\\<lt>C-n>\"\<CR>"
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
nnoremap <CR>w <C-w>p

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

" Neovim terminal mappings
if has('nvim')
    autocmd BufWinEnter,WinEnter term://* startinsert
    tnoremap kj <C-\><C-n>
    tnoremap <C-w> <C-\><C-n><C-w>
    tnoremap <A-h> <C-\><C-n><C-w>h
    tnoremap <A-j> <C-\><C-n><C-w>j
    tnoremap <A-k> <C-\><C-n><C-w>k
    tnoremap <A-l> <C-\><C-n><C-w>l
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

" Trim trailing whitespace when saving python file
autocmd BufWritePre *.py normal m`:%s/\s\+$//e``

" enable spell checking on certain files
autocmd BufNewFile,BufRead COMMIT_EDITMSG set spell

" Automatically reload vimrc when it's saved
" augroup AutoReloadVimRC
"   au!
"   au BufWritePost $MYVIMRC so $MYVIMRC
" augroup END

" If we have a wide window then put the preview window on the right
au BufAdd * if &previewwindow && &columns >= 160 | silent! wincmd L | endif

" web related languages
autocmd FileType javascript,coffee,html,css,scss,sass setlocal ts=2 sw=2

" make sure all tex files are set to correct filetype
autocmd BufNewFile,BufRead *.tex set ft=tex

" set marks to jump between header and source files
autocmd BufLeave *.{c,cpp} mark C
autocmd BufLeave *.h       mark H

" }}}
" Plugin settings {{{
" airline {{{

let g:airline#extensions#tmuxline#enabled = 0
let g:airline#extensions#tabline#enabled = 0
let g:airline_powerline_fonts = 1
" let g:airline_left_sep=''
" let g:airline_right_sep=''

call airline#parts#define_function('winnum', 'WindowNumber')
function! MyPlugin(...)
    let s:my_part = airline#section#create(['winnum'])
    let w:airline_section_x = get(w:, 'airline_section_x', g:airline_section_x)
    let w:airline_section_x = '[' . s:my_part . '] ' . g:airline_right_sep . get(w:, 'airline_section_x', g:airline_section_x)
endfunction
call airline#add_statusline_func('MyPlugin')

" }}}
" argwrap {{{

nnoremap <silent> <leader>a :<C-u>ArgWrap<CR>

" }}}
" auto-pairs {{{

" let g:AutoPairsFlyMode = 1

" }}}
" bbye {{{

nnoremap Q :Bdelete<CR>

" }}}
" ctrlp {{{

" Set the matching function
" PyMatcher for CtrlP
if !has('python3')
    echo 'In order to use pymatcher plugin, you need +python compiled vim'
else
    let g:ctrlp_match_func = { 'match': 'pymatcher#PyMatch' }
endif

" Include the bdelete plugin
call ctrlp_bdelete#init()

" Custom ignore paths
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/](\.git|\.hg|include|lib|bin)',
  \ 'file': '\v\.(exe|so|dll|os|swp|svn|hdf5|h5)$',
  \ }

" Custom root markers
let g:ctrlp_root_markers = ['.ctrlp_marker']

" This is the default value, but is used below...
let g:ctrlp_working_path_mode = 'ra'

" Default to filename searches - so that appctrl will find application
" controller
let g:ctrlp_by_filename = 1

let g:ctrlp_map = '<leader>M'
let g:ctrlp_cmd = 'CtrlPMixed'

" Additional mapping for buffer search
nnoremap <silent> <leader>b :CtrlPBuffer<CR>

" Project bookmarks
nnoremap <silent> <leader>B :CtrlPBookmarkDir<CR>

" Open files
nnoremap <silent> <leader>p :CtrlP<CR>
nnoremap <silent> <leader>f :CtrlP %p:h<CR>

" Additional mappting for most recently used files
nnoremap <silent> <leader>m :CtrlPMRU<CR>

" Additional mapping for ctags search
function! CtrlPTagsWrapper()
    let old_tags = &tags
    let &tags = './tags;../tags'
    exec ':CtrlPTag'
    let &tags = old_tags
endfunction
nnoremap <silent> <leader>T :<C-u>call CtrlPTagsWrapper()<CR>

" Jump to a tag in all files
nnoremap <leader>t :CtrlPBufTagAll<CR>

" Show the match window at the top of the screen
let g:ctrlp_match_window_bottom = 0

" }}}
" devicons {{{

let g:webdevicons_enable_ctrlp = 0

" }}}
" dispatch {{{

" Use octodown as default build command for Markdown files
autocmd FileType markdown let b:dispatch = 'octodown %'
nnoremap <leader>x :Dispatch<CR>

let g:dispatch_extra_env_vars = 'LD_LIBRARY_PATH=/home/smutch/3rd_party/pcre/lib'

let g:dispatch_compilers = {
      \ 'markdown': 'doit',
      \ 'python': 'python %'}

" }}}
" easy-align {{{

vmap <Enter> <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

" }}}
" fugitive {{{

" Useful shortcut for git commands
nnoremap git :Git
nmap <leader>gc :Gcommit<CR>
nnoremap <leader>ga :Gcommit -a<CR>
nnoremap <leader>gs :Gstatus<CR>
nnoremap <leader>gd :Gdiff<CR>
nnoremap <leader>gm :Gmerge<CR>
if hostname =~ 'hpc.swin.edu.au'
    nnoremap <leader>gP :Git g2 pull<CR>
else
    nnoremap <leader>gP :Gpull<CR>
endif
if hostname =~ 'hpc.swin.edu.au'
    nnoremap <leader>gp :Git g2 push<CR>
else
    nnoremap <leader>gp :Gpush<CR>
endif
if hostname =~ 'hpc.swin.edu.au'
    nnoremap <leader>gf :Git g2 fetch<CR>
else
    nnoremap <leader>gf :Gfetch<CR>
endif
nnoremap <leader>gg :Ggrep<CR>
nnoremap <leader>gw :Gwrite<CR>
nnoremap <leader>gr :Gread<CR>
nnoremap <leader>gb :Gblame<CR>

" }}}
" fzf {{{

" Use a new iterm window if calling from macvim
if has("gui_macvim")
    let g:fzf_launcher = "in_a_new_term %s"
endif

" Mapping selecting mappings
nmap <leader><tab> <plug>(fzf-maps-n)
xmap <leader><tab> <plug>(fzf-maps-x)
omap <leader><tab> <plug>(fzf-maps-o)

" Insert mode completion
imap <c-x><c-k> <plug>(fzf-complete-word)
imap <c-x><c-f> <plug>(fzf-complete-path)
imap <c-x><c-j> <plug>(fzf-complete-file-ag)
imap <c-x><c-l> <plug>(fzf-complete-line)

" Advanced customization using autoload functions
inoremap <expr> <c-x><c-k> fzf#vim#complete#word({'left': '15%'})

" This is the default extra key bindings
let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }

" Default fzf layout
" - down / up / left / right
" - window (nvim only)
let g:fzf_layout = { 'up': '~40%' }

" For Commits and BCommits to customize the options used by 'git log':
let g:fzf_commits_log_options = '--graph --color=always --format="%C(auto)%h%d %s %C(black)%C(bold)%cr"'

" Open files
function! s:find_git_root()
  return system('git rev-parse --show-toplevel 2> /dev/null')[:-2]
endfunction
command! ProjectFiles execute 'Files' s:find_git_root()

" Additional mapping for ctags search
function! s:FZFTagsWrapper()
    let old_tags = &tags
    let &tags = './tags;../tags'
    exec ':Tags'
    let &tags = old_tags
endfunction
command! FZFTagsWrapper execute s:FZFTagsWrapper()

" commands
nnoremap <leader>: :Commands<CR>

" }}}
" gitgutter {{{

let g:gitgutter_map_keys = 0
autocmd BufNewFile,BufRead /Volumes/* let g:gitgutter_enabled = 0
nnoremap ]h :GitGutterNextHunk<CR>
nnoremap [h :GitGutterPrevHunk<CR>
nnoremap ghs :GitGutterStageHunk<CR>
nnoremap ghr :GitGutterRevertHunk<CR>
let g:gitgutter_realtime = 0

" }}}
" goyo {{{

let g:goyo_width = 82

" }}}
" jedi {{{

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
let g:jedi#goto_assignments_command = '<localleader>g'

" move documentation to the right if the window is big enough
" au BufAdd * if bufname(expand('<afile>')) ==# "'__doc__'" | silent! wincmd L | endif

" }}}
" limelight {{{

" toggle on and off
nnoremap coL :Limelight<C-R>=(exists('#limelight') == 0) ? '' : '!'<CR><CR>

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
" neomake {{

let g:neomake_python_enabled_makers = ['python', 'pyflakes']

function! SetWarningType(entry)
    if a:entry.type =~? '\m^[SPI]'
        let a:entry.type = 'I'
    endif
endfunction

let g:neomake_c_cppcheck_maker = {
        \ 'args': ['%:p', '-q', '--enable=style'],
        \ 'errorformat': '[%f:%l]: (%trror) %m,' .
        \ '[%f:%l]: (%tarning) %m,' .
        \ '[%f:%l]: (%ttyle) %m,' .
        \ '[%f:%l]: (%terformance) %m,' .
        \ '[%f:%l]: (%tortability) %m,' .
        \ '[%f:%l]: (%tnformation) %m,' .
        \ '[%f:%l]: (%tnconclusive) %m,' .
        \ '%-G%.%#',
        \ 'postprocess': function('SetWarningType')
        \ }

augroup Neomake
    au!
    if (hostname !~ "hpc.swin.edu.au")
        au BufWritePost *.py Neomake
        au BufWritePost *.[ch] Neomake
    endif
augroup END

function! ToggleNeomakeOnSave()
    if exists("#Neomake#BufWritePost#<buffer>")
        augroup Neomake
            au! BufWritePost <buffer>
        augroup END
    else
        augroup Neomake
            au BufWritePost <buffer> Neomake
        augroup END
    endif
endfunction
command! ToggleNeomakeOnSave normal! :<C-u>call ToggleNeomakeOnSave()<CR>


" }}
" notes-system {{{

let g:notes_dir = "/Users/smutch/Dropbox/Notes"
let g:notes_assets_dir = "assets"

" }}}
" peekaboo {{{

let g:peekaboo_window = 'enew'
let g:peekaboo_delay = 750

" }}}
" polyglot {{{

 let g:polyglot_disabled = ['tex', 'latex']

" }}}
" pydoc {{{

" Pydoc

if has("gui_macvim")
    let g:pydoc_cmd = "/usr/local/bin/pydoc"
elseif has("mac")
    let g:pydoc_cmd = "/usr/local/bin/pydoc"
elseif has("unix")
    let g:pydoc_cmd = "/usr/local/python-2.7.1/bin/pydoc"
endif

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
" showmarks {{{

" Set showmarks bundle to off by default
let g:showmarks_enable = 0

" Don't show marks which may link to other files
let g:showmarks_include="abcdefghijklmnopqrstuvwxyz.'`^<>[]{}()\""

" }}}
" surround {{{

" Extra surround mappings for particular filetypes

" Markdown
autocmd FileType markdown let b:surround_109 = "\\\\(\r\\\\)" "math
autocmd FileType markdown let b:surround_115 = "~~\r~~" "strikeout
autocmd FileType markdown let b:surround_98 = "**\r**" "bold
autocmd FileType markdown let b:surround_105 = "*\r*" "italics

" }}}
" " syntastic {{{

" let g:syntastic_always_populate_loc_list = 1
" let g:syntastic_auto_loc_list = 0
" let g:syntastic_check_on_open = 1
" let g:syntastic_check_on_wq = 0

" let g:syntastic_mode_map = { 'mode': 'passive',
"                            \ 'passive_filetypes': [],
"                            \ 'active_filetypes': ['python'] }
"                            " \ 'active_filetypes': ['c', 'cpp', 'python'],
" let g:syntastic_python_checkers = ["python"] 
" " "flake8"]
" " let g:syntastic_error_symbol = '✗'
" " let g:syntastic_warning_symbol = '⚠'

" let g:syntastic_error_symbol = '❌'
" let g:syntastic_warning_symbol = '⚠️'
" let g:syntastic_style_error_symbol = '🚫'
" let g:syntastic_style_warning_symbol = '💩'

" " }}}
" tlist {{{

" Tlist options

" Set the list of tags
let g:tlTokenList = ['FIXME', 'TODO', 'CHANGED', 'TEMPORARY', '@todo']

let Tlist_Auto_Update = 1
let Tlist_Auto_Highlight_Tag = 1
let Tlist_Display_Prototype = 1
let Tlist_GainFocus_On_ToggleOpen = 1
let Tlist_File_Fold_Auto_Close = 1

" }}}
" tmuxline {{{

let g:tmuxline_powerline_separators = 0

" }}}
" ultisnips {{{

let g:UltiSnipsUsePythonVersion = 3
let g:UltiSnipsExpandTrigger = '<C-k>'
let g:UltiSnipsJumpForwardTrigger = '<C-k>'
let g:UltiSnipsJumpBackwardTrigger = '<C-j>'

" }}}
" vimcompletesme {{{

autocmd FileType tex,python,c let b:vcm_tab_complete = "omni"

" }}}
" vim-emoji {{{

command! EmojiRender normal! :%s/:\([^:]\+\):/\=emoji#for(submatch(1), submatch(0))/g<CR>

" }}}
" vim-ipython {{{

let g:ipy_perform_mappings = 0
let g:ipy_completefunc = 'local'  "IPython completion for local buffer only

map  <buffer> <silent> <LocalLeader>f         <Plug>(IPython-RunFile)
map  <buffer> <silent> <LocalLeader>l         <Plug>(IPython-RunLine)
vmap  <buffer> <silent> <LocalLeader>l        <Plug>(IPython-RunLines)
map  <buffer> <silent> <LocalLeader>k  <Plug>(IPython-OpenPyDoc)
map  <buffer> <silent> <LocalLeader>u  <Plug>(IPython-UpdateShell)
map  <buffer> <silent> tr      <Plug>(IPython-ToggleReselect)
map  <buffer>          <LocalLeader>ts  <Plug>(IPython-ToggleSendOnSave)
map  <buffer> <silent> <LocalLeader>r   <Plug>(IPython-RunLineAsTopLevel)

" }}}
" vim-pencil {{{

let g:pencil#textwidth = 80
let g:pencil#joinspaces = 1
let g:pencil#conceallevel = 2
let g:airline_section_x = '%{PencilMode()}'
let g:pencil#wrapModeDefault = 'soft'

augroup pencil
  autocmd!
  autocmd FileType markdown,mkd call pencil#init()
  autocmd FileType text         call pencil#init()
  " autocmd FileType tex,latex    call pencil#init()
augroup END

" }}}
" vimtex {{{

" Latex options
let g:vimtex_latexmk_build_dir = './build'
let g:vimtex_latexmk_continuous = 1
let g:vimtex_latexmk_background = 1
let g:vimtex_quickfix_mode = 1
let g:vimtex_quickfix_ignore_all_warnings = 1
let g:vimtex_view_general_viewer = '/Applications/Skim.app/Contents/SharedSupport/displayline'
let g:vimtex_view_general_options = '@line @pdf @tex'

" }}}
" }}}
