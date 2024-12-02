# clear the screen
bindkey '^X'    clear-screen

# alt-.
bindkey '\e.'   insert-last-word

# use the contents of the current line to search forward/backward
bindkey '^P'    up-line-or-search
bindkey '^N'    down-line-or-search

bindkey '\e.'   insert-last-word

bindkey '^A'    beginning-of-line
bindkey '^E'    end-of-line

bindkey '^D'    delete-char

# alt-LeftArrow
bindkey "^[[1;3D" backward-word
# alt-RightArrow
bindkey "^[[1;3C" forward-word

# open vsplit terminals
bindkey -s '^[t' "vsplit_terms\n"

# fuzzy vim
bindkey ^v fuzzyvim
