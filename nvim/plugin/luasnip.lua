local ls = require("luasnip")

ls.config.set_config({
    history = false,
    -- ensure tab behaves normally outside snips
    region_check_events = 'InsertEnter',
})

--------------------------------------------------------------------------------
--                                  mappings                                  --
--------------------------------------------------------------------------------
local map = vim.keymap.set

map('i', "<Tab>", "luasnip#expandable() ? '<Plug>luasnip-expand-snippet' : '<Tab>'", {
    remap = true,
    silent = true,
    expr = true
})
map("i", "<c-f>", function() require'luasnip'.jump(1) end, { silent = true })
map("i", "<c-b>", function() require'luasnip'.jump(-1) end, { silent = true })

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
