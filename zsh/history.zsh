if [ -z "$HISTFILE" ]; then
    HISTFILE=$HOME/.zsh_history
fi

HISTSIZE=10000
SAVEHIST=10000

setopt append_history
setopt extended_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_verify

# remove extraneous blanks from history
setopt hist_reduce_blanks

# add to history before shell exit
setopt inc_append_history

# share history across shells
setopt share_history
