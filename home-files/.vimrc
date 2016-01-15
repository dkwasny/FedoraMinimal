set background=dark

" Git commit does not work with the solarized color scheme
if $_ == 'git commit'
	colorscheme desert
else
	colorscheme solarized
endif
