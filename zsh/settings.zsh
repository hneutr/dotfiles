# beep sucks
setopt no_beep

# no beep for autocomplete
setopt no_list_beep

# set bindkey delay to 10ms
export KEYTIMEOUT=1
#------------------------------------------------------------------------------#
#                                   history                                    #
#------------------------------------------------------------------------------#
# make a history file if there isn't one
[[ -z "$HISTFILE" ]] && export HISTFILE=$HOME/.zsh_history

HISTSIZE=10000
SAVEHIST=10000

setopt APPEND_HISTORY

setopt EXTENDED_HISTORY

setopt HIST_EXPIRE_DUPS_FIRST

setopt HIST_VERIFY

# do not display a line previously found.
setopt HIST_FIND_NO_DUPS

# remove superfluous blanks before recording entry.
setopt HIST_REDUCE_BLANKS

# don't write duplicate entries in the history file.
setopt HIST_SAVE_NO_DUPS

# remove extraneous blanks from history
setopt HIST_REDUCE_BLANKS

# add to history before shell exit
setopt INC_APPEND_HISTORY

# share history across shells
setopt SHARE_HISTORY

#------------------------------------------------------------------------------#
#                                  completion                                  #
#------------------------------------------------------------------------------#
# show completions automatically
setopt auto_list

# setopt completealiases

# spelling correction for commands
setopt correct

# hash everything before completion
setopt hash_list_all

# complete as much of a completion until it gets ambiguous.
setopt list_ambiguous           

# add completion dir
fpath=($DOTFILES/zsh/site-functions $DOTFILES/zsh/site-functions/htc $fpath)

# init completion
autoload -Uz compinit

# completion is slow
for dump in ~/.zcompdump(N.mh+24); do
  compinit
done
compinit -C

# add a space on tab complete. not really doing what I want yet
zstyle ':completion:*' add-space true

# interactive prompt (changes on cd/etc)
setopt prompt_subst
