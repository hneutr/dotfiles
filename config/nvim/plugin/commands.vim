command! -nargs=? OpenFileSettings call lib#OpenFileSettings(<f-args>)

command! -nargs=0 TermVerticalSplit vspl|term
command! -nargs=0 TermHorizontalSplit spl|term
command! -nargs=0 TermTab tabnew|term

command! -nargs=0 TwoVerticalTerminals call lib#TwoVerticalTerminals()
