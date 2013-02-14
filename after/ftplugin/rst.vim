" Allow the wrapping to mess with existing lines
setlocal formatoptions-=l

let b:wrapToggleFlag=0
call WrapToggle()

setlocal makeprg=make
nnoremap <buffer> <leader>s :w<CR>:make html<CR>
nnoremap <buffer> <leader>S :w<CR>:make clean; make html<CR>

nnoremap <buffer> <leader>m :silent !open -a Marked.app '%:p'<cr>
