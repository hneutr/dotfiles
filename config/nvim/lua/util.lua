local M = {}
local api = vim.api


function _G.escape(s)
    return (s:gsub('[%-%.%+%[%]%(%)%$%^%%%?%*]','%%%1'))
end

function _G.tbl_update(...)
    return vim.tbl_extend("force", ...)
end

function _G.tbl_default(...)
    return vim.tbl_extend("keep", ...)
end

function _G.default_args(args, defaults)
    return vim.tbl_extend("keep", args or {}, defaults)
end

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


function M.sort_ascending(a, b)
    return a < b
end


function M.sort_descending(a, b)
    return a > b
end

return M
