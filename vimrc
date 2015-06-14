" vim:fdm=marker

" Initialisation {{{

" We don't want to mimic vi
set nocompatible

" Set the encoding
set encoding=utf-8

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

" Deal with gnu screen
if (match($TERM, "screen")!=-1) && !has('nvim')
    set term=screen-256color
endif

" }}}
" System specific {{{

" Do system specific settings
let os = substitute(system('uname'), "\n", "", "")
if os == "Darwin"
    let Tlist_Ctags_Cmd="/usr/local/bin/ctags"
end

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

" mappings
" f : file / format
noremap [file/form] <nop>
map <leader>f [file/form]
" w : windows
noremap [window] <nop>
map <leader>w [window]
" p : project
noremap [project] <nop>
map <leader>p [project]
" d : doc
noremap [doc] <nop>
map <leader>d [doc]
" g : git
noremap [git] <nop>
map <leader>g [git]
" u : undo
noremap [undo] <nop>
map <leader>u [undo]
" s : search
noremap [search] <nop>
map <leader>s [search]
" q : quickfix
noremap [quickfix] <nop>
map <leader>q [quickfix]
" l : location
noremap [loclist] <nop>
map <leader>l [loclist]
" y : yank
noremap [yank] <nop>
map <leader>y [yank]

set history=1000                     " Store a ton of history (default is 20)
set wildmenu                         " show list instead of just completing
set autoread                         " Automatically re-read changed files
set hidden                           " Don't unload a buffer when abandoning it
set mouse=a                          " enable mouse for all modes settings
set clipboard=unnamed                " To work in tmux
set spelllang=en_gb                  " British spelling
set showmode                         " Show the current mode
" set list                             " Show newline & tab markers
set showcmd                          " Show partial command in bottom right

set secure                           " Secure mode for reading vimrc, exrc files etc. in current dir
set exrc                             " Allow the use of folder dependent settings

let g:netrw_altfile = 1              " Prev buffer command excludes netrw buffers

" Use an interactive shell to allow command line aliases to work
" set shellcmdflag=-ic

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
set tags=./tags;$HOME                " recursively search up dir stack for tags file

" Grep will sometimes skip displaying the file name if you
" search in a singe file. Set grep
" program to always generate a file-name.
set grepprg=grep\ -nH\ $*

set wildignore+=*.o,*.obj,*/.git/*,*.pyc,*.pdf,*.ps,*.png,*.jpg,
            \*.aux,*.log,*.blg,*.fls,*.blg,*.fdb_latexmk,*.latexmain,.DS_Store,
            \Session.vim,Project.vim,tags,*.hdf5,.sconsign.dblite

" Set suffixes that are ignored with multiple match
set suffixes=.bak,~,.o,.info,.swp,.obj

" }}}
" Backup and swap files {{{
set backupdir=~/.vim_backup
set directory=~/.vim_backup
set undodir=~/.vim/.vim_backup/undo  " where to save undo histories
set undofile                         " Save undo's after file closes
" }}}

" }}}
" Visual settings {{{

set vb t_vb=                         " Turn off visual beep
set laststatus=2                     " Always display a status line
set cmdheight=1                      " Command line height
set listchars=tab:▸\ ,eol:↵          " Set hidden characters
let g:tex_conceal = ""               " Don't use conceal for latex equations

if has("gui_macvim")
  set guifont=Ubuntu\ Mono:h17
  " set guifont=Bitstream\ Vera\ Sans\ Mono:h17
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
if (&t_Co >= 256) && !has("gui_running")
    set background=dark
    if !has("gui_running")
        let g:gruvbox_italic=0
    endif
    colorscheme gruvbox
    " colorscheme molokai
elseif has("gui_running")
    set background=light
    colorscheme solarized
else
    set background=dark
    colorscheme base16-default
end

" }}}
" }}}
" Highlighting {{{

highlight link CheckWords DiffText

function! MatchCheckWords()
  match CheckWords /\c\<\(your\|Your\|it's\|they're\|halos\|Halos\|reionization\|Reionization\)\>/
endfunction

autocmd FileType markdown,tex,rst call MatchCheckWords()
autocmd BufWinEnter *.md,*.tex,*.rst call MatchCheckWords()
autocmd BufWinLeave *.md,*.tex,*.rst call clearmatches()

" }}}
" Custom commands and functions {{{

" Edit g2 file locally
command! -nargs=1 G2 execute ':e scp://g2/<args>'

" Show syntax highlighting groups for word under cursor
function! <SID>SynStack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc

" My grep
command! -nargs=+ MyGrep execute 'silent grep! <args> %' | copen 10
nnoremap [search]g :MyGrep
" command! -nargs=+ GrepBuffers execute ':call setqflist([]) | :silent bufdo grepadd! <args> % | copen'
" nnoremap [search]b :GrepBuffers
nnoremap [search]h :help <C-r><C-w><CR>

" Toggle wrapping at 80 col
function! WrapToggle()
    if exists("b:wrapToggleFlag") && b:wrapToggleFlag==1
        setlocal tw=0 fo-=awt fo+=l wm=0 colorcolumn=0
        let b:wrapToggleFlag=0
    else
        setlocal tw=80 fo+=awtn wm=0 fo-=l
        execute "setlocal colorcolumn=" . join(range(81,335), ',')
        let b:wrapToggleFlag=1
    endif
endfun
map coW :call WrapToggle()<CR>

" Remove trailing whitespace
command! TrimWhitespace execute ':%s/\s\+$// | :noh'
nmap [file/form]w :TrimWhitespace<CR>:w<CR>

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
nnoremap <silent> <leader>bn :bn<CR>
nnoremap <silent> <leader>bp :bp<CR>

" Quick switch to directory of current file
nnoremap [file/form]d :lcd %:p:h<CR>:pwd<CR>

" Leave cursor at end of yank after yanking text with lowercase y in visual 
" mode
vnoremap y y`>

" Make Y behave like other capital
nnoremap Y y$

" Easy on the fingers save and window manipulation bindings
nnoremap ;' :w<CR>
nnoremap [file/form]s :w<CR>
nnoremap ,w <C-w>
nnoremap [window] <C-w>
nnoremap ,. <C-w>p

" Toggle to last active tab
let g:lasttab = 1
nnoremap ,/ :exe "tabn ".g:lasttab<CR>
au TabLeave * let g:lasttab = tabpagenr()

" Switch back to alternate file
nnoremap ,, <C-S-^>
nnoremap <leader>bb <C-S-^>

" Disable increment number up / down - *way* too dangerous...
nmap <C-a> <Nop>
nmap <C-x> <Nop>

" Turn off highlighting
nmap ,h <Esc>:noh<CR>

" Paste without auto indent
nnoremap <F2> :set invpaste paste?<CR>
set pastetoggle=<F2>

" copy and paste to temp file
set cpoptions-=A
vmap [yank]y :w! ~/.vimbuffer<CR>
nmap [yank]y :.w! ~/.vimbuffer<CR>
set cpoptions-=a
nmap [yank]p :r ~/.vimbuffer<CR>

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
set makeprg=scons

" Trim trailing whitespace when saving python file
autocmd BufWritePre *.py normal m`:%s/\s\+$//e``

" enable spell checking on certain files
autocmd BufNewFile,BufRead COMMIT_EDITMSG set spell

" Automatically reload vimrc when it's saved
" augroup AutoReloadVimRC
"   au!
"   au BufWritePost $MYVIMRC so $MYVIMRC
" augroup END

" }}}
" Plugin settings {{{
" ack {{{

" We will use Ack only if The Silver Searcher isn't available
if !executable('ag')

    " Map keys for Ack
    nnoremap [search]a <Esc>:Ack!<Space>

    " Ack for current word under cursor
    nnoremap [search]w yiw<Esc>:Ack! <C-r>"<CR>

endif

" }}}
" ag {{{

" We will use only if The Silver Searcher is available
if executable('ag')

    " Map keys for Ag
    nnoremap [search]a <Esc>:Ag!<Space>

    " Ag for current word under cursor
    nnoremap [search]w yiw<Esc>:Ag! <C-r>"<CR>

endif

" }}}
" airline {{{

let g:airline#extensions#tmuxline#enabled = 0
let g:airline#extensions#tabline#enabled = 0
let g:airline_left_sep=''
let g:airline_right_sep=''

call airline#parts#define_function('winnum', 'WindowNumber')
function! MyPlugin(...)
    let s:my_part = airline#section#create(['winnum'])
    let w:airline_section_x = get(w:, 'airline_section_x', g:airline_section_x)
    let w:airline_section_x = '[' . s:my_part . '] ' . g:airline_right_sep . get(w:, 'airline_section_x', g:airline_section_x)
endfunction
call airline#add_statusline_func('MyPlugin')

" }}}
" bbye {{{

nnoremap Q :Bdelete<CR>

" }}}
" ctrlp {{{

" Include the bdelete plugin
call ctrlp_bdelete#init()

" Custom ignore paths
let g:ctrlp_custom_ignore = '\v[\/](\.git|\.hg|include|lib|bin)|(\.(swp|ico|git|svn))$'

" Custom root markers
let g:ctrlp_root_markers = ['.ctrlp_marker']

" This is the default value, but is used below...
let g:ctrlp_working_path_mode = 'ra'

" Default to filename searches - so that appctrl will find application
" controller
let g:ctrlp_by_filename = 1

" We don't want to use Ctrl-p as the mapping because
" it interferes with YankRing (paste, then hit ctrl-p)
let g:ctrlp_map = '[project]p'
let g:ctrlp_cmd = 'CtrlPMixed'

" Additional mapping for buffer search
nnoremap <silent> <leader>bs :CtrlPBuffer<CR>
nnoremap <silent> [project]b :CtrlPBookmarkDir<CR>

" Open files
nnoremap <silent> [project]f :CtrlP<CR>
nnoremap <silent> [file/form]o :CtrlP %p:h<CR>

" Additional mappting for most recently used files
nnoremap <silent> [file/form]r :CtrlPMRU<CR>

" Additional mapping for ctags search
nnoremap <silent> [project]t :CtrlPTag<CR>

"Cmd-(m)ethod - jump to a method (tag in current file)
nnoremap [project]m :CtrlPBufTag<CR>

"Ctrl-(M)ethod - jump to a method (tag in all files)
nnoremap [project]M :CtrlPBufTagAll<CR>

" quickfix
nnoremap [project]q :CtrlPQuickfix<CR>

" directories
nnoremap [project]d :CtrlPDir<CR>

" Search files in runtime path (vimrc etc.)
nnoremap [project]v :CtrlPRTS<CR>

" lines
nnoremap [project]l :CtrlPLine<CR>

" commands
nnoremap <leader>: :CtrlPCmdPalette<CR>

" Show the match window at the top of the screen
let g:ctrlp_match_window_bottom = 0

" }}}
" dash {{{

map <silent> <leader>dd <Plug>DashSearch

" }}}
" delimitmate {{{

" Settings for delimitmate

"This has pathological cases which annoy the shit out of me
" let delimitMate_autoclose = 0

" }}}
" dispatch {{{

" Use octodown as default build command for Markdown files
autocmd FileType markdown let b:dispatch = 'octodown %'

" }}}
" fugitive {{{

" Useful shortcut for git commands
nnoremap git :Git
nnoremap [git]a :Gcommit -a<CR>
nnoremap [git]s :Gstatus<CR>
nnoremap [git]d :Gdiff<CR>
nnoremap [git]m :Gmerge<CR>
nnoremap [git]P :Gpull<CR>
nnoremap [git]p :Gpush<CR>
nnoremap [git]f :Gfetch<CR>
nnoremap [git]g :Ggrep<CR>
" nnoremap [git]l :Glog<CR>
nnoremap [git]w :Gwrite<CR>
nnoremap [git]r :Gread<CR>
nnoremap [git]b :Gblame<CR>
nnoremap [git]c :Gcommit<CR>

" }}}
" fzf {{{

" colorscheme chooser
nnoremap <silent> <Leader>cs :call fzf#run({
            \   'source':
            \     map(split(globpath(&rtp, "colors/*.vim"), "\n"),
            \         "substitute(fnamemodify(v:val, ':t'), '\\..\\{-}$', '', '')"),
            \   'sink':    'colo',
            \   'options': '+m',
            \   'right':    30
            \ })<CR>

" search lines in all open buffers
function! s:line_handler(l)
    let keys = split(a:l, ':\t')
    exec 'buf' keys[0]
    exec keys[1]
    normal! ^zz
endfunction
function! s:buffer_lines()
    let res = []
    for b in filter(range(1, bufnr('$')), 'buflisted(v:val)')
        call extend(res, map(getbufline(b,0,"$"), 'b . ":\t" . (v:key + 1) . ":\t" . v:val '))
    endfor
    return res
endfunction
command! FZFLines call fzf#run({
            \   'source':  <sid>buffer_lines(),
            \   'sink':    function('<sid>line_handler'),
            \   'options': '--extended --nth=3..',
            \   'down':    '60%'
            \})
nnoremap <silent> [search]b :FZFLines<CR>

" fuzzy commandline completion (breaks neovim currently)
if !has('neovim')
    cnoremap <silent> <c-l> <c-\>eGetCompletions()<cr>
    "add an extra <cr> at the end of this line to automatically accept the fzf-selected completions.
    function! Lister()
        call extend(g:FZF_Cmd_Completion_Pre_List,split(getcmdline(),'\(\\\zs\)\@<!\& '))
    endfunction
    function! CmdLineDirComplete(prefix, options, rawdir)
        let l:dirprefix = matchstr(a:rawdir,"^.*/")
        if isdirectory(expand(l:dirprefix))
            return join(a:prefix + map(fzf#run({
                        \'options': a:options . ' --select-1  --query=' .
                        \ a:rawdir[matchend(a:rawdir,"^.*/"):len(a:rawdir)], 
                        \'dir': expand(l:dirprefix),
                        \'right': 30,
                        \}), 
                        \'"' . escape(l:dirprefix, " ") . '" . escape(v:val, " ")'))
        else
            return join(a:prefix + map(fzf#run({
                        \'options': a:options . ' --query='. a:rawdir }),
                        \'escape(v:val, " ")')) 
            "dropped --select-1 to speed things up on a long query
        endif
        endfunction
        function! GetCompletions()
            let g:FZF_Cmd_Completion_Pre_List = []
            let l:cmdline_list = split(getcmdline(), '\(\\\zs\)\@<!\& ', 1)
            let l:Prefix = l:cmdline_list[0:-2]
            execute "silent normal! :" . getcmdline() . "\<c-a>\<c-\>eLister()\<cr>\<c-c>"
            let l:FZF_Cmd_Completion_List = g:FZF_Cmd_Completion_Pre_List[len(l:Prefix):-1]
            unlet g:FZF_Cmd_Completion_Pre_List
            if len(l:Prefix) > 0 && l:Prefix[0] =~
                        \ '^ed\=i\=t\=$\|^spl\=i\=t\=$\|^tabed\=i\=t\=$\|^arged\=i\=t\=$\|^vsp\=l\=i\=t\=$'
                "single-argument file commands
                return CmdLineDirComplete(l:Prefix, "",l:cmdline_list[-1])
            elseif len(l:Prefix) > 0 && l:Prefix[0] =~ 
                        \ '^arg\=s\=$\|^ne\=x\=t\=$\|^sne\=x\=t\=$\|^argad\=d\=$'  
                "multi-argument file commands
                return CmdLineDirComplete(l:Prefix, '--multi', l:cmdline_list[-1])
            else 
                return join(l:Prefix + fzf#run({
                            \'source':l:FZF_Cmd_Completion_List, 
                            \'options': '--select-1 --query='.shellescape(l:cmdline_list[-1])
                            \})) 
            endif
        endfunction
    endif

" }}}
" gist {{{

" Make gists private by default
let g:gist_show_privates = 1


" }}}
" gitgutter {{{

autocmd BufNewFile,BufRead /Volumes/* let g:gitgutter_enabled = 0
nnoremap ghn :GitGutterNextHunk<CR>
nnoremap ghp :GitGutterPrevHunk<CR>
let g:gitgutter_realtime = 0

" }}}
" gitv {{{

nnoremap [git]l :Gitv<CR>
nnoremap [git]v :Gitv!<CR>

" }}}
" goyo {{{

let g:goyo_width = 82

" }}}
" gundo {{{

" Map keys for Gundo
nnoremap [undo]u :GundoToggle<CR>

" }}}
" incsearch {{{

map /  <Plug>(incsearch-forward)
map ?  <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)

let g:incsearch#auto_nohlsearch = 1
map n  <Plug>(incsearch-nohl-n)
map N  <Plug>(incsearch-nohl-N)
map *  <Plug>(incsearch-nohl-*)
map #  <Plug>(incsearch-nohl-#)
map g* <Plug>(incsearch-nohl-g*)
map g# <Plug>(incsearch-nohl-g#)

let g:incsearch#consistent_n_direction = 1

" }}}
" indentline {{{

" let g:loaded_indentLine=1
" let g:indentLine_char="|"
let g:indentLine_char = '┊'
let g:indentLine_fileTypeExclude=["tex", "Help"] 
nnoremap coI :IndentLinesToggle<CR>

" }}}
" jedi {{{

" These two are required for neocomplete
" let g:jedi#completions_enabled = 0
" let g:jedi#auto_vim_configuration = 0

let g:jedi#popup_on_dot = 0
let g:jedi#show_call_signatures = 1  "May be too slow...
let g:jedi#auto_close_doc = 0
autocmd FileType python let b:did_ftplugin = 1


" }}}
" limelight {{{

" toggle on and off
nnoremap <leader>L :Limelight<C-R>=(exists('#limelight') == 0) ? '' : '!'<CR><CR>

" }}}
" narrowregion {{{

let g:nrrw_rgn_nohl = 1

" }}}
" nerd_commenter {{{

" Custom NERDCommenter mappings
let g:NERDCustomDelimiters = {
            \ 'c': { 'leftAlt': '/*', 'rightAlt': '*/', 'left': '//' },
            \ 'scons': { 'left': '#' },
            \ }

let NERDSpaceDelims=1
map ;; <plug>NERDCommenterToggle
map ;s <plug>NERDCommenterSexy
map ;A <plug>NERDCommenterAppend
map ;a <plug>NERDCommenterAltDelims
map ;y <plug>NERDCommenterYank
map ;e <plug>NERDCommenterToEOL
map ;u <plug>NERDCommenterUncomment
map ;n <plug>NERDCommenterNest
map ;m <plug>NERDCommenterMinimal
map ;i <plug>NERDCommenterInvert
map ;l <plug>NERDCommenterAlignLeft
map ;b <plug>NERDCommenterAlignBoth
map ;c <plug>NERDCommenterComment
map ;p ;y`]p

" }}}
" notes-system {{{

let g:notes_dir = "/Users/smutch/Dropbox/Notes"

" }}}
" obvious-resize {{{

function! s:try_wincmd(cmd, default)
  if exists(':' . a:cmd)
    let cmd = v:count ? join([a:cmd, v:count]) : a:cmd
    execute cmd
  else
    execute join([v:count, 'wincmd', a:default])
  endif
endfunction

nnoremap <silent> [window]+ :<C-u>call <SID>try_wincmd('ObviousResizeUp',    '+')<CR>
nnoremap <silent> [window]- :<C-u>call <SID>try_wincmd('ObviousResizeDown',  '-')<CR>
nnoremap <silent> [window]< :<C-u>call <SID>try_wincmd('ObviousResizeLeft',  '<')<CR>
nnoremap <silent> [window]> :<C-u>call <SID>try_wincmd('ObviousResizeRight', '>')<CR>

" }}}
" open-browser {{{

nmap go <Plug>(openbrowser-smart-search)
vmap go <Plug>(openbrowser-smart-search)

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
" scratch {{{

let g:scratch_autohide = 0
let g:scratch_insert_autohide = 0

" }}}
" seek {{{

" Use the jump motions provided by seek
let g:seek_enable_jumps = 1
let g:seek_use_vanilla_binds_in_diffmode = 1

" }}}
" showmarks {{{

" Set showmarks bundle to off by default
let g:showmarks_enable = 0

" Toggle on/off
nnoremap com :ShowMarksToggle<CR>

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
" syntastic {{{

let g:syntastic_mode_map = { 'mode': 'passive',
                           \ 'active_filetypes': [],
                           \ 'passive_filetypes': [] }
let g:syntastic_error_symbol = '✗'
let g:syntastic_warning_symbol = '⚠'

" }}}
" tlist {{{

" Tlist options

" Set the list of tags
let g:tlTokenList = ['FIXME', 'TODO', 'CHANGED', 'TEMPORARY']

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

let g:UltiSnipsUsePythonVersion = 2
let g:UltiSnipsExpandTrigger = '<C-k>'
let g:UltiSnipsJumpForwardTrigger = '<C-k>'
let g:UltiSnipsJumpBackwardTrigger = '<C-j>'

" }}}
" vim-ipython {{{

let g:ipy_perform_mappings = 0
let g:ipy_completefunc = 'local'  "IPython completion for local buffer only

map  <buffer> <silent> <LocalLeader>pf         <Plug>(IPython-RunFile)
map  <buffer> <silent> <LocalLeader>p<Return>  <Plug>(IPython-RunLine)
map  <buffer> <silent> <LocalLeader>pl  <Plug>(IPython-RunLines)
map  <buffer> <silent> <LocalLeader>pd  <Plug>(IPython-OpenPyDoc)
map  <buffer> <silent> <LocalLeader>ps  <Plug>(IPython-UpdateShell)
map  <buffer> <silent> <S-F9>      <Plug>(IPython-ToggleReselect)
map  <buffer>          <LocalLeader>pa  <Plug>(IPython-ToggleSendOnSave)
map  <buffer> <silent> <LocalLeader>pr   <Plug>(IPython-RunLineAsTopLevel)

" }}}
" vimcompletesme {{{

autocmd FileType tex,python let b:vcm_tab_complete = "omni"

" }}}
" vimtex {{{

" Latex options
let g:vimtex_latexmk_build_dir = './build'
let g:vimtex_latexmk_continuous = 0
let g:vimtex_latexmk_background = 1
let g:vimtex_view_general_viewer = 'open'
let g:vimtex_view_general_options = '-a Skim'

" }}}
" vim-togglelist {{{

let g:toggle_list_no_mappings = 1
nnoremap [loclist]l :call ToggleLocationList()<CR>
nnoremap [quickfix]q :call ToggleQuickfixList()<CR>

" }}}
" }}}
