return {
    ensure_installed = {
        "lua",
        "python",
        "javascript",
        "markdown",
        "markdown_inline",
        "bash",
    },
    sync_install = false,
    auto_install = true,

    highlight = {
        enable = true,
    },
    indent = {
        enable = true,
        disable = {'markdown', 'markdown_inline'},
    },
    incremental_selection = {
        enable = true,
    },
    textobjects = {
        enable = true,
        disable = {'markdown', 'markdown_inline'},
    },
}
