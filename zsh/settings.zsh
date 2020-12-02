# beep sucks
setopt no_beep

# no beep for autocomplete
setopt no_list_beep

################################################################################
# History
################################################################################
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

################################################################################
# Completion
################################################################################
# show completions automatically
setopt auto_list

# complete alisases
setopt completealiases

# spelling correction for commands
setopt correct

# hash everything before completion
setopt hash_list_all

# complete as much of a completion until it gets ambiguous.
setopt list_ambiguous           

# init completion
autoload -Uz compinit
# completion is slow
if [ $(date +'%j') != $(stat -f '%Sm' -t '%j' ~/.zcompdump) ]; then
  compinit
else
  compinit -C
fi

# add a space on tab complete. not really doing what I want yet
zstyle ':completion:*' add-space true

# interactive prompt (changes on cd/etc)
setopt prompt_subst
