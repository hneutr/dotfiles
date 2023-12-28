local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    -- colorscheme
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        config = lrequire("plugins.catppuccin"),
    },

    -- treesitter
    {'nvim-treesitter/nvim-treesitter', config = lrequire('plugins.treesitter')},

    -- find things
    'junegunn/fzf',
    {
        'ibhagwan/fzf-lua',
        config = lrequire('plugins.fzf-lua'),
        keys = {{"<leader>df", function() require('fzf-lua').files() end}},
    },

    -- zen mode
    {
        'folke/zen-mode.nvim',
        opts = require("plugins.zen-mode"),
        keys = {{"<leader>dz", "<cmd>ZenMode<cr>"}},
    },

    -- manage tabs
    {'hneutr/nvimux', config = lrequire('plugins.nvimux')},

    -- highlight searches
    'hneutr/vim-cool',

    -- 2char motions
    {'justinmk/vim-sneak', config = lrequire('plugins.sneak')},

    -- text objects
    {'wellle/targets.vim'},

    -- snippets
    {"L3MON4D3/LuaSnip", config = lrequire("plugins.luasnip")},

    -- surround things
    {"kylechui/nvim-surround", config = lrequire('plugins.nvim-surround')},

    -- open/close pairs
    {'windwp/nvim-autopairs', config = lrequire('plugins.autopairs')},

    -- comment things
    'tpope/vim-commentary',

    -- align things
    {'junegunn/vim-easy-align'},

    -- paired options
    'tpope/vim-unimpaired',

    -- paste without modifying registers
    'vim-scripts/ReplaceWithRegister',

    -- move things up/down
    {'zirrostig/vim-schlepp', init = lrequire("plugins.schlepp")},

    -- cycle true/false, etc
    {'monaqa/dial.nvim', config = lrequire('plugins.dial')},
    
    -- personal library
    {dir = "~/lib/hnetxt-lua"},
})
