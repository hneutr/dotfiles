vim.api.nvim_create_autocmd({"BufNewFile", "BufRead"}, { pattern={ "*.lua" }, callback=function()
    vim.bo.tabstop = 4
    vim.bo.shiftwidth = 4
    vim.bo.expandtab = true
end})
