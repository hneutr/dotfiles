if not vim.g.tabline_setup then
    vim.api.nvim_set_hl(0, "TabLineNumber", {fg = "#74c7ed", bg = "#11111c"})

    function nvim_tabline()
        local pad_n = 4

        local parts = {}
        for i, _ in pairs(vim.api.nvim_list_tabpages()) do
            local winnr = vim.fn.tabpagewinnr(i)
            local bufnr = vim.fn.tabpagebuflist(i)[winnr]
            local bufname = vim.fn.bufname(bufnr)
            local tabname = Path(bufname):stem()
            local left_pad = (" "):rep(pad_n - 1 - #tostring(i))
            local right_pad = (" "):rep(pad_n)

            local hl = "TabLine" .. (i == vim.fn.tabpagenr() and "Sel" or "")

            vim.list_extend(parts, {
                {text = " ", hl = hl},
                {text = i, hl = "TabLineNumber"},
                {text = left_pad, hl = hl},
                {text = tabname, hl = hl},
                {text = right_pad, hl = hl},
            })
        end

        return table.concat(vim.tbl_map(function(part)
            return '%#' .. part.hl .. '#' .. part.text .. '%*'
        end, parts))
    end

    vim.opt.tabline = '%!v:lua.nvim_tabline()'
    vim.g.tabline_setup = true
end
