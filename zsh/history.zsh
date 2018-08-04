if [ -z "$HISTFILE" ]; then
    HISTFILE=$HOME/.zsh_history
fi

HISTSIZE=10000
SAVEHIST=10000

setopt APPEND_HISTORY

setopt EXTENDED_HISTORY

setopt HIST_EXPIRE_DUPS_FIRST

# setopt hist_ignore_space
setopt HIST_VERIFY

# Do not display a line previously found.
setopt HIST_FIND_NO_DUPS

# Remove superfluous blanks before recording entry.
setopt HIST_REDUCE_BLANKS

# Don't write duplicate entries in the history file.
setopt HIST_SAVE_NO_DUPS

# remove extraneous blanks from history
setopt HIST_REDUCE_BLANKS

# add to history before shell exit
setopt INC_APPEND_HISTORY

# share history across shells
setopt SHARE_HISTORY
