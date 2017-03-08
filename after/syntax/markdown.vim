hi def link mdTask Type
hi def link mdCompleteTask Comment
hi def link mdCancelledTask diffRemoved
hi def link mdContext Question
hi def link htmlHighlight DiffText
hi def link mdStrikethrough Comment

syn region mdStrikethrough matchgroup=htmlStyleDelim start="\S\@<=\~\~\|\~\~\S\@=" end="\S\@<=\~\~\|\~\~\S\@=" keepend oneline concealends

syn match mdLine "^----*"

syn match mdTask "^ *- \[ \].*$" contains=mdCheckbox
syn match mdCheckbox "- \[ \]" contained containedin=mdTask conceal cchar=☐

syn match mdCompleteTask "^ *- \[x\].*$" contains=mdCompleteMark
syn match mdCompleteTask "\(^ *[\*-] \)\@!.*@done.*$"
syn match mdCompleteMark "- \[x\]" contained containedin=mdCompleteTask conceal cchar=☑︎

syn match mdCancelledTask "^ *- X.*$" contains=mdCancelMark
syn match mdCancelMark "- X" contained containedin=mdCancelledTask conceal cchar=✗

syn match mdContext "@[^ ]*" containedin=ALL

syn match mdItem "^ *[\*-]\( X \| \[[x ]\]\)\@! " contains=mdBullet
syn match mdBullet "[\*-]" contained containedin=mdItem conceal cchar=●
syn region mdIgnore start="\S\@<=\$\|\$\S\@=" end="\S\@<=\$\|\$\S\@=" keepend oneline concealends
