local M = {}


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

function _G.joinpath(left, right)
    local path = left

    if not vim.endswith(left, '/') and not vim.startswith(right, '/') then
        path = path .. '/'
    end

    return path .. right
end

--------------------------------------------------------------------------------
--                       improving vim.fn return types                        --
--------------------------------------------------------------------------------
function _G.isdirectory(path)
    return vim.fn.isdirectory(path) == 1
end

function _G.filereadable(path)
    return vim.fn.filereadable(path) == 1
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
        current_path = _G.joinpath(current_path, part)
        if not _G.isdirectory(current_path) then
            vim.cmd("silent! execute '!mkdir " .. current_path .. "'")
        end
    end
end


function M.open_path(path, open_command)
    open_command = open_command or "edit"

    M.make_directories(path)

    if _G.isdirectory(path) then
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

--------------------------------------------------------------------------------
--                                    misc                                    --
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
--                              modify_line_end                               --
--------------------------------------------------------------------------------
-- args:
--      - a delimiter char
--
-- if the line ends with the delimiter char: removes the delimiter char
-- if the line doesn't end in a delimiter: adds the delimiter char
-- if the line ends in another delimiter: replaces it with the delimiter char
--
-- delimiters: ,;:
--------------------------------------------------------------------------------
function M.modify_line_end(char)
    local delimiters = {',', ';', ':'}
    local found_delimiter
    local line = require'util.lines'.cursor.get()
    line = line:gsub('%s*$', '')

    for i, _char in ipairs(delimiters) do
        vim.pretty_print(_char)
        if vim.endswith(line, _char) then
            found_delimiter = true

            line = line:sub(1, line:len() - 1)
            vim.pretty_print(_char .. char)

            if _char ~= char then
                line = line .. char
            end

            break
        end
    end

    if not found_delimiter then
        line = line .. char
    end

    require'util.lines'.cursor.set({ replacement = {line} })
end

function M.kill_buffer_and_go_to_next()
    local buf_number = vim.fn.bufnr('%')
    vim.cmd("bnext")
    vim.api.nvim_buf_delete(buf_number, {})
end

return M
