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
        
        -- folds
        {"kevinhwang91/promise-async"},
        {
            "kevinhwang91/nvim-ufo",
            config = function()
                require('ufo').setup({
                    provider_selector = function() return '' end,
                    open_fold_hl_timeout = 0,
                })
                
                vim.cmd("highlight UfoFoldedFg NONE")
            end
        },

        -- {"nvim-tree/nvim-web-devicons"},
        -- {
        --     "OXY2DEV/markview.nvim",
        --     ft = "markdown",
        --     dependencies = {
        --         "nvim-treesitter/nvim-treesitter",
        --         "nvim-tree/nvim-web-devicons"
        --     },
        --     config = function()
        --         require("markview").setup({
        --             -- buf_ignore = { "nofile" },
        --             -- modes = { "n", "no" },
        --             --
        --             -- options = {
        --             --     on_enable = {},
        --             --     on_disable = {}
        --             -- },
        --             --
        --             -- block_quotes = {},
        --             -- checkboxes = {},
        --             -- code_blocks = {},
        --             -- headings = {},
        --             -- horizontal_rules = {},
        --             -- inline_codes = {},
        --             -- links = {},
        --             -- list_items = {},
        --             -- tables = {}
        --             -- headings = {
        --             --     enable = true,
        --             --     shift_width = vim.o.shiftwidth,
        --             --
        --             --     -- These are just for showing how various
        --             --     -- styles can be used for the headings
        --             --     heading_1 = {
        --             --         style = "simple",
        --             --         hl = "col_1"
        --             --     },
        --             --     heading_2 = {
        --             --         style = "label",
        --             --         hl = "col_2",
        --             --
        --             --         corner_left = " ",
        --             --         padding_left = nil,
        --             --
        --             --         icon = "⑄ ",
        --             --
        --             --         padding_right = " ",
        --             --         padding_right_hl = "col_2_fg",
        --             --
        --             --         corner_right = "█▓▒░",
        --             --
        --             --         sign = "▶ ",
        --             --         sign_hl = "col_2_fg"
        --             --     },
        --             --     heading_3 = {
        --             --         style = "icon",
        --             --         hl = "col_3",
        --             --
        --             --         shift_char = "─",
        --             --         icon = "┤ ",
        --             --
        --             --         text = "Heading lvl. 3",
        --             --
        --             --         sign = "▷ ",
        --             --         sign_hl = "col_2_fg"
        --             --     },
        --             --
        --             --     --- Similar tables for the other headings
        --             --     heading_4 = {...},
        --             --     heading_5 = {...},
        --             --     heading_6 = {...},
        --             --
        --             --
        --             --     -- For headings made with = or -
        --             --     setext_1 = {
        --             --         style = "simple",
        --             --         hl = "col_1"
        --             --     },
        --             --     setext_2 = {
        --             --         style = "github",
        --             --
        --             --         hl = "col_2",
        --             --         icon = " 🔗  ",
        --             --         line = "─"
        --             --     }
        --             -- }
        --         });
        --     end
        -- },
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
