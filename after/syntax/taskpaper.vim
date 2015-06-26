hi def tpHighPriority ctermfg=167 guifg=#fb4934
hi def tpTodayTask ctermfg=108 guifg=#8ec07c
hi def tpInProgTask ctermfg=175 guifg=#d3869b

" Note the order is important here... The last entries have priority over the
" first.
syn match tpTodayTask '^.*@today.*$' contains=taskpaperContext,taskpaperDone
syn match tpInProgTask '^.*@inprog.*$' contains=taskpaperContext,taskpaperDone
syn match tpHighPriority '^.*\(@HIGH\|@high\).*$' contains=taskpaperContext,taskpaperDone
