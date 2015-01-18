" setlocal tw=80 fo=cqt wm=0 colorcolumn=80
" let b:wrapToggleFlag=1

" let g:solarized_contrast="normal"
" let g:solarized_visibility="low"

" set lbr
setlocal spell 
" if has("gui_macvim")
    " setlocal background=light
    " let g:Powerline_colorscheme = "solarizedLight"
    " call Pl#ReloadColorscheme()
    " colorscheme colorful
" end

" Allow the wrapping to mess with existing lines
setlocal formatoptions-=l

nnoremap <buffer> <leader>m :silent !open -a Marked\ 2.app '%:p'<cr>
nnoremap <buffer> <leader>M :silent !paver -f $HOME/bin/pavement.py pandoc_github '%:p'<cr>

au BufWinEnter *.md setlocal conceallevel=0  "Prevents annoyances when using $$ style (pandoc) math

" If writing a list, pressing enter will start new bullet
setlocal comments-=fb:-
setlocal comments+=nb:-\ [\ ]
setlocal comments+=fb:-
setlocal fo-=c
setlocal fo+=ron

" Select 'chunks'
vnoremap <buffer> ac l?\(^ *-\)\\|\(^ *$\)<CR><Esc>V/<CR>k
vnoremap <buffer> ic l?\(^ *-\)\\|\(^ *$\)<CR>j<Esc>V/<CR>k
omap <buffer> ac :normal Vac<CR>:noh<CR>
omap <buffer> ic :normal Vic<CR>:noh<CR>

" toggle tasks as complete
function! ToggleComplete()
  let line = getline('.')
  if line =~ "^ *- \\[x\\]"
    s/^\( *\)- \[x\]/\1- \[ \]/
    s/ *\*\*done\*\*.*$//
  elseif line =~ "^ *- \\[ \\]"
    s/^\( *\)- \[ \]/\1- \[x\]/
    let text = " **done** (*" . strftime("%Y-%m-%d %H:%M") ."*)"
    exec "normal! A" . text
    normal! _
  endif
endfunc
nnoremap <buffer> = :call ToggleComplete()<cr>

" convert address to link
nmap <buffer> ,L yiWysiW]f]a(<ESC>pa)<ESC>

" Quick map for adding a new item to a list at the same level
imap <buffer>  <CR>-<Space><C-d>
