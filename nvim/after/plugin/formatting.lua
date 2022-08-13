local formatting_g = vim.api.nvim_create_augroup('formatting_autogroup', { clear = true })

vim.api.nvim_create_autocmd({"FileType"}, {pattern=p, group=formatting_g, callback=function()
    local formatoptions = ""

    -- don't autoformat long lines in insert mode
    formatoptions = formatoptions .. 'l'

    -- allow formatting of comments with gq
    formatoptions = formatoptions .. 'q'

    -- remove comment leader when joining lines
    formatoptions = formatoptions .. 'j'

    -- recognize numbered lists and wrap accordingly
    formatoptions = formatoptions .. 'n'

    -- continue comments on <cr>
    formatoptions = formatoptions .. 'r'

    -- continue comments on o/O
    formatoptions = formatoptions .. 'o'

    -- autowrap comments
    formatoptions = formatoptions .. 'c'

    vim.bo.formatoptions = formatoptions
end})
