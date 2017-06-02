command! -nargs=0 Text call lib#UnstructuredText()
command! -nargs=+ -complete=file -bar Ag silent! grep! <args>|cwindow|redraw!
