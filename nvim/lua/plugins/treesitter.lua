require('nvim-treesitter.configs').setup {
    ensure_installed = {
        "lua",
        "python",
        "javascript",
        "markdown",
        "markdown_inline",
        "bash"
    },
    sync_install = false,
    auto_install = true,

    highlight = {
        enable = true,
        additional_vim_regex_highlighting = true,
    },
    indent = {
        enable = true,
        disable = {'markdown', 'markdown_inline'},
    }
}

vim.api.nvim_set_hl(0, "@text.strong", {bold = true})
vim.api.nvim_set_hl(0, "@text.emphasis", {italic = true})
vim.api.nvim_set_hl(0, "@punctuation.special.markdown", {link = "Function"})
vim.api.nvim_set_hl(0, "@text.uri", {link = "string"})
vim.api.nvim_set_hl(0, "@text.strike.markdown_inline", {strikethrough = true})

vim.api.nvim_set_hl(0, "@text.title.1.markdown", {link = "Error"})
vim.api.nvim_set_hl(0, "@text.title.1.marker.markdown", {link = "Error"})
vim.api.nvim_set_hl(0, "@text.title.2.markdown", {link = "Constant"})
vim.api.nvim_set_hl(0, "@text.title.2.marker.markdown", {link = "Constant"})
vim.api.nvim_set_hl(0, "@text.title.3.markdown", {link = "Type"})
vim.api.nvim_set_hl(0, "@text.title.3.marker.markdown", {link = "Type"})
