" function! SassToCss()
"   let current_file = shellescape(expand('%:p'))
"   let filename = shellescape(expand('%:r'))
"   let command = "silent !sass " . current_file . " " . filename . ".css"
"   execute command
" endfunction
" autocmd BufWritePost,FileWritePost *.scss call SassToCss()

setlocal fdm=marker
setlocal foldmarker={,}
