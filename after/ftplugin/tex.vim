" ensure we are using latex and not plaintex
let g:tex_flavour='latex'

call ncm2#register_source({
        \ 'name' : 'vimtex-cmds',
        \ 'priority': 8, 
        \ 'complete_length': -1,
        \ 'scope': ['tex'],
        \ 'matcher': {'name': 'prefix', 'key': 'word'},
        \ 'word_pattern': '\w+',
        \ 'complete_pattern': g:vimtex#re#ncm2#cmds,
        \ 'on_complete': ['ncm2#on_complete#omni', 'vimtex#complete#omnifunc'],
        \ })
call ncm2#register_source({
        \ 'name' : 'vimtex-labels',
        \ 'priority': 8, 
        \ 'complete_length': -1,
        \ 'scope': ['tex'],
        \ 'matcher': {'name': 'combine',
        \             'matchers': [
        \               {'name': 'substr', 'key': 'word'},
        \               {'name': 'substr', 'key': 'menu'},
        \             ]},
        \ 'word_pattern': '\w+',
        \ 'complete_pattern': g:vimtex#re#ncm2#labels,
        \ 'on_complete': ['ncm2#on_complete#omni', 'vimtex#complete#omnifunc'],
        \ })
call ncm2#register_source({
        \ 'name' : 'vimtex-files',
        \ 'priority': 8, 
        \ 'complete_length': -1,
        \ 'scope': ['tex'],
        \ 'matcher': {'name': 'combine',
        \             'matchers': [
        \               {'name': 'abbrfuzzy', 'key': 'word'},
        \               {'name': 'abbrfuzzy', 'key': 'abbr'},
        \             ]},
        \ 'word_pattern': '\w+',
        \ 'complete_pattern': g:vimtex#re#ncm2#files,
        \ 'on_complete': ['ncm2#on_complete#omni', 'vimtex#complete#omnifunc'],
        \ })
call ncm2#register_source({
        \ 'name' : 'bibtex',
        \ 'priority': 8, 
        \ 'complete_length': -1,
        \ 'scope': ['tex'],
        \ 'matcher': {'name': 'combine',
        \             'matchers': [
        \               {'name': 'prefix', 'key': 'word'}
        \             ]},
        \ 'word_pattern': '\w+',
        \ 'complete_pattern': g:vimtex#re#ncm2#bibtex,
        \ 'on_complete': ['ncm2#on_complete#omni', 'vimtex#complete#omnifunc'],
        \ })

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

" Select 'chunks'
" vnoremap <buffer> ac ?\(^ *$\)\\|\(^ *\\end\)\\|\(^ *\\begin\)\\|\(^ *\\item\)<CR><Esc>V/<CR>k
" vnoremap <buffer> ic ?\(^ *$\)\\|\(^ *\\end\)\\|\(^ *\\begin\)\\|\(^ *\\item\)<CR>j<Esc>V/<CR>k
" omap <buffer> ac :normal Vac<CR>:noh<CR>
" omap <buffer> ic :normal Vic<CR>:noh<CR>

" complete mnras style citation commands (citet, citep, etc.)
" let g:vimtex_complete_patterns.bib='\C\\\a*cite[tp]\=\a*\*\?\(\[[^\]]*\]\)*\_\s*{[^{}]*'
