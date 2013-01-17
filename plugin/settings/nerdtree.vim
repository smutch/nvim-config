" Let NERDTree ignore certain filetypes
let NERDTreeIgnore=['\.o$', '\~$', '^_', '\.tmproj$', '^\..*', '\.bbl$', 
            \'\.blg$', '\.fdb*$', '\.fls$', '\.synctex*$', '\.latexmain$',
            \'\.bst$']

let NERDTreeQuitOnOpen=0
let NERDTreeShowHidden=1
let NERDTreeHijackNetrw = 1

nmap <silent> <leader>N :NERDTreeToggle<CR>
