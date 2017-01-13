syn keyword pythonClassMember self
syn match pythonComparisonOps /[<>=]=\|[&|><]\+/
syn region pythonFuncCall matchgroup=pythonFuncCallName start='[[:alpha:]_]\i*\s*('rs=e-1 end=')'re=e+1 contains=ALLBUT,pythonFunction
syn match pythonFuncCallKW /\i*\ze\s*=[^=]/ contained

hi def link pythonClassMember Identifier
hi def link pythonFuncCallName Function
hi def link pythonComparisonOps Operator
hi pythonFuncCallKW term=bold cterm=bold gui=bold

" show indentation
syn match leadingWS /\(^\(\s\{4}\)\+\)\@<=\s/ conceal cchar=⋮
" hi! def link leadingWS WarningMsg
" hi! Conceal ctermfg=237 guifg=#425059 ctermbg=NONE guibg=NONE
hi! link Conceal NonText
