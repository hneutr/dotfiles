function venv_prompt_string() {
    local venv_prompt_string=""
    if [[ -n "$VIRTUAL_ENV" ]]; then
        # Strip the path out and leave the env name
        venv_prompt_string="(${VIRTUAL_ENV##*/}) "
        echo "(${VIRTUAL_ENV##*/}) "
    else
        echo ""
    fi
}
