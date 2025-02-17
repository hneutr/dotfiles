local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'

if not vim.uv.fs_stat(lazypath) then
    vim.fn.system({
        'git',
        'clone',
        '--filter=blob:none',
        '--branch=stable',
        'https://github.com/folke/lazy.nvim.git',
        lazypath
    })
end

vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
    spec = {
        -- Some colorscheme
        {
            "catppuccin/nvim",
            lazy = false,
            name = "catppuccin",
            priority = 1000,
            opts = require("plugins.catppuccin"),
            config = function() vim.cmd.colorscheme("catppuccin") end,
        },

        -- treesitter
        {
            'nvim-treesitter/nvim-treesitter',
            build = ':TSUpdate',
            opts = require("plugins.treesitter"),
            main = "nvim-treesitter.configs",
        },

        -- open things from :term in the parent nvim
        {
            "willothy/flatten.nvim",
            config = true,
            lazy = false,
            priority = 1001,
        },

        -- sqlite
        "kkharji/sqlite.lua",

        -- fuzzy search
        'junegunn/fzf',

        {
            'ibhagwan/fzf-lua',
            config = lrequire('plugins.fzf-lua'),
            keys = {{"<leader>df", function() require('fzf-lua').files() end}},
        },

        -- search highlighting
        'hneutr/vim-cool',

        -- 2char motions
        {
            'justinmk/vim-sneak',
            init = lrequire("plugins.sneak"),
            keys = {
                {'s', '<Plug>Sneak_s', remap = true},
                {'S', '<Plug>Sneak_S', remap = true},
                {'f', '<Plug>Sneak_f', remap = true, mode = {"n", "x"}},
                {'F', '<Plug>Sneak_F', remap = true, mode = {"n", "x"}},
                {'t', '<Plug>Sneak_t', remap = true, mode = {"n", "x"}},
                {'T', '<Plug>Sneak_T', remap = true, mode = {"n", "x"}},
            },
        },

        -- text objects
        'wellle/targets.vim',

        -- snippets
        {
            "L3MON4D3/LuaSnip",
            config = lrequire("plugins.luasnip"),
        },

        -- surround stuff
        {
            "kylechui/nvim-surround",
            config = lrequire('plugins.nvim-surround'),
        },

        -- open/close pairs
        {
            'windwp/nvim-autopairs',
            commit = "9fd4118",
            config = lrequire('plugins.autopairs'),
        },

        {
            'junegunn/vim-easy-align',
            keys = {{"ga", "<Plug>(EasyAlign)", mode = {"n", "x"}}}
        },

        -- paired options
        'tpope/vim-unimpaired',

        -- paste without changing registers
        'vim-scripts/ReplaceWithRegister',

        -- move things up/down
        {
            'zirrostig/vim-schlepp',
            config = lrequire("plugins.schlepp"),
            keys = {
                {"<up>", "<Plug>SchleppUp", mode = "v"},
                {"<down>", "<Plug>SchleppDown", mode = "v"},
            },
        },

        -- cycle stuff
        {
            'monaqa/dial.nvim',
            config = lrequire('plugins.dial'),
        },

        -- icons
        {
            'echasnovski/mini.icons',
            version = '*',
            opts = {style = 'ascii'},
        },

        -- fuzzy find algorithm
        {
            'echasnovski/mini.fuzzy',
            opts = {},
        },

        -- markdown rendering
        {
            'MeanderingProgrammer/render-markdown.nvim',
            dependencies = {
                'nvim-treesitter/nvim-treesitter',
                'echasnovski/mini.nvim',
            },
            config = require("plugins/render-markdown"),
            ft = "markdown",
        },

        -- personal library
        {dir = "~/lib/hnetxt-lua"},

    },
})
