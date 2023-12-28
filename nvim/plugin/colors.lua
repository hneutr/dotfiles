local hl = vim.api.nvim_set_hl

-- status line
hl(0, "StatusLine", {ctermfg = 12, ctermbg = 0})

hl(0, "Folded", {})

-- line number column
hl(0, "LineNr", {ctermfg = 10})
hl(0, "LineNrAbove", {ctermfg = 10, ctermbg = 0})
hl(0, "LineNrBelow", {ctermfg = 10, ctermbg = 0})

-- make sign column the same color as the line number column
hl(0, "SignColumn", {})
