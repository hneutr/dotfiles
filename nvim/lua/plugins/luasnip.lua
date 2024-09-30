local ls = require("luasnip")
local s = ls.snippet

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

local snips = require('snips')

vim.api.nvim_create_autocmd(
    {'BufEnter'},
    {
        pattern="*",
        callback=function()
            local loaded_fts = vim.tbl_get(vim.g, 'fts_with_standard_snips_loaded') or {} 

            local filetype = vim.bo.filetype
            if not vim.tbl_get(loaded_fts, filetype) then
                local ft_strings = vim.tbl_get(vim.g.snip_ft_strings, filetype) or {}
                local comment_str = string.gsub(ft_strings.comment or vim.bo.commentstring, "%s?%%s$", '')

                ls.add_snippets(filetype, {
                    s("block", snips.Block({comment=comment_str}):snippet()),
                    s("h1", snips.H1({comment=comment_str}):snippet()),
                    s("h2", snips.H2({comment=comment_str}):snippet()),
                    s("h3", snips.H3({comment=comment_str}):snippet()),
                    s("h4", snips.H4({comment=comment_str}):snippet()),
                    s("fnb", snips.FunctionBlock({comment=comment_str}):snippet()),
                    s("bl", snips.BigLine({comment=comment_str}):snippet()),
                    s("l", snips.SmallLine({comment=comment_str}):snippet()),
                    s("p", snips.Print(ft_strings.print):snippet()),
                    s("qp", snips.Print(ft_strings.print):snippet(true)),
                })

                loaded_fts[filetype] = true
                vim.g.fts_with_standard_snips_loaded = loaded_fts
            end
        end
    }
)
