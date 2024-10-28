local ls = require("luasnip")

ls.config.setup({
    history = false,
    -- ensure tab behaves normally outside snips
    region_check_events = 'InsertEnter',
    delete_check_events = 'InsertLeave',
})

vim.api.nvim_create_autocmd({'BufEnter'}, {callback = require('snips')})

vim.cmd([[imap <silent><expr> <Tab> luasnip#expandable() ? '<Plug>luasnip-expand-or-jump' : '<Tab>']])

local args = {silent = true}
vim.keymap.set("i", "<c-f>", function() ls.jump(1) end, args)
vim.keymap.set("i", "<c-b>", function() ls.jump(-1) end, args)
vim.keymap.set({"i", "s"}, "<c-.>", function() if ls.choice_active() then ls.change_choice(1) end end, args)
vim.keymap.set({"i", "s"}, "<c-,>", function() if ls.choice_active() then ls.change_choice(-1) end end, args)
