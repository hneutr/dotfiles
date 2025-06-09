local highlights = {
    ["Cursor"] = {fg = "#1e1e2f", bg = "#cdd6f5"},
}

for key, val in pairs(highlights) do
    vim.api.nvim_set_hl(0, key, val)
end
