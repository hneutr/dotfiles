# ls
alias lsl='ls -l'
alias lsla='ls -la'
alias lsf='ls -p | grep -v /'
alias lsfa='ls -pa | grep -v /'
alias ls1='ls -1'

# mv
alias rmv='$(which mv)'

# tree
alias lst='tree --git-ignore -I .git\|.gitignore'

# vim
alias nvim=$NVIM_PATH
alias vi="nvim"
alias vim="nvim"
# alias gv="vim -c 'GoyoToggle' "
alias term="nvim -c term"

# python
alias python="python3"
alias pip="pip3"
alias ipy="ipython"

# git
alias gs="git status"
alias ga="git add"
alias gc="git commit"
alias gp="git push"
alias gd="git diff"
alias gctd="git commit -m $(today)"
alias gptd="ga .; gc -m $(today); gp"

# misc
alias po="popen"

# lua
alias lua="lua5.1"
alias lm="luarocks make &> /dev/null && lua "
