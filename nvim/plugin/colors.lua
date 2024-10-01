local group_to_highlight = {
    StatusLine = {ctermfg = 12, ctermbg = 0},

    Folded = {},

    -- line number column
    LineNr = {ctermfg = 10},
    LineNrAbove = {ctermfg = 10, ctermbg = 0},
    LineNrBelow = {ctermfg = 10, ctermbg = 0},

    -- match line number column
    SignColumn = {},
}

for group, highlight in pairs(group_to_highlight) do
    vim.api.nvim_set_hl(0, group, highlight)
end
