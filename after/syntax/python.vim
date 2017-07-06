syn region pythonFuncCall matchgroup=pythonFuncCallName start='[[:alpha:]_]\i*\s*('rs=e-1 end=')'re=e+1 contains=ALLBUT,pythonBytesContent,pythonBytesError,pythonFunction,pythonDottedName
syn match pythonFuncCallKW /\i*\ze\s*=[^=]/ contained

hi def link pythonClassMember Identifier
hi def link pythonFuncCallName Function
hi pythonFuncCallKW term=bold cterm=bold gui=bold

" show indentation
syn match leadingWS /\(^\(\s\{4}\)\+\)\@<=\s/ conceal cchar=|
hi! link Conceal NonText
