setlocal tw=80 fo=cqt wm=0 colorcolumn=80
let b:wrapToggleFlag=1

let g:solarized_contrast="normal"
let g:solarized_visibility="low"

" set lbr
set spell 
if has("gui_macvim")
    set background=light
    " colorscheme colorful
end

" Allow the wrapping to mess with existing lines
setlocal formatoptions-=l
