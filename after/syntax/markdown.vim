hi def link mdTask Identifier
hi def link mdCompleteTask Comment
hi def link mdImportant Special

syn match mdImportant "<imp>"
syn match mdTask "^ *- \[ \].*" contains=mdImportant
syn match mdCompleteTask "^ *- \[x\].*" contains=mdImportant
