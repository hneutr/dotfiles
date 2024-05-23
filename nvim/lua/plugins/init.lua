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

require("lazy").setup(
    {
        -- colorscheme
        {
            "catppuccin/nvim",
            lazy = false,
            name = "catppuccin",
            priority = 1000,
            config = lrequire("plugins.catppuccin"),
        },

        -- open things from :term in the parent nvim
        {
            "willothy/flatten.nvim",
            config = true,
            lazy = false,
            priority = 1001,
        },

        {
            'nvim-treesitter/nvim-treesitter',
            config = lrequire('plugins.treesitter'),
        },

        {"kkharji/sqlite.lua"},

        -- fuzzy search
        'junegunn/fzf',

        {
            'ibhagwan/fzf-lua',
            config = lrequire('plugins.fzf-lua'),
            keys = {{"<leader>df", function() require('fzf-lua').files() end}},
        },

        -- zen mode
        {
            'folke/zen-mode.nvim',
            commit = "50e2e2a",
            opts = require("plugins.zen-mode"),
            keys = {{"<leader>dz", "<cmd>ZenMode<cr>"}},
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
            }
        },

        -- cycle stuff
        {'monaqa/dial.nvim', config = lrequire('plugins.dial')},
        
        -- personal library
        {dir = "~/lib/hnetxt-lua"},   
    },
    {
        -- profiling = {
        --     -- Enables extra stats on the debug tab related to the loader cache.
        --     -- Additionally gathers stats about all package.loaders
        --     loader = true,
        --     -- Track each new require in the Lazy profiling tab
        --     require = true,
        -- },
    }
)
