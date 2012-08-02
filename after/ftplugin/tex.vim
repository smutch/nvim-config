" colorscheme colorful
set background=light
let g:solarized_contrast="normal"
let g:solarized_visibility="normal"

set spell 

" TIP: if you write your \label's as \label{fig:something}, then if you
" type in \ref{fig: and press <C-n> you will automatically cycle through
" all the figure labels. Very useful!
setlocal iskeyword+=:
setlocal iskeyword-=_

set softtabstop=2
set shiftwidth=2
setlocal tw=80 fo=cqt wm=0 colorcolumn=80
let b:wrapToggleFlag=1

" imap <Space><Space> <CR>
function! HardWrapSentences()
    let s = getline('.')
    let lineparts = split(s, '\.\@<=\s*')
    call append('.', lineparts)
    delete
endfunction
nnoremap ,w :call HardWrapSentences()<CR>

" Save then compile
nmap <buffer> <leader>s :w<CR><leader>ll

" Quick map for adding a new item to an itemize environment list
imap <buffer>  <CR>\item 

" Wrap between lines when scrolling
set whichwrap+=<,>,h,l,[,]

" Keep minimum 5 lines above or below the cursor at all times
setlocal scrolloff=5

" Allow the wrapping to mess with existing lines
setlocal formatoptions-=l

" Maps FormatPar function to Ctrl-l
noremap! <buffer> <C-l>@  <ESC>:silent call FormatLatexPar(0)<CR>i

