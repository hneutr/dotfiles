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
        {
            -- colorscheme
            "catppuccin/nvim",
            lazy = false,
            name = "catppuccin",
            priority = 1000,
            opts = require("plugins.catppuccin"),
            config = function() vim.cmd.colorscheme("catppuccin") end,
        },

        {
            -- treesitter
            'nvim-treesitter/nvim-treesitter',
            build = ':TSUpdate',
            opts = require("plugins.treesitter"),
            main = "nvim-treesitter.configs",
        },

        -- treesitter text objects
        'nvim-treesitter/nvim-treesitter-textobjects',

        {
            -- open things from :term in the parent nvim
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

        {
            -- 2char motions
            'justinmk/vim-sneak',
            init = lrequire("plugins.sneak"),
            lazy = false,
            keys = {
                {'s', '<Plug>Sneak_s', remap = true, mode = {"n"}},
                {'S', '<Plug>Sneak_S', remap = true, mode = {"n"}},
                {'z', '<Plug>Sneak_s', remap = true, mode = {"x", "o"}},
                {'Z', '<Plug>Sneak_S', remap = true, mode = {"x", "o"}},
                {'f', '<Plug>Sneak_f', remap = true, mode = {"n", "x", "o"}},
                {'F', '<Plug>Sneak_F', remap = true, mode = {"n", "x", "o"}},
                {'t', '<Plug>Sneak_t', remap = true, mode = {"n", "x", "o"}},
                {'T', '<Plug>Sneak_T', remap = true, mode = {"n", "x", "o"}},
            },
        },

        {
            -- snippets
            "L3MON4D3/LuaSnip",
            config = lrequire("plugins.luasnip"),
        },

        {
            -- align by character
            'junegunn/vim-easy-align',
            keys = {{"ga", "<Plug>(EasyAlign)", mode = {"n", "x"}}}
        },

        -- paired options
        -- note: I only use `[o`/`o]`, so could prolly just implement those
        'tpope/vim-unimpaired',

        -- paste without changing registers
        'vim-scripts/ReplaceWithRegister',

        {
            -- increment/decrement
            'monaqa/dial.nvim',
            config = lrequire('plugins.dial'),
        },

        {
            -- surround things
            "kylechui/nvim-surround",
            config = lrequire('plugins.nvim-surround'),
        },

        {
            -- mini
            'echasnovski/mini.nvim',
            version = '*',
            config = function()
                -- icons
                require("mini.icons").setup({})

                -- fuzzy find algorithm
                require("mini.fuzzy").setup({})

                -- split/join fn args with gS
                require("mini.splitjoin").setup({})

                -- text objects
                local ai = require("mini.ai")
                local gen_spec = ai.gen_spec
                ai.setup({
                    custom_textobjects = {
                        d = gen_spec.treesitter({
                            a = '@function.outer',
                            i = '@function.inner',
                        }),
                        o = gen_spec.treesitter({
                            a = {'@conditional.outer', '@loop.outer'},
                            i = {'@conditional.inner', '@loop.inner'},
                        })
                    }
                })

                -- move + indent
                require("mini.move").setup({
                    mappings = {
                        -- visual
                        left  = '<left>',
                        right = '<right>',
                        down  = '<down>',
                        up    = '<up>',

                        -- normal
                        line_left  = '<M-left>',
                        line_right = '<M-right>',
                        line_down  = '<M-down>',
                        line_up    = '<M-up>',
                    }
                })

                -- pairs
                local pairs_conf = {}
                for _, char in ipairs({'"', "'", "_", "`"}) do
                    pairs_conf[char] = {
                        action = "closeopen",
                        pair = char .. char,
                        neigh_pattern = '[^%a\\][^%a]',
                        register = {cr = false},
                    }
                end

                require("mini.pairs").setup({mappings = pairs_conf})
            end,
        },

        {
            -- markdown display
            'MeanderingProgrammer/render-markdown.nvim',
            dependencies = {
                'nvim-treesitter/nvim-treesitter',
                'echasnovski/mini.nvim',
            },
            config = require("plugins/render-markdown"),
            ft = "markdown",
        },

        {
            -- personal library
            dir = "~/lib/hnetxt-lua",
        },

    },
})
