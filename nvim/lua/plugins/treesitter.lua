return {
    install_dir = vim.fn.stdpath('data') .. '/site',
    ensure_installed = {
        "lua",
        "python",
        "javascript",
        "markdown",
        "markdown_inline",
        "bash",
        "query",
    },
    sync_install = true,
    auto_install = true,

    highlight = {
        enable = true,
    },
    indent = {
        enable = true,
        -- disable = {'markdown', 'markdown_inline'},
    },
    incremental_selection = {
        enable = true,
    },
    textobjects = {
        enable = true,
    },
}
