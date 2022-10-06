require'nvim-treesitter.configs'.setup {
  ensure_installed = { "lua", "python", "javascript" },
  sync_install = false,
  auto_install = true,

  highlight = {
    -- `false` will disable the whole extension
    enable = false,
    disable = { "lua", "python", "markdown", "markdown-inline", "javascript", },
    additional_vim_regex_highlighting = true,
  },
}
