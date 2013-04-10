let g:Powerline#Segments#winnumber#segments = Pl#Segment#Init(['winnumber',
	\ (exists('g:loaded_fugitive') && g:loaded_fugitive == 1),
	\
	\ Pl#Segment#Create('num', 'win %{WindowNumber()}')
\ ])
