List({
    -- diagnostics suck
    {
        {"BufEnter"},
        {callback = function() vim.diagnostic.disable(0) end},
    },

    -- save post-change
    {
        {"TextChanged", "InsertLeave"},
        {
            callback = function()
                if vim.bo.modified then
                    for _, markset in ipairs({{'<', '>'}, {'[', ']'}}) do
                        local start_line, start_col = unpack(vim.api.nvim_buf_get_mark(0, markset[1]))
                        local end_line, end_col = unpack(vim.api.nvim_buf_get_mark(0, markset[2]))

                        pcall(function() vim.cmd("silent write") end)

                        start_line = math.max(start_line, 1)
                        end_line = math.min(end_line, vim.fn.line('$'))

                        pcall(function()
                            vim.api.nvim_buf_set_mark(0, markset[1], start_line, start_col, {})
                            vim.api.nvim_buf_set_mark(0, markset[2], end_line, end_col, {})
                        end)
                    end
                end
            end,
        },
    },

    -- turn numbers on for normal buffers; turn them off for terminal buffers
    {
        {"TermOpen", "BufWinEnter"},
        {
            callback = function()
                if vim.bo.buftype == 'terminal' then
                    vim.wo.number = false
                    vim.wo.relativenumber = false
                else
                    vim.wo.number = true
                    vim.wo.relativenumber = true
                end
            end
        },
    },

    -- enter insert mode whenever we're in a terminal
    {
        {"TermOpen", "BufWinEnter", "BufEnter"},
        {pattern = "term://*", command = "startinsert"}
    },

    -- statusline
    {
        {"VimEnter", "BufWinEnter", "TermOpen"},
        {
            callback = function()
                local statusline = "%.100F"
                if vim.api.nvim_buf_get_name(0):match("^term") then
                    statusline = "term"
                end

                vim.opt_local.statusline = statusline
            end
        }
    },

    -- open file at last point
    {
        {"BufReadPost"},
        {
            callback = function()
                if vim.fn.bufname():match("%.git/COMMIT_EDITMSG") then
                    return
                end

                local row, col = unpack(vim.api.nvim_buf_get_mark(0, '"'))
                row = math.max(row, 0)
                row = math.min(row, vim.fn.line('$') - 1)

                vim.api.nvim_win_set_cursor(0, {row, col})
            end
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
