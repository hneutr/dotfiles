# cd
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

# ls
alias lsa='ls -la'

# vim
alias vi="nvim"
alias vim="nvim"

# python
alias python="python3"
alias pip="pip3"

# ag
alias agl="ag -l"

# use nvim from within neovim-remote. This command triggers the BufEnter
# autocmd so that numbering can be displayed properly.
alias nvim="nvr --remote -s -c 'doautocmd BufEnter'"

# git
alias gs="git status"
