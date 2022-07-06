" Comply with PEP 8 and black (as far as possible)
setlocal expandtab
setlocal textwidth=120
setlocal tabstop=8
setlocal softtabstop=4
setlocal shiftwidth=4
setlocal noshowmode  " Allows jedi to show function call signatures
setlocal concealcursor=nic
" setlocal nofoldenable  " Don't fold by default

" syntax hightlighting options
let g:python_highlight_all = 1

" Set some useful keybindings
nnoremap <buffer> <localleader>R :w<CR>:Dispatch python %<CR>
" nnoremap <buffer> <localleader>f :w<CR>:!cmd=(); if [ -e poetry.lock ]; then cmd+=(poetry run); fi && "${cmd[@]}" isort --profile black % && "${cmd[@]}" black %<CR>:e<CR>
" nnoremap <buffer> <localleader>F :w<CR>:!black -l 120 % && isort -l 120 %<CR>:e<CR>
" nnoremap <buffer> <localleader>u :UltestNearest<CR>
" nnoremap <buffer> <localleader>U :Ultest<CR>
" nnoremap <buffer> <localleader>s :UltestSummary<CR>

" use lsp omnifunc for completion
setlocal omnifunc=v:lua.vim.lsp.omnifunc

" put an f infront of the current string and return to where we were
imap <M-f> <esc>?(["']<cr>af<esc>``la

" let g:neomake_python_enabled_makers = ["flake8"]
