function! s:countdown_due_date(due_tag)
let l:due_date = substitute(a:due_tag, '@due(\([0-9\-]*\).*', '\1', '')
py << EOF
import arrow
date = arrow.get(vim.eval("l:due_date")).humanize()
print date
vim.command("let l:countdown = '"+date+"'")
EOF
return '@due('.l:due_date.'| '.l:countdown.')'
endfunction

command! -range=% CountdownDueDates exec "normal! m'" | silent! <line1>,<line2>s/\(@due([^)]*)\)/\=s:countdown_due_date(submatch(1))/ | noh | exec "normal! ''"
nnoremap <localleader>tu :CountdownDueDates<CR>

command! TaskpaperToggleDone call taskpaper#delete_tag('today') | call taskpaper#delete_tag('inprog') | call taskpaper#toggle_tag('done', taskpaper#date())
nnoremap <buffer> <localleader>td :TaskpaperToggleDone<CR>
nmap <buffer> <localleader><localleader> :TaskpaperToggleDone<CR>

command! TaskpaperDeadlineSearch call taskpaper#search('\v^(.*\@due.*|.*\@today.*)&(.*\@done.*)@!.*')
nnoremap <buffer> <localleader>tU :TaskpaperDeadlineSearch<CR>
