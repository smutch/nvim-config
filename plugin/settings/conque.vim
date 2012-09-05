" ConqueTerm settings

augroup MyConqueTerm
  autocmd!
  " start Insert mode on BufEnter
  autocmd BufEnter *
        \ if &l:filetype ==# 'conque_term' |
        \   startinsert! |
        \ endif
  autocmd BufLeave *
        \ if &l:filetype ==# 'conque_term' |
        \   stopinsert! |
        \ endif
augroup END

let g:ConqueTerm_Color         = 1
let g:ConqueTerm_TERM          = 'xterm-256color'
let g:ConqueTerm_Syntax        = 'conque'
let g:ConqueTerm_ReadUnfocused = 1
let g:ConqueTerm_CWInsert      = 1

nnoremap <silent><leader>C <Esc>:ConqueTermSplit zsh<CR><Esc>:set wfh<CR>i
