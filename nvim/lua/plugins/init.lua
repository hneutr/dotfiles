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
        -- {
        --     "OXY2DEV/markview.nvim",
        --     lazy = false,      -- Recommended
        --     -- ft = "markdown" -- If you decide to lazy-load anyway
        --
        --     dependencies = {
        --         -- You will not need this if you installed the
        --         -- parsers manually
        --         -- Or if the parsers are in your $RUNTIMEPATH
        --         "nvim-treesitter/nvim-treesitter",
        --
        --         "nvim-tree/nvim-web-devicons"
        --     },
        --     config = function()
        --         vim.wo.signcolumn = "no"
        --
        --         local headings = Dict({
        --             heading_1 = {
        --                 style = "label",
        --                 -- align = "center",
        --                 align = "left",
        --                 icon = "",
        --                 sign = "",
        --
        --                 padding_left = " ",
        --                 padding_right = " ",
        --
        --                 corner_left = "┃",
        --                 corner_left_hl = "Heading1Corner",
        --
        --                 hl = "Heading1"
        --             }
        --         })
        --         -- local heading_defaults = {
        --         --     sign = nil,
        --         --     icon = "",
        --         -- }
        --
        --         require("markview").setup({
        --             modes = {"n", "i", "no", "c"},
        --             hybrid_modes = {"i"},
        --             highlight_groups = {
        --                 {
        --                     group_name = "Heading1",
        --                     -- value = {fg = "#1e1e2e", bg = "#a6e3a1"}
        --                     -- value = {fg = "#1e1e2e", bg = "#f38ba9"}
        --                     value = {fg = "#f38ba9", bg = "#1e1e2e"}
        --                 },
        --                 {
        --                     group_name = "Heading1Corner",
        --                     -- value = {fg = "#a6e3a1"}
        --                     value = {fg = "#f38ba9"}
        --                 },
        --                 {
        --                     group_name = "Heading2",
        --                     -- value = {fg = "#1e1e2e", bg = "#a6e3a1"}
        --                     value = {fg = "#1e1e2e", bg = "#fab388"}
        --                 },
        --             },
        --             headings = {
        --                 enable = true,
        --                 shift_width = 0,
        --                 heading_1 = headings.heading_1,
        --                 heading_2 = {
        --                     style = "simple",
        --                     hl = "Heading2",
        --                 },
        --             }
        --         })
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
