syn match pythonFuncCallName '[[:alpha:]_]\i*\s*('he=e-1 contains=pythonBuiltinFunc
syn match pythonFuncCallKW /\i*\ze\s*=[^=]/ contained

hi def link pythonClassMember Identifier
hi def link pythonFuncCallName Function
hi! link pythonBuiltinFunc Type
hi pythonFuncCallKW term=bold cterm=bold gui=bold

" show indentation
syn match leadingWS /\(^\(\s\{4}\)\+\)\@<=\s/ conceal cchar=⋮
hi! link Conceal NonText
