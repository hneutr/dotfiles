autocmd BufRead,BufNewFile, *.pl,*.pm,*.esp set filetype=perl
autocmd BufRead,BufNewFile, *.pl,*.pm,*.esp call StripTrailingWhitespace()
