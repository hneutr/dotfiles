local highlights_by_namespace = {
    ["0"] = {
        LineNr = {ctermfg = 10},

        SignColumn = {},
        Folded = {},

        StatusLine = {link = "Normal"},
        StatusLineNC = {link = "NonText"},
        EndOfBuffer = {fg = "#1e1e2f", bg = "#1e1e2f"},
    },
    inactive_win = {
        LineNr = {link = "NonText"},
        LineNrAbove = {link = "NonText"},
        LineNrBelow = {link = "NonText"},
    },
}

local namespaces = vim.api.nvim_get_namespaces()
for ns, highlights in pairs(highlights_by_namespace) do
    if ns == "0" then
        ns = 0
    elseif not namespaces[ns] then
        ns = vim.api.nvim_create_namespace(ns)
    end

    for group, highlight in pairs(highlights) do
        vim.api.nvim_set_hl(ns, group, highlight)
    end
end
