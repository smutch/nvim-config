hi def link mdTask Identifier
hi def link mdCompleteTask Comment
hi def link mdImportant Special
hi def link mdTag Todo

syn match mdImportant "<imp>"
syn match mdTask "^ *- \[ \].*" contains=mdImportant,mdTag
syn match mdCompleteTask "^ *- \[x\].*" contains=mdImportant,mdCompleteMark
syn match mdCompleteMark "\[x\]" conceal cchar=✔
syn match mdTag "@inprog" contained containedin=mdTask
syn match mdTag "@high" contained containedin=mdTask
syn match mdTag "@today" contained containedin=mdTask

" syn match markdownIgnore "\$\+.\{-}\n*.\{-}\$\+" "Don't use italics with underscore in math
highlight link markdownItalic markdownIgnore
