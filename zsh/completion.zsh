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
compinit

# add a space on tab complete. not really doing what I want yet
zstyle ':completion:*' add-space true
