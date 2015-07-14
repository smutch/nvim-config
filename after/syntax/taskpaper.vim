hi def tpHighPriority ctermfg=167 guifg=#fb4934
hi def tpTodayTask ctermfg=108 guifg=#8ec07c
hi def tpNextTask ctermfg=208 guifg=#fe8019
hi def tpInProgTask ctermfg=175 guifg=#d3869b
hi def tpHashTag cterm=bold ctermfg=214 gui=bold guifg=#fabd2f

" Note the order is important here... The last entries have priority over the
" first.
syn match tpHashTag '#\w*'
syn match tpTodayTask '^.*@today.*$' contains=taskpaperContext,taskpaperDone,tpHashTag
syn match tpInProgTask '^.*@inprog.*$' contains=taskpaperContext,taskpaperDone,tpHashTag
syn match tpNextTask '^.*@next.*$' contains=taskpaperContext,taskpaperDone,tpHashTag
syn match tpHighPriority '^.*\(@HIGH\|@high\).*$' contains=taskpaperContext,taskpaperDone,tpHashTag
