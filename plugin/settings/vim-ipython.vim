let g:ipy_perform_mappings = 0
let g:ipy_completefunc = 'local'  "IPython completion for local buffer only

map <silent> <F5> :python run_this_file()<CR>
map <silent> <S-F5> :python run_this_line()<CR>
map <silent> <F9> :python run_these_lines()<CR>
map <silent> ,pd :py get_doc_buffer()<CR>
map <silent> ,ps :py if update_subchannel_msgs(force=True): echo("vim-ipython shell updated",'Operator')<CR>
map <silent> <S-F9> :python toggle_reselect()<CR>
imap <C-F5> <C-O><F5>
imap <S-F5> <C-O><S-F5>
imap <silent> <F5> <C-O><F5>
map <C-F5> :call <SID>toggle_send_on_save()<CR>

"pi custom
map <silent> <C-Return> :python run_this_file()<CR>
map <silent> <C-s> :python run_this_line()<CR>
imap <silent> <C-s> <C-O>:python run_this_line()<CR>
map <silent> <M-s> :python dedent_run_this_line()<CR>
vmap <silent> <C-S> :python run_these_lines()<CR>
vmap <silent> <M-s> :python dedent_run_these_lines()<CR>
map <silent> <M-c> I#<ESC>
vmap <silent> <M-c> I#<ESC>
map <silent> <M-C> :s/^\([ \t]*\)#/\1/<CR>
vmap <silent> <M-C> :s/^\([ \t]*\)#/\1/<CR>
