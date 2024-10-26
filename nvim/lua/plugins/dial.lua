local augend = require("dial.augend")

local default_augends = {
    augend.integer.alias.decimal_int,
    augend.date.alias["%Y/%m/%d"],
    augend.constant.new({elements = {"true", "false"}}),
}

local groups = {
    default = {
        augend.constant.new({elements = {"and", "or"}}),
        augend.constant.new({elements = {"True", "False"}}),
    },
    markdown = {
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
}

for ft, augends in pairs(groups) do
    groups[ft] = List.from(default_augends, augends)
end

require("dial.config").augends:register_group(groups)

local args = {noremap = true, buffer = true}

vim.api.nvim_create_autocmd(
    {'FileType'},
    {
        callback = function()
            local filetype = vim.bo.filetype
            local group = groups[filetype] and filetype
            vim.keymap.set("n", "<C-a>", require("dial.map").inc_normal(group), args)
            vim.keymap.set("n", "<C-x>", require("dial.map").dec_normal(group), args)
            vim.keymap.set("v", "<C-a>", require("dial.map").inc_visual(group), args)
            vim.keymap.set("v", "<C-x>", require("dial.map").dec_visual(group), args)
            vim.keymap.set("v", "g<C-a>", require("dial.map").inc_gvisual(group), args)
            vim.keymap.set("v", "g<C-x>", require("dial.map").dec_gvisual(group), args)
        end,
    }
)
