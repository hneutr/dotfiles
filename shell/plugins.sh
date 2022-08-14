# stupid fzf wouldn't search my documents directory
[[ ! -z $(which rg) ]] && export FZF_DEFAULT_COMMAND="rg --files --hidden --glob '!.git/*'"
[[ ! -z $(which bfs) ]] && export FZF_ALT_C_COMMAND="bfs -type d -nohidden 2>/dev/null -exclude -name journals"
