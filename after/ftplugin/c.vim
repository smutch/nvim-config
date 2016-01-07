setlocal expandtab
setlocal shiftwidth=2
setlocal softtabstop=2
setlocal tabstop=2
setlocal number

" Save then compile
" if !has("nvim")
    nmap <buffer> [compile/comment]x :w<CR>:Make<CR>
" else
"     " Note that this is redundant as Neomake is currently been set to run
"     " automatically upon save of *.c and *.h files.
"     nmap <buffer> [compile/comment]x :w<CR>:Neomake!<CR>
" endif
