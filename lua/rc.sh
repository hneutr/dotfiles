# for information on luarocks config, see: https://github.com/mfussenegger/nlua
export HNE_LUA_LIBDIR="/opt/homebrew/lib/lua/5.1"

alias luarocks="luarocks --lua-version 5.1"
alias lt="luarocks test"
alias ltn="luarocks make && nlua"
