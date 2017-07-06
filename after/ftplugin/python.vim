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
nnoremap <buffer> <localleader>p :w<CR>:Dispatch python %<CR>

let b:repl_window = '1.0'
command! -range Send silent exec "<line1>,<line2>Twrite" b:repl_window "| Tmux send-keys -t" b:repl_window "M-Enter"
noremap <buffer><localleader>r :Send<CR>
