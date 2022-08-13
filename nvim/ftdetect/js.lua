vim.api.nvim_create_autocmd({"BufEnter"}, {pattern={ "*.js" }, callback=require'util'.run_once({
    scope = 'b',
    key = 'ft_opts_applied',
    fn = function()
        vim.bo.tabstop = 4
        vim.bo.shiftwidth = 4
        vim.bo.expandtab = true
    end,
})})
