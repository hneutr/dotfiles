# fuzzy vim
bindkey -s '^V' "fvim\n"

# clear the screen
bindkey '^X'    clear-screen

# alt-. inserts last word
bindkey '\e.'   insert-last-word

# use the contents of the current line to search forward/backward
bindkey '^P'    up-line-or-search
bindkey '^N'    down-line-or-search

bindkey '\e.'   insert-last-word

bindkey '^A'    beginning-of-line
bindkey '^E'    end-of-line

bindkey '^D'    delete-char

bindkey '\ef'   forward-word
bindkey '\eb'   backward-word
