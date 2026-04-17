vim.api.nvim_set_hl(0, "TabLineNumber", {fg = "#74c7ed", bg = "#11111c"})
vim.api.nvim_set_hl(0, "TabLineNumberSel", {fg = "#74c7ed", bg = "#1e1e2f"})

local function get_name_of_first_listed_buf(tab)
    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(tab)) do
        local bufnr = vim.api.nvim_win_get_buf(win)

        if vim.api.nvim_get_option_value('buflisted', {buf = bufnr}) then
            return vim.fn.fnamemodify(vim.fn.bufname(bufnr), ':t:r')
        end
    end
end

local function format_tabstr(text, hl_suffix)
    return '%#' .. "TabLine" .. hl_suffix .. '#' .. text .. '%*'
end

function tabline()
    local pad_n = 4

    local tabline_str = ""
    for tab, _ in pairs(vim.api.nvim_list_tabpages()) do
        local hl_suffix = tab == vim.fn.tabpagenr() and "Sel" or ""

        local hl = "TabLine" .. (tab == vim.fn.tabpagenr() and "Sel" or "")

        local tab_n_str = " " .. tostring(tab)

        local name = get_name_of_first_listed_buf(tab)

        local left_pad = (" "):rep(pad_n - #tab_n_str)
        local right_pad = (" "):rep(pad_n)

        tabline_str = tabline_str .. format_tabstr(tab_n_str, "Number" .. hl_suffix)
        tabline_str = tabline_str .. format_tabstr(left_pad .. name .. right_pad, hl_suffix)
    end

    return tabline_str
end

vim.opt.tabline = '%!v:lua.tabline()'
