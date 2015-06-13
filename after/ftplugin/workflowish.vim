function! s:opensearchfolds(e)
    exec "normal! mqggzM:g/". a:e . "/normal! zv\<CR>`q"
endfunction

function! s:vimgrepkw(e)
    exec "normal! :lvimgrep /" . a:e . "/ %\<CR>:lopen\<CR>"
endfunction

function! ShowKWs(type, ...)
    let word = expand("<cWORD>")
    let grep_flag = 0
    if a:0 > 0
        let grep_flag = 1
    endif

    if a:type == 't'
        let regexp = '@\w\+'
    elseif a:type == 'c'
        let regexp = '#\w\+'
    else
        echoerr "Wrong type flag passed to NarrowFWFolds"
        return
    endif

    let sink = '<SID>opensearchfolds'
    if grep_flag == 1
        let sink = '<SID>vimgrepkw'
    endif

    if word =~ regexp
        exec 'call '.sink.'(word)'
    else
        call fzf#run({
                    \   'source':  'grep --line-buffered --color=never -roh "' . regexp . '" ' . fnameescape(@%) . ' | uniq',
                    \   'sink': function(sink)
                    \ })
    endif
endfunction

nnoremap <buffer><silent> <Localleader>nt :call ShowKWs('t')<CR>
nnoremap <buffer><silent> <Localleader>nc :call ShowKWs('c')<CR>
nnoremap <buffer><silent> <Localleader>nT :call ShowKWs('t', 1)<CR>
nnoremap <buffer><silent> <Localleader>nC :call ShowKWs('c', 1)<CR>

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
