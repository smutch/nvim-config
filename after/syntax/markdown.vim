hi def link mdTask Identifier
hi def link mdCompleteTask Comment
hi def link mdImportant Special

syn match mdImportant "<imp>"
syn match mdTask "^ *- \[ \].*" contains=mdImportant
syn match mdCompleteTask "^ *- \[x\].*" contains=mdImportant

" syn match markdownIgnore "\$\+.\{-}\n*.\{-}\$\+" "Don't use italics with underscore in math
highlight link markdownItalic markdownIgnore
