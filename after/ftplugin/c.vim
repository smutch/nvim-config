setlocal expandtab
setlocal shiftwidth=2
setlocal softtabstop=2
setlocal tabstop=2
setlocal number

" Save then compile
nmap <buffer> [compile]c :w<CR>:Make<CR>
