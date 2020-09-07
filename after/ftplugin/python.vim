" Comply with PEP 8 and black (as far as possible)
setlocal expandtab
setlocal textwidth=120
setlocal tabstop=8
setlocal softtabstop=4
setlocal shiftwidth=4
setlocal noshowmode  " Allows jedi to show function call signatures
setlocal concealcursor=nic
setlocal nofoldenable  " Don't fold by default

" syntax hightlighting options
let g:python_highlight_all = 1

" Set some useful keybindings
nnoremap <buffer> <localleader>r :w<CR>:Dispatch python %<CR>
nnoremap <buffer> <localleader>f :w<CR>:!black -l120 %<CR>:e<CR>

" use lsp omnifunc for completion
setlocal omnifunc=v:lua.vim.lsp.omnifunc

" put an f infront of the current string and return to where we were
imap <M-f> <esc>?(["']<cr>af<esc>``la
