require'nvim-treesitter.configs'.setup {
  ensure_installed = { "lua", "python", "javascript" },
  sync_install = false,
  auto_install = true,

  highlight = {
    -- `false` will disable the whole extension
    enable = true,
    disable = { "lua", "python", "markdown", "markdown-inline" },
    additional_vim_regex_highlighting = true,
  },
}