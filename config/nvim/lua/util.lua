local M = {}
local api = vim.api

--------------------------------------------------------------------------------
-- makes directories for a given path.
-- If the last component of the path has an extension, it won't make that part
--------------------------------------------------------------------------------
function M.make_directories(path)
    -- if the path ends in a file, don't make it a directory
    if vim.fn.fnamemodify(path, ':e') then
        path = vim.fn.fnamemodify(path, ':h')
    end

    local current_path = ''
    for part in vim.gsplit(path, '/') do
        if not vim.endswith(current_path, '/') then
            current_path = current_path .. '/'
        end

        current_path = current_path .. part

        if not vim.fn.isdirectory(current_path) then
            vim.cmd("silent execute !mkdir '" .. current_path .. "'")
        end
    end
end


function M.open_path(path, open_command)
    open_command = open_command or "edit"

    M.make_directories(path)

    if vim.fn.isdirectory(path) ~= 0 then
        -- if it's a directory, open a terminal at that directory
        vim.cmd("silent " .. open_command)
        vim.cmd("silent terminal")

        local term_id = vim.b.terminal_job_id

        vim.cmd("silent call chansend(" .. term_id .. ", 'cd " .. path .. "\r')")
        vim.cmd("silent call chansend(" .. term_id .. ", 'clear\r')")
    else
        vim.cmd("silent " .. open_command .. " " .. path)
    end
end


function M.write_file(content, file)
    M.make_directories(file)
    vim.fn.writefile(content, file)
end

function M.get_selection_start(mode, buffer)
    buffer = buffer or 0

    local line = api.nvim_win_get_cursor(buffer)[1] - 1

    if mode == 'v' then
        line = api.nvim_buf_get_mark(buffer, '<')[1] - 1
    end

    return line
end

function M.get_selection_end(mode, buffer)
    buffer = buffer or 0

    local line = 1 + M.get_selection_start(mode, buffer)

    if mode == 'v' then
        line = api.nvim_buf_get_mark(buffer, '>')[1]
    end

    return line
end

function M.get_selected_lines(mode, buffer)
    buffer = buffer or 0

    local start_line = M.get_selection_start(mode, buffer)
    local end_line = M.get_selection_end(mode, buffer)

    return api.nvim_buf_get_lines(buffer, start_line, end_line, false)
end

return M
