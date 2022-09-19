local ls = require("luasnip")
local s = ls.snippet

local snips = require('snips')

vim.api.nvim_create_autocmd({'BufEnter'}, {pattern="*", callback=function()
    local loaded_fts = vim.tbl_get(vim.g, 'fts_with_standard_snips_loaded') or {} 

    local filetype = vim.bo.filetype
    if not vim.tbl_get(loaded_fts, filetype) then
        local comment_str = string.gsub(vim.bo.commentstring, "%s?%%s$", '')
        local ft_print_string = vim.tbl_get(vim.g.snip_ft_printstrings, filetype)

        ls.add_snippets(filetype, {
            s("block", snips.Block({comment=comment_str}):snippet()),
            s("h1", snips.H1({comment=comment_str}):snippet()),
            s("h2", snips.H2({comment=comment_str}):snippet()),
            s("h3", snips.H3({comment=comment_str}):snippet()),
            s("h4", snips.H4({comment=comment_str}):snippet()),
            s("fnb", snips.FunctionBlock({comment=comment_str}):snippet()),
            s("p", snips.Print(ft_print_string):snippet()),
            s("qp", snips.Print(ft_print_string):snippet(true)),
        })

        loaded_fts[filetype] = true
        vim.g.fts_with_standard_snips_loaded = loaded_fts
    end
end})
