export PATH="$HOME/.luarocks/bin:$PATH"
# for information on luarocks config, see: https://github.com/mfussenegger/nlua
alias luarocks="luarocks --lua-version 5.1"
alias lt="luarocks test"
eval "$(luarocks path)"
