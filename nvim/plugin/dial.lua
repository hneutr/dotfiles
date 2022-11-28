local augend = require("dial.augend")
local aucmd = vim.api.nvim_create_autocmd
local util = require('util')

local default_augends = {
    augend.integer.alias.decimal_int,
    augend.date.alias["%Y/%m/%d"],
}

local ft_info = {
    default = {
        pattern = '*',
    },
    python = {
        pattern = '*.py',
        augends = {
            augend.constant.new{ elements = {"and", "or"} },
            augend.constant.new{ elements = {"True", "False"} },
        }
    },
    lua = {
        pattern = '*.lua',
        augends = {
            augend.constant.new{ elements = {"and", "or"} },
            augend.constant.new{ elements = {"true", "false"} },
        }
    },
}

local groups = {}
for ft, info in pairs(ft_info) do
    groups[ft] = table.concatenate(default_augends, info.augends)
end

require("dial.config").augends:register_group(groups)

local map_args = {noremap = true, buffer = true}

for ft, info in pairs(ft_info) do
    aucmd({'BufEnter'}, {pattern=info.pattern, callback=util.run_once({
        scope = 'b',
        key = ft .. '_dial_maps_applied',
        fn = function()
            vim.keymap.set("n", "<C-a>", require("dial.map").inc_normal(ft), map_args)
            vim.keymap.set("n", "<C-x>", require("dial.map").dec_normal(ft), map_args)
            vim.keymap.set("v", "<C-a>", require("dial.map").inc_visual(ft), map_args)
            vim.keymap.set("v", "<C-x>", require("dial.map").dec_visual(ft), map_args)
            vim.keymap.set("v", "g<C-a>", require("dial.map").inc_gvisual(ft), map_args)
            vim.keymap.set("v", "g<C-x>", require("dial.map").dec_gvisual(ft), map_args)
        end,
    })})
end
