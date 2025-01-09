local autocommands = {
    -- save on change
    {
        {"TextChanged", "InsertLeave"},
        {
            callback = function()
                if vim.bo.modified then
                    local start_line, start_col = unpack(vim.api.nvim_buf_get_mark(0, '['))
                    local end_line, end_col = unpack(vim.api.nvim_buf_get_mark(0, ']'))

                    start_line = math.max(start_line, 1)
                    end_line = math.min(end_line, vim.fn.line('$') - 1)

                    pcall(function()
                        vim.cmd("silent write")
                        vim.api.nvim_buf_set_mark(0, '[', start_line, start_col, {})
                        vim.api.nvim_buf_set_mark(0, ']', end_line, end_col, {})
                    end)
                end
            end,
        },
    },

    -- open at last position
    {
        "BufReadPost",
        {
            callback = function()
                if vim.fn.bufname():match("%.git/COMMIT_EDITMSG") then
                    return
                end

                local row, col = unpack(vim.api.nvim_buf_get_mark(0, '"'))
                row = math.min(row, vim.fn.line('$'))
                row = math.max(row, 0)

                vim.api.nvim_win_set_cursor(0, {row, col})
            end
        },
    },

    -- remove trailing whitespace
    {
        "BufWritePre",
        {
            pattern = {"*.py", "*.lua", "*.js", "*.yaml", "*.ts", "*.html", "*.sh"},
            callback = function()
                local cursor = vim.api.nvim_win_get_cursor(0)
                vim.cmd([[%s/\s\+$//e]])
                vim.api.nvim_win_set_cursor(0, cursor)
            end,
        }
    },

    -- show line numbers in non-terminal buffers
    {
        {"BufEnter", "TermOpen"},
        {
            callback = function()
                local is_term_buf = vim.bo.buftype == 'terminal'
                vim.wo.number = not is_term_buf
                vim.wo.relativenumber = not is_term_buf
            end
        },
    },

    -- enter insert mode in terminal buffers
    {
        {"BufWinEnter", "BufEnter", "TermOpen"},
        {
            pattern = "term://*",
            command = "startinsert",
        }
    },

    -- set statusline
    {
        {"VimEnter", "BufWinEnter", "TermOpen"},
        {
            callback = function()
                vim.opt_local.statusline = vim.bo.buftype == 'terminal' and "term" or "%.100F"
            end
        }
    },

    -- turn off diagnostics, because diagnostics suck
    {
        "BufEnter",
        {
            callback = function() vim.diagnostic.disable(0) end
        },
    },

    -- unmap <cr> in command window
    {
        "CmdwinEnter",
        {
            callback = function()
                vim.keymap.set({'n', 'i'}, "<CR>", "<CR>", {buffer = true})
            end,
        }
    },

    -- dim stuff in inactive windows
    {
        {"WinLeave", "BufLeave", "WinEnter", "BufEnter"},
        {
            callback = function(tbl)
                vim.api.nvim_win_set_hl_ns(
                    vim.fn.win_getid(),
                    tbl.event:match("Leave") and vim.api.nvim_get_namespaces()['inactive_win'] or 0
                )
            end,
        },
    },
}

for _, autocommand in ipairs(autocommands) do
    vim.api.nvim_create_autocmd(unpack(autocommand))
end
