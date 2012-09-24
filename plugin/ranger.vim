
" Ranger function
function! Ranger()
  if $VIRTUAL_ENV!=""
    silent !$VIRTUAL_ENV/bin/python $VIRTUAL_ENV/bin/ranger --choosefile=/tmp/chosen
  else
    silent !ranger --choosefile=/tmp/chosen
  endif
  if filereadable('/tmp/chosen')
    exec 'edit ' . system('cat /tmp/chosen')
    call system('rm /tmp/chosen')
  endif
  redraw!
endfun
map <leader>r :call Ranger()<CR>
