" Move lines up or down
function! MoveLineUp()
  call MoveLineOrVisualUp(".", "")
endfunction
function! MoveLineDown()
  call MoveLineOrVisualDown(".", "")
endfunction
function! MoveVisualUp()
  call MoveLineOrVisualUp("'<", "'<,'>")
  normal gv
endfunction
function! MoveVisualDown()
  call MoveLineOrVisualDown("'>", "'<,'>")
  normal gv
endfunction
function! MoveLineOrVisualUp(line_getter, range)
  let l_num = line(a:line_getter)
  if l_num - v:count1 - 1 < 0
    let move_arg = "0"
  else
    let move_arg = a:line_getter." -".(v:count1 + 1)
  endif
  call MoveLineOrVisualUpOrDown(a:range."move ".move_arg)
endfunction
function! MoveLineOrVisualDown(line_getter, range)
  let l_num = line(a:line_getter)
  if l_num + v:count1 > line("$")
    let move_arg = "$"
  else
    let move_arg = a:line_getter." +".v:count1
  endif
  call MoveLineOrVisualUpOrDown(a:range."move ".move_arg)
endfunction
function! MoveLineOrVisualUpOrDown(move_arg)
  let col_num = virtcol(".")
  execute "silent! ".a:move_arg
  execute "normal! ".col_num."|"
endfunction
nnoremap <silent> <C-k> :<C-u>call MoveLineUp()<CR>
nnoremap <silent> <C-j> :<C-u>call MoveLineDown()<CR>
xnoremap <silent> <C-k> :<C-u>call MoveVisualUp()<CR>
xnoremap <silent> <C-j> :<C-u>call MoveVisualDown()<CR>

" mapping to make movements operate on 1 screen line in wrap mode
function! ScreenMovement(movement)
  if !exists("b:gmove")
    let b:gmove = "yes"
  endif
  if &wrap && b:gmove == 'yes'
    return "g" . a:movement
  else
    return a:movement
  endif
endfunction
nnoremap <silent> <expr> k ScreenMovement("k")
nnoremap <silent> <expr> j ScreenMovement("j")
function! TYShowBreak()
  if &showbreak == ''
    set showbreak=>
  else
    set showbreak=
  endif
endfunction
