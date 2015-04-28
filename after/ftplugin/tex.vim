" ensure we are using latex and not plaintex
let g:tex_flavour='latex'

set spell
" setlocal nofoldenable
setlocal formatprg=par\ -w80\ -g
" setlocal conceallevel=0  "Prevent rendering of latex symbols (tres annoying!)
setlocal nocursorline
setlocal smartindent

setlocal iskeyword+=:
setlocal iskeyword-=_

setlocal softtabstop=2
setlocal shiftwidth=2
setlocal tw=80 fo=awtqron wm=0
execute "set colorcolumn=" . join(range(81,335), ',')

" setlocal cursorline  "This is very slow for large files
let b:wrapToggleFlag=1

" imap <Space><Space> <CR>
function! HardWrapSentences()
    let s = getline('.')
    let lineparts = split(s, '\.\@<=\s*')
    call append('.', lineparts)
    delete
endfunction
nnoremap <buffer> <leader>lw :call HardWrapSentences()<CR>

" Save then compile
nmap <buffer> <leader>s :w<CR><leader>ll<CR>

" Quick map for adding a new item to an itemize environment list
imap <buffer>  <CR>\item<Space>

" Wrap between lines when scrolling
set whichwrap+=<,>,h,l,[,]

" Keep minimum 5 lines above or below the cursor at all times
setlocal scrolloff=5

" Allow the wrapping to mess with existing lines
setlocal formatoptions-=l

" Maps FormatPar function to ,L
nnoremap  <buffer> ,L  :silent call FormatLatexPar(0)<CR>

" Jump to position in pdf
map <buffer> <silent> <Leader>ls :silent !/Applications/Skim.app/Contents/SharedSupport/displayline
    \ <C-R>=line('.')<CR> "<C-R>=latex#data[0].out()<CR>" "%:p" <CR>

" Tex only abbreviations
ab <buffer> ... \ldots

" Select 'chunks'
vnoremap <buffer> ac ?\(^ *$\)\\|\(^ *\\end\)\\|\(^ *\\begin\)\\|\(^ *\\item\)<CR><Esc>V/<CR>k
vnoremap <buffer> ic ?\(^ *$\)\\|\(^ *\\end\)\\|\(^ *\\begin\)\\|\(^ *\\item\)<CR>j<Esc>V/<CR>k
omap <buffer> ac :normal Vac<CR>:noh<CR>
omap <buffer> ic :normal Vic<CR>:noh<CR>

" complete mnras style citation commands (citet, citep, etc.)
let g:vimtex_complete_patterns.bib='\C\\\a*cite[tp]\=\a*\*\?\(\[[^\]]*\]\)*\_\s*{[^{}]*'
