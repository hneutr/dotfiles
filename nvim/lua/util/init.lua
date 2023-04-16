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
    return vim.tbl_extend("keep", {}, args or {}, defaults)
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
function M.open_two_vertical_terminals()
    vim.cmd("silent terminal")
    vim.api.nvim_input('<esc>')
    vim.cmd("silent vsplit")
    vim.cmd("silent terminal")
    vim.api.nvim_input('A')
end

function M.edit_without_nesting()
    local has_ui = vim.tbl_count(vim.api.nvim_list_uis()) > 0
    local server_address = vim.env.NVIM

    if server_address and has_ui then
        -- start a job with the source vim instance
        local server = vim.fn.jobstart({'nc', '-U', server_address}, {rpc = true})

        -- get the filename of the newly opened buffer
        local filename = vim.fn.fnameescape(vim.fn.expand('%:p'))

        -- wipeout the buffer
        vim.api.nvim_buf_delete(0, {})

        -- open the buffer in the source vim instance
        vim.fn.rpcrequest(server, "nvim_command", "edit " .. filename)

        -- call the autocommand to enter windows
        vim.fn.rpcrequest(server, "nvim_command", "doautocmd BufWinEnter")

        -- quit the "other" instance of vim
        vim.cmd("quitall")
    end
end

-- Store visual selection marks, save, restore visual selection marks
function M.save_and_restore_visual_selection_marks()
    local start_line, start_col = unpack(vim.api.nvim_buf_get_mark(0, "["))
    local end_line, end_col = unpack(vim.api.nvim_buf_get_mark(0, "]"))

    pcall(function() vim.cmd("silent write") end)

    start_line = math.max(start_line, 0)
    end_line = math.min(end_line, vim.fn.line('$') - 1)

    pcall(function()
        vim.api.nvim_buf_set_mark(0, "[", start_line, start_col, {})
        vim.api.nvim_buf_set_mark(0, "]", end_line, end_col, {})
    end)
end

--------------------------------------------------------------------------------
--                             set_number_display                             --
--------------------------------------------------------------------------------
-- Varies the display of numbers.
--
-- This is not a 'mode' specific setting, so a simple autocommand won't work.
-- Numbers should not show up in a terminal buffer, regardless of if that
-- buffer is in terminal mode or not.
--------------------------------------------------------------------------------
function M.set_number_display()
    if vim.bo.buftype == 'terminal' then
        vim.wo.number = false
        vim.wo.relativenumber = false
    else
        vim.wo.number = true
        vim.wo.relativenumber = true
    end
end

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
        if vim.endswith(line, _char) then
            found_delimiter = true

            line = line:sub(1, line:len() - 1)

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


function M.run_once(args)
    args = _G.default_args(args, {scope = 'b', key = '', fn = function() return end })
    return function()
        if not vim[args.scope][args.key] then
            args.fn()
            vim[args.scope][args.key] = true
        end
    end
end

--------------------------------------------------------------------------------
-- strip
-- -----
-- - str: string to strip
-- - char: option, char to remove from left and right sides of string. default is whitespace
-- 
-- strips char from the left/right of string
--------------------------------------------------------------------------------
function _G.strip(str, char)
    str = _G.lstrip(str, char)
    str = _G.rstrip(str, char)
    return str
end

function _G.lstrip(str, char)
    if char then
        char = _G.escape(char)
    end

    char = char or '%s'
    return string.gsub(str, "^" .. char .. "*", "", 1)
end

function _G.rstrip(str, char)
    if char then
        char = _G.escape(char)
    end

    char = char or '%s'
    return string.gsub(str, char .. "*$", "", 1)
end

return M
