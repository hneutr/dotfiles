require('util')
require('util.tbl')

vim.g.vim_config = _G.joinpath(vim.env.HOME, '.config/nvim/')

require('settings')
require('mappings')
require('plugins')
