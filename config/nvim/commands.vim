command! -nargs=+ -complete=file -bar Rg silent! grep! <args>|cwindow|redraw!

command! -nargs=0 Text call lib#UnstructuredText()

command! -nargs=1 -complete=help H call lib#ShowHelp(<f-args>)

command! -nargs=? OpenFileSettings call lib#OpenFileSettings(<f-args>)
