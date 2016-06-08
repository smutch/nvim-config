hi def link mdTask Type
hi def link mdCompleteTask Comment
hi def link mdCancelledTask diffRemoved
hi def link mdContext Question
hi def link htmlHighlight DiffText
hi def link mdStrikethrough Comment
hi def link mdQuote Comment
hi link markdownBold MoreMsg
hi link markdownItalic JavascriptTry

hi clear markdownCodeBlock
hi link markdownCodeBlock Normal

" This is the best I can do until I can take a look at indentLines plugin 
" which keeps overriding this highlight group...
" let g:indentLine_color_term=109
" let g:indentLine_color_gui="#4271ae"
" " autocmd BufReadPost,BufNewFile *.md hi Conceal ctermfg=109 guifg=#4271ae

" if has("gui_macvim")
"     syn region htmlItalic matchgroup=htmlStyleDelim start="\\\@<!\*\S\@=" end="\S\@<=\\\@<!\*" keepend oneline concealends
"     syn region htmlItalic matchgroup=htmlStyleDelim start="\(^\|\s\)\@<=_\|\\\@<!_\([^_]\+\s\)\@=" end="\S\@<=_\|_\S\@=" keepend oneline concealends
" endif

" syn region htmlBold matchgroup=htmlStyleDelim start="\S\@<=\*\*\|\*\*\S\@=" end="\S\@<=\*\*\|\*\*\S\@=" keepend oneline concealends
" syn region htmlBold matchgroup=htmlStyleDelim start="\S\@<=__\|__\S\@=" end="\S\@<=__\|__\S\@=" keepend oneline concealends
" " syn region htmlBoldItalic matchgroup=htmlStyleDelim start="\S\@<=\*\*\*\|\*\*\*\S\@=" end="\S\@<=\*\*\*\|\*\*\*\S\@=" keepend oneline concealends
" " syn region htmlBoldItalic matchgroup=htmlStyleDelim start="\S\@<=___\|___\S\@=" end="\S\@<=___\|___\S\@=" keepend oneline concealends
" syn region htmlHighlight matchgroup=htmlStyleDelim start="{==" end="==}" keepend oneline concealends

syn match mdQuote "^ *>.*$"

syn region mdStrikethrough matchgroup=htmlStyleDelim start="\S\@<=\~\~\|\~\~\S\@=" end="\S\@<=\~\~\|\~\~\S\@=" keepend oneline concealends

syn cluster mkdNonListItem remove=htmlItalic,htmlBold,htmlBoldItalic,mkdFootnotes,mkdInlineURL,mkdLink,mkdLinkDef

" let s:concealends = has('conceal') ? ' concealends' : ''
" syn region htmlBold matchgroup=htmlBoldDelim concealends=''

" syn match mdSection "^#.* *$"
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
