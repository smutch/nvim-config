" colorscheme colorful
set background=light
let g:solarized_contrast="normal"
let g:solarized_visibility="low"

set spell 

" TIP: if you write your \label's as \label{fig:something}, then if you
" type in \ref{fig: and press <C-n> you will automatically cycle through
" all the figure labels. Very useful!
setlocal iskeyword+=:
setlocal iskeyword-=_

setlocal tw=80 fo=cqt wm=0 colorcolumn=80
let b:wrapToggleFlag=1

" imap <Space><Space> <CR>
" function! HardWrapSentences()
    " let s = getline('.')
    " let lineparts = split(s, '\.\@<=\s*')
    " call append('.', lineparts)
    " delete
" endfunction
" nnoremap ,w :call HardWrapSentences()<CR>

" Save then compile
nmap <leader>s :w<CR><leader>ll

" Wrap between lines when scrolling
set whichwrap+=<,>,h,l,[,]

" Keep minimum 5 lines above or below the cursor at all times
setlocal scrolloff=5

" Maps FormatPar function to Ctrl-l
noremap! <C-l>@  <ESC>:silent call FormatLatexPar(0)<CR>i
