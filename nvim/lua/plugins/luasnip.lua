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

--------------------------------------------------------------------------------
--                            loading ft snips                                --
--------------------------------------------------------------------------------
local snips_dir = _G.joinpath(vim.g.vim_config, 'snips')

function load_ft_snips()
    for i, path in ipairs(vim.fn.readdir(snips_dir)) do
        path = _G.joinpath(snips_dir, path)
        if _G.filereadable(path) then
            vim.cmd("source " .. path)
        end
    end
end

load_ft_snips()
