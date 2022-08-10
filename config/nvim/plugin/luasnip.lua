local ls = require"luasnip"

ls.config.set_config({
    history = false,
    -- ensure tab behaves normally outside snips
    region_check_events = 'InsertEnter',
    -- delete_check_events = 'InsertLeave',
})

--------------------------------------------------------------------------------
--                                  mappings                                  --
--------------------------------------------------------------------------------
local map = vim.keymap.set

-- expand or jump within a snippet.
map('i', "<Tab>", "luasnip#expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' : '<Tab>'", {
    remap = true,
    silent = true,
    expr = true
})
map({ "i", "s" }, "<S-Tab>", function() require'luasnip'.jump(-1) end, { silent = true })
map("s", "<Tab>", function() require'luasnip'.jump(1) end, { silent = true })

--------------------------------------------------------------------------------
--                            loading ft snips                                --
--------------------------------------------------------------------------------
local snips_dir = _G.joinpath(vim.g.vim_config, 'snips')

function load_ft_snips()
    for i, path in ipairs(vim.fn.readdir(snips_dir)) do
        path = _G.joinpath(snips_dir, path)
        if vim.fn.filereadable(path) > 0 then
            vim.cmd("source " .. path)
        end
    end
end

load_ft_snips()
