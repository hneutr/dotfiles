" Test statement
iabbrev #T TEST<cr><cr>END<esc>,cckk,ccjk

" Dumper statement
iabbrev wdd use Data::Dumper 'Dumper';<cr>warn "\n\n" . Dumper() . "\n\n";<esc>F(a
iabbrev pdd use Data::Dumper 'Dumper';<cr>print "\n\n" . Dumper() . "\n\n";<esc>F(a

"sqltemplate
iabbrev sqltemplate SQL->Select(<cr>)->From(<cr>)->Where(<cr>);

" function declaration
iabbrev FUNC <esc>80i#<esc>
	\yyp
	\O
	\<cr>
	\<cr>
	\ Description:<cr>
	\<cr>
	\Parameters:<cr>
	\	Required:<cr>
	\	<bs>Optional:<cr>
	\<bs><cr>
	\ Returns:
	\<esc>8kA

" smallfunction declaration
iabbrev SFUNC <esc>80i#<esc>
	\yyp
	\O
	\ See:

" testfunction declaration
iabbrev UTEST <esc>80i#<esc>
	\yyp
	\O Tests:
	\<cr>-
