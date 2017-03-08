" ensure we are using latex and not plaintex
let g:tex_flavour='latex'

" let g:tex_conceal = ""  " Don't use conceal for latex equations
set cole=2

set spell
setlocal formatprg=par\ -w79\ -g
setlocal nocursorline
setlocal smartindent

setlocal iskeyword+=:
setlocal iskeyword-=_

setlocal softtabstop=2
setlocal shiftwidth=2
setlocal tw=79 fo=tqron2 wm=0
let b:wrapToggleFlag=1
execute "set colorcolumn=" . join(range(80,335), ',')

" setlocal cursorline  "This is very slow for large files

" imap <Space><Space> <CR>
function! HardWrapSentences()
    let s = getline('.')
    let lineparts = split(s, '\.\@<=\s*')
    call append('.', lineparts)
    delete
endfunction
nnoremap <buffer> <localleader>lw :call HardWrapSentences()<CR>

" Save then compile
nmap <buffer> <localleader>s :w<CR><localleader>ll
nnoremap <buffer> [compile/comment]x :w<CR>:call vimtex#latexmk#compile()<CR>

" Quick map for adding a new item to an itemize environment list
imap <buffer> ;; <CR>\item<Space>

" Wrap between lines when scrolling
set whichwrap+=<,>,h,l,[,]

" Keep minimum 5 lines above or below the cursor at all times
setlocal scrolloff=5

" Maps FormatPar function to ,L
" nnoremap  <buffer> ,L  :silent call FormatLatexPar(0)<CR>

" Tex only abbreviations
ab <buffer> ... \ldots

" Select 'chunks'
vnoremap <buffer> ac ?\(^ *$\)\\|\(^ *\\end\)\\|\(^ *\\begin\)\\|\(^ *\\item\)<CR><Esc>V/<CR>k
vnoremap <buffer> ic ?\(^ *$\)\\|\(^ *\\end\)\\|\(^ *\\begin\)\\|\(^ *\\item\)<CR>j<Esc>V/<CR>k
omap <buffer> ac :normal Vac<CR>:noh<CR>
omap <buffer> ic :normal Vic<CR>:noh<CR>

" complete mnras style citation commands (citet, citep, etc.)
" let g:vimtex_complete_patterns.bib='\C\\\a*cite[tp]\=\a*\*\?\(\[[^\]]*\]\)*\_\s*{[^{}]*'
