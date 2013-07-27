" This causes considerable slowdown on ssh mounted drives.
let g:Powerline_colorscheme = 'mine'
if (exists('g:loaded_fugitive') && g:loaded_fugitive == 1)
    call Pl#Theme#RemoveSegment('fugitive:branch')
    call Pl#Theme#InsertSegment('winnumber:num', 'after', 'fileencoding') 
endif

" Get rid of annoying delay when leaving insert mode in terminal
if ! has('gui_running')
  set ttimeoutlen=10
  augroup FastEscape
    autocmd!
    au InsertEnter * set timeoutlen=0
    au InsertLeave * set timeoutlen=1000
  augroup END
endif

