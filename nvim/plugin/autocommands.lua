local util = require('util')

List({
    -- diagnostics suck
    {
        {"BufEnter"},
        {callback = function() vim.diagnostic.disable(0) end},
    },
    -- save post-change
    {
        {"TextChanged", "InsertLeave"},
        {callback = util.save_and_restore_visual_selection_marks},
    },
    -- turn numbers on for normal buffers; turn them off for terminal buffers
    {
        {"TermOpen", "BufWinEnter"},
        {callback = util.set_number_display},
    },
    -- enter insert mode whenever we're in a terminal
    {
        {"TermOpen", "BufWinEnter", "BufEnter"},
        {pattern = "term://*", command = "startinsert"}
    },
    -- statusline
    {
        {"VimEnter", "BufWinEnter", "TermOpen"},
        {callback = util.set_statusline}
    },
    -- open file at last point
    {
        {"BufReadPost"},
        {
            command = [[if @% !~# '\.git[\/\\]COMMIT_EDITMSG$' && line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif]]
        },
    },
    -- remove trailing whitespace
    {
        {"BufWritePre"},
        {
            pattern = {"*.py", "*.lua", "*.js", "*.yaml", "*.ts", "*.html", "*.sh"},
            callback = function()
                local cursor = vim.api.nvim_win_get_cursor(0)
                vim.cmd([[%s/\s\+$//e]])
                vim.api.nvim_win_set_cursor(0, cursor)
            end,
        }
    }
}):foreach(function(item)
    local event, opts = unpack(item)
    opts.pattern = opts.pattern or "*"
    vim.api.nvim_create_autocmd(event, opts)
end)
