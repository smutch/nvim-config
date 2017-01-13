" Comply with PEP 8 (as far as possible)
setlocal expandtab
setlocal textwidth=79
setlocal tabstop=8
setlocal softtabstop=4
setlocal shiftwidth=4
setlocal autoindent
setlocal number
setlocal noshowmode  " Allows jedi to show function call signatures
setlocal concealcursor=nic

" Set some useful keybindings
nmap <buffer> <localleader>s :w<CR>:SyntasticCheck<CR>
if has("gui_macvim")
    nmap <buffer> <localleader>p :w<CR>:Dispatch /usr/local/bin/python %<CR>
else
    nmap <buffer> <localleader>p :w<CR>:Dispatch python %<CR>
endif

" " Load indentline plugin
" let g:loaded_indentLine = 1
