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

au BufWinEnter *.md syn match markdownIgnore "\$\+.\{-}\n*.\{-}\$\+" "Don't use italics with underscore in math

" If writing a list, pressing enter will start new bullet
setlocal comments-=fb:-
setlocal comments+=nb:-\ [\ ]
setlocal comments+=nb:-
setlocal fo-=c
setlocal fo+=ron

" Select 'chunks'
vnoremap ac l?\(^ *-\)\\|\(^ *$\)<CR><Esc>V/<CR>k
vnoremap ic l?\(^ *-\)\\|\(^ *$\)<CR>j<Esc>V/<CR>k
omap ac :normal Vac<CR>:noh<CR>
omap ic :normal Vic<CR>:noh<CR>
