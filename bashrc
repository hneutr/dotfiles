#!/bin/bash

[ -f ~/.bashrc_local ] && source ~/.bashrc_local
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

################################################################################
# tmux_attach_or_reattach
# 
# Description:
#	If found a tmux session with the supplied name exists, reattaches it,
#	otherwise, creates one.
################################################################################
function tmux_attach_or_reattach {
	if [ $(tmux ls | grep -c "^$1:") -ge 1 ]; then
		tmux attach -t $1
	else
		tmux new -s $1
	fi
}

#-------tmux
alias a0="tmux_attach_or_reattach 0"
alias a1="tmux_attach_or_reattach 1"

################################################################################
# conf
# 
# Description:
#	function to source various conf files
################################################################################
function conf {
	# Get options
	OPTIND=1

	while getopts "lh?" opt; do
		case "$opt" in
			l)
				local suffix="_local"
				;;
			h|?)
				echo "l: open/source the local version of the profile"
				;;
		esac
	done

	shift $((OPTIND-1))

	[ "$1" = "--" ] && shift

	# open the file
	case $1 in
		rc)
			vim ~/.bashrc$suffix
			source ~/.bashrc$suffix 
			;;
		bp)
			vim ~/.bash_profile$suffix
			source ~/.bash_profile$suffix
			;;
		t)
			vim ~/.tmux.conf
			tmux source-file ~/.tmux.conf
			;;
		v)
			vim ~/.vimrc$suffix
			;;
		r)
			vim ~/.dotfiles/readme.md
			;;
		i)
			vim ~/.inputrc
			;;
	esac
}

###############################################################################
# starts fzf at directory (if specified) and echos the file selected
###############################################################################
function start_fzf_at_dir {
	local START_DIR
	if [ $# -eq 1 ]; then
		cd $1
		START_DIR=$1
	fi

	echo $START_DIR/$(fzf)
}

###############################################################################
# starts fzf at directory (if specified) and opens in vim
###############################################################################
function s {
	vim $(start_fzf_at_dir $@)
}

###############################################################################
# starts fzf at directory (if specified) and goes to parent directory of
# selected file
###############################################################################
function g {
	local DESTINATION=$(start_fzf_at_dir $@)
	if [ -d "$DESTINATION" ]; then
		cd $DESTINATION
	elif [ -f "$DESTINATION" ]; then
		cd $(dirname $DESTINATION)
	fi
}

