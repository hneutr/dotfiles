# cd
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

# ls
alias lsa='ls -la'

# use nvim from within neovim-remote. This command triggers the BufFilePost
# autocmd so that numbering can be displayed properly. (and not conflict with
# other things that use BufEnter/BufWinEnter)
alias nvim="nvr -c 'doautocmd BufFilePost'"

# vim
alias vi="nvim"
alias vim="nvim"

# python
alias python="python3"
alias pip="pip3"

# ag
alias agl="ag -l"

# git
alias gs="git status"
