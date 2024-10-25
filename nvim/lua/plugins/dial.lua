local augend = require("dial.augend")
local List = require("hl.List")

local default_augends = {
    augend.integer.alias.decimal_int,
    augend.date.alias["%Y/%m/%d"],
}

local ft_info = {
    default = {
        pattern = '*',
        augends = {
            augend.constant.new({elements = {"true", "false"}}),
            augend.constant.new({elements = {"and", "or"}}),
            augend.constant.new({elements = {"True", "False"}}),
        },
    },
    python = {
        pattern = '*.py',
        augends = {
            augend.constant.new({elements = {"and", "or"}}),
            augend.constant.new({elements = {"True", "False"}}),
        }
    },
    lua = {
        pattern = '*.lua',
        augends = {
            augend.constant.new({elements = {"and", "or"}}),
            augend.constant.new({elements = {"true", "false"}}),
        }
    },
    markdown = {
        pattern = '*.md',
        augends = {
            augend.constant.new({elements = {"true", "false"}}),
            -- headers
            augend.user.new({
                find = function(line, cursor)
                    local start, stop = line:find("^#+%s")
                    if start and (stop < 8) and (cursor <= stop) then
                        return {from = start, to = stop}
                    end
                end,
                add = function(text, addend, cursor)
                    local n = math.min(#text + addend - 1, 6)
                    text = n < 1 and "" or ("%s "):format(string.rep("#", n))
                    return {text = text, cursor = 1}
                end,
            }),
        },
    },
}

local groups = {}
for ft, info in pairs(ft_info) do
    groups[ft] = List.from(default_augends, info.augends)
end

require("dial.config").augends:register_group(groups)

local map_args = {noremap = true, buffer = true}

for ft, info in pairs(ft_info) do
    vim.api.nvim_create_autocmd({'BufEnter'}, {pattern=info.pattern, callback=require('util').run_once({
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

vim.keymap.set("n", "<C-a>", function()
    require("dial.map").manipulate("increment", "normal")
end)
vim.keymap.set("n", "<C-x>", function()
    require("dial.map").manipulate("decrement", "normal")
end)
vim.keymap.set("n", "g<C-a>", function()
    require("dial.map").manipulate("increment", "gnormal")
end)
vim.keymap.set("n", "g<C-x>", function()
    require("dial.map").manipulate("decrement", "gnormal")
end)
vim.keymap.set("v", "<C-a>", function()
    require("dial.map").manipulate("increment", "visual")
end)
vim.keymap.set("v", "<C-x>", function()
    require("dial.map").manipulate("decrement", "visual")
end)
vim.keymap.set("v", "g<C-a>", function()
    require("dial.map").manipulate("increment", "gvisual")
end)
vim.keymap.set("v", "g<C-x>", function()
    require("dial.map").manipulate("decrement", "gvisual")
end)
