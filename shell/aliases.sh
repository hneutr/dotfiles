# cd
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

# ls
alias lsl='ls -l'
alias lsla='ls -la'
alias lsf='ls -p | grep -v /'
alias lsfa='ls -pa | grep -v /'

# vim
alias vi="nvim"
alias vim="nvim"
alias gv="nvim -c 'Goyo' "
alias gvt="nvim -c 'Goyo' text.md"

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
alias gctd="git commit -m $TD"
alias gptd="ga .; gctd; gp"

# misc
alias po="popen"

# exa
[[ ! -z $(which exa) ]] && alias ls='exa --git --header --group'
[[ ! -z $(which exa) ]] && alias lsla='exa --long --git -a --header --group'
[[ ! -z $(which exa) ]] && alias tree='exa --tree --level=2 --long -a --header --git'

# fd
[[ ! -z $(which fd) ]] && alias find='fd'

# rg
[[ ! -z $(which rg) ]] && alias rgl="rg -l"

# writing stuff
alias wr=edit-file-and-outline
alias j="gv $(hnetext journal)"
alias J="gv $(hnetext journal -j on-writing)"
alias pmv=writing-project-move
alias todir=writing-project-file-to-directory
alias mtof=writing-project-marker-to-file
alias mtodir=writing-project-marker-to-dir
alias mmv=writing-project-move-marker
