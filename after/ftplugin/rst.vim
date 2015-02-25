" For some reason if this is set to anything it disables spelling in the whole
" file
let g:rst_syntax_code_list = []

setlocal spell

" Allow the wrapping to mess with existing lines
setlocal formatoptions-=l

let b:wrapToggleFlag=0
call WrapToggle()

setlocal makeprg=make
nnoremap <buffer> <leader>s :w<CR>:make html<CR>
nnoremap <buffer> <leader>S :w<CR>:make clean; make html<CR>

nnoremap <buffer> <leader>m :silent !open -a Marked\ 2 '%:p'<cr>

setlocal comments+=fb:-

" Quick map for adding a new item to a list at the same level
imap <buffer>  <CR>-<Space><C-d>

setlocal nolist

inoremap ;- —
