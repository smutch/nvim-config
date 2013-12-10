" We will use only if The Silver Searcher is available
if executable('ag')

    " Map keys for Ag
    nmap <leader>A <Esc>:Ag! 

    " Ag for current word under cursor
    nmap <leader>w yiw<Esc>:Ag! <C-r>"<CR>

endif
