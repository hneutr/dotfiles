local util = require('util')

vim.api.nvim_create_autocmd({'BufEnter'}, {pattern="*.md", callback=util.run_once({
    scope = 'b',
    key = 'ft_opts_applied',
    fn = function()
        vim.wo.conceallevel = 2
        vim.wo.linebreak = true
        vim.bo.expandtab = true
        vim.bo.commentstring = ">%s"
        vim.bo.textwidth = 0
        vim.bo.shiftwidth = 2
        vim.bo.softtabstop = 2
    end,
})})
