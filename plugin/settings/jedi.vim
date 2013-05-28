let g:jedi#auto_initialization = 1
let g:jedi#popup_on_dot = 0
let g:jedi#show_function_definition = 1  "May be too slow...
autocmd  FileType python let b:did_ftplugin = 1

" Binding to show pydoc
let g:jedi#get_definition_command = "<leader>D"
nnoremap <leader>d :call jedi#show_pydoc()<CR>
