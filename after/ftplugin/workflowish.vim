function! s:opensearchfolds(e)
    exec "normal! mqggzM:g/". a:e . "/normal! zv\<CR>`q"
endfunction

function! NarrowKWFolds(type)
    let word = expand("<cWORD>")

    if a:type == 't'
        let regexp = '@\w\+'
    elseif a:type == 'c'
        let regexp = '#\w\+'
    else
        echoerr "Wrong type flag passed to NarrowFWFolds"
        return
    endif

    if word =~ regexp
        call <SID>opensearchfolds(word)
    else
        call fzf#run({
                    \   'source':  'grep --line-buffered --color=never -roh "' . regexp . '" ' . fnameescape(@%) . ' | uniq',
                    \   'sink': function('<SID>opensearchfolds')
                    \ })
    endif
endfunction

nnoremap <buffer><silent> <Localleader>nt :call NarrowKWFolds('t')<CR>
nnoremap <buffer><silent> <Localleader>nc :call NarrowKWFolds('c')<CR>

function! ToggleDone()
    let marker = matchstr(getline("."), "^\\W*[#*-]")
    if empty(marker)
        return
    elseif marker =~ '-'
        exec "normal! :.s/^\\(\\W*\\)-/\\1*\<CR>"
    else
        exec "normal! :.s/^\\(\\W*\\)[#*]/\\1-\<CR>"
    endif
endfunction

nnoremap <buffer><silent> <Localleader><CR> :call ToggleDone()<CR>
