" This causes considerable slowdown on ssh mounted drives.

let g:Powerline_colorscheme = 'mine'
if (exists('g:loaded_fugitive') && g:loaded_fugitive == 1)
    call Pl#Theme#RemoveSegment('fugitive:branch')
    call Pl#Theme#InsertSegment('winnumber:num', 'after', 'fileencoding') 
endif
