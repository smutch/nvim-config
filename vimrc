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

" Remap task list key (must be done before loading plugin)
map <leader>t <Plug>TaskList

" Custom NERDCommenter mappings
let g:NERDCustomDelimiters = {
            \ 'c': { 'leftAlt': '/*', 'rightAlt': '*/', 'left': '//' },
            \ 'scons': { 'left': '#' },
            \ }

" Syntastic options
let g:syntastic_mode_map = { 'mode': 'passive',
                           \ 'active_filetypes': [],
                           \ 'passive_filetypes': [] }
let g:syntastic_error_symbol = '✗'
let g:syntastic_warning_symbol = '⚠'

" Deal with gnu screen
if match($TERM, "screen")!=-1
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
" Vundle {{{

" Load all plugins
if filereadable(expand("~/.vim/bundles"))
  source ~/.vim/bundles
endif

filetype plugin on
filetype indent on

" }}}
" Basic settings {{{
set history=1000                     " Store a ton of history (default is 20)
set wildmenu                         " show list instead of just completing
set autoread                         " Automatically re-read changed files
set hidden                           " Don't unload a buffer when abandoning it
set mouse=a                          " enable mouse for all modes settings
set clipboard=unnamed                " To work in tmux
set spelllang=en_gb                  " British spelling
set showmode                         " Show the current mode
set list                             " Show newline & tab markers
set showcmd                          " Show partial command in bottom right

set secure                           " Secure mode for reading vimrc, exrc files etc. in current dir
set exrc                             " Allow the use of folder dependent settings

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
  set guifont=Ubuntu\ Mono:h15
  set guioptions-=T  " remove toolbar
  set guioptions-=rL " remove right + left scrollbars
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

" Python files
let python_highlight_all = 1
let python_highlight_space_errors = 0

" Colorscheme {{{

syntax on " Use syntax highlighting
if exists('$SOLARIZED_THEME')
    if $SOLARIZED_THEME=="light"
        set background=light
    else
        set background=dark
    endif
else
    set background=dark
endif
if !has("gui_running")
    let g:gruvbox_italic=0
endif
if (&t_Co >= 256) || has("gui_running")
    " if match($TERM, "screen")!=-1
    " endif
    colorscheme gruvbox
else
    set background=dark
    colorscheme ir_black
end

" }}}
" }}}
" Highlighting {{{

highlight link CheckWords DiffText

function! MatchCheckWords()
  match CheckWords /\c\<\(your\|Your\|it's\|they're\|halos\|Halos\|reionisation\|Reionisation\)\>/
endfunction

autocmd FileType markdown,tex call MatchCheckWords()
autocmd BufWinEnter *.md,*.tex call MatchCheckWords()
autocmd BufWinLeave *.md,*.tex call clearmatches()

" }}}
" Custom commands and functions {{{

" Show syntax highlighting groups for word under cursor
function! <SID>SynStack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc
nmap ,csp :call <SID>SynStack()<CR>

" My grep
command! -nargs=+ MyGrep execute 'silent grep! <args> %' | copen 10
nnoremap ,g :MyGrep
command! -nargs=+ GrepBuffers execute ':call setqflist([]) | :silent bufdo grepadd! <args> % | copen'
nnoremap ,G :GrepBuffers

" Toggle wrapping at 80 col
function! WrapToggle()
    if exists("b:wrapToggleFlag") && b:wrapToggleFlag==1
        setlocal tw=0 fo-=t fo+=l wm=0 colorcolumn=0
        let b:wrapToggleFlag=0
    else
        setlocal tw=80 fo+=t wm=0 fo-=l colorcolumn=80
        let b:wrapToggleFlag=1
    endif
endfun
map coW :call WrapToggle()<CR>

" Remove trailing whitespace
command! TrimWhitespace execute ':%s/\s\+$// | :noh'
nmap ,W :TrimWhitespace<CR>:w<CR>

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

" }}}
" Keybindings {{{

" Command mode
nnoremap <space> :

" Reformat
nnoremap ,l gwac
vnoremap ,l gw

" Cycle through buffers quickly
nnoremap <silent> ,x :bn<CR>
nnoremap <silent> ,z :bp<CR>

" Quick switch to directory of current file
nnoremap ,cd :lcd %:p:h<CR>:pwd<CR>

" Bring up marks list
nnoremap ,m :marks<CR>

" Leave cursor at end of yank after yanking text with lowercase y in visual mode
vnoremap y y`>

" Make Y behave like other capital
nnoremap Y y$

" Easy on the fingers save and window manipulation bindings
nnoremap ;' :w<CR>
nnoremap ,w <C-w>
nnoremap ,. <C-w>p

" Toggle to last active tab
let g:lasttab = 1
nnoremap ,/ :exe "tabn ".g:lasttab<CR>
au TabLeave * let g:lasttab = tabpagenr()

" Switch back to alternate file
nnoremap ,, <C-S-^>

" Disable increment number up / down - *way* too dangerous...
nmap <C-a> <Nop>
nmap <C-x> <Nop>

" Turn off highlighting
nmap ,h <Esc>:noh<CR>

" Paste without auto indent
nnoremap <F2> :set invpaste paste?<CR>
set pastetoggle=<F2>

" Opening & closing quickfix window
nnoremap ,q :ccl<CR>
nnoremap ,Q :copen<CR>

" copy and paste to temp file
set cpoptions-=A
vmap ,c :w! ~/.vimbuffer<CR>
nmap ,c :.w! ~/.vimbuffer<CR>
set cpoptions-=a
nmap ,v :r ~/.vimbuffer<CR>

" Toggle auto paragraph formatting
nnoremap coa :set <C-R>=(&formatoptions =~# "aw") ? 'formatoptions-=aw' : 'formatoptions+=aw'<CR><CR>

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
    nmap <leader>A <Esc>:Ack!<Space>

    " Ack for current word under cursor
    nmap <leader>w yiw<Esc>:Ack! <C-r>"<CR>

endif

" }}}
" ag {{{

" We will use only if The Silver Searcher is available
if executable('ag')

    " Map keys for Ag
    nmap <leader>A <Esc>:Ag!<Space>

    " Ag for current word under cursor
    nmap <leader>w yiw<Esc>:Ag! <C-r>"<CR>

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

" Custom ignore paths
let g:ctrlp_custom_ignore = '\v[\/](\.git|\.hg|include|lib|bin)|(\.(swp|ico|git|svn))$'

" Custom root markers
let g:ctrlp_root_markers = ['.ctrlp_marker']

" Default to filename searches - so that appctrl will find application
" controller
let g:ctrlp_by_filename = 1

" We don't want to use Ctrl-p as the mapping because
" it interferes with YankRing (paste, then hit ctrl-p)
let g:ctrlp_map = ',T'
let g:ctrlp_cmd = 'CtrlPMixed'

" Additional mapping for buffer search
nnoremap <silent> ,b :CtrlPBuffer<CR>
nnoremap <silent> ,B :CtrlPBookmarkDir<CR>

" Additional mappting for most recently used files
nnoremap <silent> ,f :CtrlP<CR>
nnoremap <silent> ,F :CtrlPMRU<CR>

" Additional mapping for ctags search
nnoremap <silent> ,t :CtrlPTag<CR>

" Cmd-Shift-P to clear the cache
" nnoremap <silent> <D-P> :ClearCtrlPCache<cr>

"Cmd-(m)ethod - jump to a method (tag in current file)
map ,m :CtrlPBufTag<CR>

"Ctrl-(M)ethod - jump to a method (tag in all files)
map ,M :CtrlPBufTagAll<CR>

" Show the match window at the top of the screen
let g:ctrlp_match_window_bottom = 0

" Search files in runtime path (vimrc etc.)
map ,V :CtrlPRTS<CR>

" }}}
" dash {{{

nmap <silent> <leader>D <Plug>DashSearch

" }}}
" delimitmate {{{

" Settings for delimitmate

"This has pathological cases which annoy the shit out of me
" let delimitMate_autoclose = 0

" }}}
" fugitive {{{

" Useful shortcut for git commands
nnoremap git :Git
nnoremap gca :Gcommit -a<CR>
nnoremap gst :Gstatus<CR>
nnoremap gD  :Gdiff<CR>

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
" gundo {{{

" Map keys for Gundo
map <leader>G :GundoToggle<CR>

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
let g:indentLine_char="|"
let g:indentLine_fileTypeExclude=["tex"] 

" }}}
" jedi {{{

" These two are requireed for neocomplete
let g:jedi#completions_enabled = 0
let g:jedi#auto_vim_configuration = 0

let g:jedi#popup_on_dot = 0
let g:jedi#show_call_signatures = 0  "May be too slow...
let g:jedi#auto_close_doc = 0
autocmd FileType python let b:did_ftplugin = 1


" }}}
" latexbox {{{

" Latex options
let g:tex_flavor='latex'
let g:LatexBox_Folding=0
let g:LatexBox_viewer = "open -a Skim"
let g:LatexBox_loaded_matchparen = 1  "Too slow!!
let g:LatexBox_latexmk_async = 0

" }}}
" neocomplete {{{
" Disable AutoComplPop.
let g:acp_enableAtStartup = 0
" Use neocomplete.
let g:neocomplete#enable_at_startup = 1
" Use smartcase.
let g:neocomplete#enable_smart_case = 1
" Set minimum syntax keyword length.
let g:neocomplete#sources#syntax#min_keyword_length = 3
let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'

" Don't auto close the preview window
let g:neocomplete#enable_auto_close_preview = 0

" Define dictionary.
let g:neocomplete#sources#dictionary#dictionaries = {
    \ 'default' : '',
    \ 'vimshell' : $HOME.'/.vimshell_hist',
    \ 'scheme' : $HOME.'/.gosh_completions'
        \ }

" Define keyword.
if !exists('g:neocomplete#keyword_patterns')
    let g:neocomplete#keyword_patterns = {}
endif
let g:neocomplete#keyword_patterns['default'] = '\h\w*'

" Plugin key-mappings.
inoremap <expr><C-g>     neocomplete#undo_completion()
inoremap <expr><C-l>     neocomplete#complete_common_string()

" Recommended key-mappings.
" <CR>: close popup and save indent.
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function()
  return neocomplete#close_popup() . "\<CR>"
  " For no inserting <CR> key.
  "return pumvisible() ? neocomplete#close_popup() : "\<CR>"
endfunction
" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><C-y>  neocomplete#close_popup()
inoremap <expr><C-e>  neocomplete#cancel_popup()
" Close popup by <Space>.
"inoremap <expr><Space> pumvisible() ? neocomplete#close_popup() : "\<Space>"

" For cursor moving in insert mode(Not recommended)
"inoremap <expr><Left>  neocomplete#close_popup() . "\<Left>"
"inoremap <expr><Right> neocomplete#close_popup() . "\<Right>"
"inoremap <expr><Up>    neocomplete#close_popup() . "\<Up>"
"inoremap <expr><Down>  neocomplete#close_popup() . "\<Down>"
" Or set this.
"let g:neocomplete#enable_cursor_hold_i = 1
" Or set this.
"let g:neocomplete#enable_insert_char_pre = 1

" AutoComplPop like behavior.
"let g:neocomplete#enable_auto_select = 1

" Shell like behavior(not recommended).
"set completeopt+=longest
"let g:neocomplete#enable_auto_select = 1
"let g:neocomplete#disable_auto_complete = 1
"inoremap <expr><TAB>  pumvisible() ? "\<Down>" : "\<C-x>\<C-u>"

" Enable omni completion.
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
" autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType python setlocal omnifunc=jedi#completions
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

" Enable heavy omni completion.
if !exists('g:neocomplete#sources#omni#input_patterns')
  let g:neocomplete#sources#omni#input_patterns = {}
endif
let g:neocomplete#sources#omni#input_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
let g:neocomplete#sources#omni#input_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
let g:neocomplete#sources#omni#input_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'

" jedi completions
if !exists('g:neocomplete#force_omni_input_patterns')
  let g:neocomplete#force_omni_input_patterns = {}
endif
let g:neocomplete#force_omni_input_patterns.python =
\ '\%([^. \t]\.\|^\s*@\|^\s*from\s.\+import \|^\s*from \|^\s*import \)\w*'
" alternative pattern: '\h\w*\|[^. \t]\.\w*'

" mapping to toggle neocomplete on and off
nnoremap coe :NeoCompleteToggle<CR>

" }}}
" nerd_commenter {{{

" NERDCommenter
" Also see .vimrc.before for custom filetype mappings
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

autocmd FileType markdown nnoremap <buffer> ,nn :NewNote 
autocmd FileType markdown nnoremap <buffer> ,ni :InsertImage 

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

nnoremap <silent> ,w+ :<C-u>call <SID>try_wincmd('ObviousResizeUp',    '+')<CR>
nnoremap <silent> ,w- :<C-u>call <SID>try_wincmd('ObviousResizeDown',  '-')<CR>
nnoremap <silent> ,w< :<C-u>call <SID>try_wincmd('ObviousResizeLeft',  '<')<CR>
nnoremap <silent> ,w> :<C-u>call <SID>try_wincmd('ObviousResizeRight', '>')<CR>

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
" tlist {{{

" Tlist options

" Set the list of tags
let g:tlTokenList = ['FIXME', 'TODO', 'CHANGED', 'TEMPORARY']

let Tlist_Auto_Update = 1
let Tlist_Auto_Highlight_Tag = 1
let Tlist_Display_Prototype = 1
let Tlist_GainFocus_On_ToggleOpen = 1
let Tlist_File_Fold_Auto_Close = 1

" Mappings
nnoremap <leader>T :TlistToggle<CR>


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

map <silent> <F5> :python run_this_file()<CR>
map <silent> <S-F5> :python run_this_line()<CR>
map <silent> <F9> :python run_these_lines()<CR>
map <silent> ,pd :py get_doc_buffer()<CR>
map <silent> ,ps :py if update_subchannel_msgs(force=True): echo("vim-ipython shell updated",'Operator')<CR>
map <silent> <S-F9> :python toggle_reselect()<CR>
imap <C-F5> <C-O><F5>
imap <S-F5> <C-O><S-F5>
imap <silent> <F5> <C-O><F5>
map <C-F5> :call <SID>toggle_send_on_save()<CR>

"pi custom
map <silent> <C-Return> :python run_this_file()<CR>
map <silent> <C-s> :python run_this_line()<CR>
imap <silent> <C-s> <C-O>:python run_this_line()<CR>
map <silent> <M-s> :python dedent_run_this_line()<CR>
vmap <silent> <C-S> :python run_these_lines()<CR>
vmap <silent> <M-s> :python dedent_run_these_lines()<CR>
map <silent> <M-c> I#<ESC>
vmap <silent> <M-c> I#<ESC>
map <silent> <M-C> :s/^\([ \t]*\)#/\1/<CR>
vmap <silent> <M-C> :s/^\([ \t]*\)#/\1/<CR>

" }}}
" vimux {{{

" Vimux bindings
" ruby << EOF
" class Object
"   def flush; end unless Object.new.respond_to?(:flush)
"   end
" EOF
let VimuxHeight = "20"
let VimuxOrientation = "v"
map <Leader>rp :PromptVimTmuxCommand<CR>
map <Leader>rl :RunLastVimTmuxCommand<CR>
map <Leader>ri :InspectVimTmuxRunner<CR>
map <Leader>rx :CloseVimTmuxPanes<CR>
map <Leader>rs :InterruptVimTmuxRunner<CR>

" }}}
" }}}
