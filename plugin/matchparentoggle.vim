function! MatchParenToggle()
    if g:loaded_matchparen==1
        execute 'NoMatchParen'
        let g:loaded_matchparen=0
    else
        execute 'DoMatchParen'
        let g:loaded_matchparen=1
    endif
endfun
map ,sm :call MatchParenToggle()<CR>
