" setlocal tw=80 fo=cqt wm=0 colorcolumn=80
" let b:wrapToggleFlag=1

let g:solarized_contrast="normal"
let g:solarized_visibility="low"

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

nnoremap <buffer> <leader>m :silent !open -a Marked.app '%:p'<cr>
nnoremap <buffer> <leader>M :silent !paver -f $HOME/bin/pavement.py pandoc_github '%:p'<cr>
