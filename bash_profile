###############################################
# General settings
###############################################
export EDITOR=vim

if [ -d ~/.config/nvim/ ]; then
	alias vim="nvim"
	export EDITOR=nvim
fi

[ -f ~/.bash_profile_local ] && source ~/.bash_profile_local
[ -f ~/.bashrc ] && source ~/.bashrc
