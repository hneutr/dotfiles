# ls
alias lsl='ls -l'
alias lsla='ls -la'
alias lsf='ls -p | grep -v /'
alias lsfa='ls -pa | grep -v /'

# exa
[[ ! -z $(which exa) ]] && alias ls='exa --git --header --group'
[[ ! -z $(which exa) ]] && alias lsla='exa --long --git -a --header --group'
[[ ! -z $(which exa) ]] && alias tree='exa --tree --level=2 --long -a --header --git'

# tree
alias lst='tree --git-ignore -I .git\|.gitignore'

# vim
alias nvim=$NVIM_PATH
alias vi="nvim"
alias vim="nvim"
alias gv="vim -c 'Goyo' "
alias gvt="vim -c 'Goyo' text.md"

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

# fd
[[ ! -z $(which fd) ]] && alias find='fd'

# rg
[[ ! -z $(which rg) ]] && alias rgl="rg -l"

# writing
alias journal='_journal "journal = '"'"'catch all'"'"'"'
alias pjournal='_journal "set_config = true"'
alias wjournal='_journal "journal = '"'"'on writing'"'"'"'
