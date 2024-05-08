local ls = require("luasnip")

ls.config.set_config({
    history = false,
    -- ensure tab behaves normally outside snips
    region_check_events = 'InsertEnter',
    delete_check_events = 'InsertLeave'
})

--------------------------------------------------------------------------------
--                                  mappings                                  --
--------------------------------------------------------------------------------
local args = {silent = true}
vim.cmd([[imap <silent><expr> <Tab> luasnip#expandable() ? '<Plug>luasnip-expand-or-jump' : '<Tab>']])

vim.keymap.set("i", "<c-f>", function() ls.jump(1) end, args)
vim.keymap.set("i", "<c-b>", function() ls.jump(-1) end, args)

vim.keymap.set({"i", "s"}, "<c-.>", function() if ls.choice_active() then ls.change_choice(1) end end, args)
vim.keymap.set({"i", "s"}, "<c-,>", function() if ls.choice_active() then ls.change_choice(-1) end end, args)

Conf.paths.luasnips_dir:iterdir():foreach(function(path)
    vim.cmd("source " .. tostring(path))
end)
