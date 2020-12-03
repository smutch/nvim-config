" ensure we are using latex and not plaintex
let g:tex_flavour='latex'

" let g:tex_conceal = ""  " Don't use conceal for latex equations
au! BufEnter *.tex set cole=0 

set spell
" setlocal formatprg=par\ -w79\ -g
setlocal nocursorline

setlocal iskeyword+=:
setlocal iskeyword-=_

setlocal softtabstop=2
setlocal shiftwidth=2
setlocal tw=120 wm=0
" setlocal fo=tqron2 
execute "set colorcolumn=" . join(range(121,335), ',')
setlocal norelativenumber nonumber

noremap <localleader>la :set <C-R>=(&fo =~# "a") ? "fo-=a" : "fo+=a"<CR><CR>

" imap <Space><Space> <CR>
function! HardWrapSentences()
    let s = getline('.')
    let lineparts = split(s, '\.\@<=\s*')
    call append('.', lineparts)
    delete
endfunction
nnoremap <buffer> <localleader>lw :call HardWrapSentences()<CR>

" Wrap between lines when scrolling
set whichwrap+=<,>,h,l,[,]

" Keep minimum 5 lines above or below the cursor at all times
setlocal scrolloff=5

" Tex only abbreviations
ab <buffer> ... \ldots

" completion
lua require'completion'.addCompletionSource('vimtex', require'vimtex'.complete_item)
let g:completion_chain_complete_list = {
            \ 'tex' : [
            \     {'complete_items': ['vimtex', 'snippet']}, 
            \     {'mode': 'omni'}, 
            \   ],
            \ }

" syntax
hi! link Folded texStyleBold

" Select 'chunks'
" vnoremap <buffer> ac ?\(^ *$\)\\|\(^ *\\end\)\\|\(^ *\\begin\)\\|\(^ *\\item\)<CR><Esc>V/<CR>k
" vnoremap <buffer> ic ?\(^ *$\)\\|\(^ *\\end\)\\|\(^ *\\begin\)\\|\(^ *\\item\)<CR>j<Esc>V/<CR>k
" omap <buffer> ac :normal Vac<CR>:noh<CR>
" omap <buffer> ic :normal Vic<CR>:noh<CR>

" complete mnras style citation commands (citet, citep, etc.)
" let g:vimtex_complete_patterns.bib='\C\\\a*cite[tp]\=\a*\*\?\(\[[^\]]*\]\)*\_\s*{[^{}]*'
