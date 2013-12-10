" We will use Ack only if The Silver Searcher isn't available
if !executable('ag')

    " Map keys for Ack
    nmap <leader>A <Esc>:Ack! 

    " Ack for current word under cursor
    nmap <leader>w yiw<Esc>:Ack! <C-r>"<CR>

endif
