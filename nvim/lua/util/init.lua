local M = {}

function lrequire(package_name)
    return function()
        return require(package_name)
    end
end

function _G.default_args(args, defaults)
    return vim.tbl_extend("keep", {}, args or {}, defaults)
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

function M.set_statusline()
    local statusline = "%.100F"
    if vim.api.nvim_buf_get_name(0):startswith("term") then
        statusline = "term"
    end

    vim.opt_local.statusline = statusline
end

-- Store visual selection marks, save, restore visual selection marks
function M.save_and_restore_visual_selection_marks()
    if vim.bo.modified then
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
    return function()
        local delimiters = List({',', ';', ':'})
        local line = vim.fn.getline("."):rstrip()

        local new_line
        while #delimiters > 0 and not new_line do
            local delimiter = delimiters:pop()
            if line:endswith(delimiter) then
                local suffix = delimiter == char and "" or char
                new_line = line:removesuffix(delimiter) .. suffix
            end
        end

        vim.fn.setline(".", new_line or line .. char)
    end
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

return M
