local autocommands = {
    {
        {"TextChanged", "InsertLeave"},
        {
            desc = "autosave changes",
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

    {
        "BufReadPost",
        {
            desc = "open at last position",
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

    {
        "BufWritePre",
        {
            desc = "remove trailing whitespace",
            pattern = {"*.py", "*.lua", "*.js", "*.yaml", "*.ts", "*.html", "*.sh"},
            callback = function()
                local cursor = vim.api.nvim_win_get_cursor(0)
                vim.cmd([[%s/\s\+$//e]])
                vim.api.nvim_win_set_cursor(0, cursor)
            end,
        }
    },

    {
        "BufWritePost",
        {
            desc = "remove save messages",
            pattern = {'*'},
            command = 'redrawstatus',
        }
    },

    {
        {"BufEnter", "BufWinEnter", "TermOpen"},
        {
            desc = "hide line numbers in terminal buffers",
            callback = function()
                local show_numbers = vim.bo.buftype ~= "terminal"
                vim.wo.number = show_numbers
                vim.wo.relativenumber = show_numbers
            end
        },
    },

    {
        {"BufWinEnter", "BufEnter", "TermOpen"},
        {
            desc = "enter insert mode in terminal buffers",
            pattern = "term://*",
            command = "startinsert",
        }
    },

    {
        {"VimEnter", "BufWinEnter", "TermOpen"},
        {
            desc = "set statusline",
            callback = function()
                vim.opt_local.statusline = vim.bo.buftype == 'terminal' and "term" or "%.100F"
            end
        }
    },

    {
        "BufEnter",
        {
            desc = "turn off diagnostics, because diagnostics suck",
            callback = function() vim.diagnostic.disable(0) end
        },
    },

    {
        "CmdwinEnter",
        {
            desc = "unmap <cr> in command window",
            callback = function()
                vim.keymap.set({'n', 'i'}, "<CR>", "<CR>", {buffer = true})
            end,
        }
    },

    {
        {"WinLeave", "BufLeave", "WinEnter", "BufEnter"},
        {
            desc = "dim stuff in inactive windows",
            callback = function(tbl)
                local win = vim.fn.win_getid()
                local ns = vim.api.nvim_get_hl_ns({winid = win})

                local namespaces = vim.api.nvim_get_namespaces()

                if ns == 0 or ns == -1 or ns == namespaces.inactive_win then
                    vim.api.nvim_win_set_hl_ns(
                        win,
                        tbl.event:match("Leave") and namespaces.inactive_win or 0
                    )
                end
            end,
        },
    },
}

for _, autocommand in ipairs(autocommands) do
    vim.api.nvim_create_autocmd(unpack(autocommand))
end
