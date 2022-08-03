local util = require'util'

local M = {}

function M._do(args)
    defaults = {
        action = nil,
        buffer = 0,
        start_line = 0,
        end_line = vim.fn.line('$'), 
        strict_indexing = false,
        replacement = nil,
    }

    local a = _G.default_args(args, defaults)

    local value

    if a.action == 'get' then
        value = vim.api.nvim_buf_get_lines(a.buffer, a.start_line, a.end_line, a.strict_indexing)
    elseif a.action == 'set' then
        value = vim.api.nvim_buf_set_lines(a.buffer, a.start_line, a.end_line, a.strict_indexing, a.replacement)
    end

    return value
end

function M.get(args)
    args = _G.default_args(args, { action = 'get' })
    return M._do(args)
end

function M.set(args)
    args = _G.default_args(args, { action = 'set' })
    return M._do(args)
end

function M.cut(args)
    args = _G.default_args(args, { action = 'set', replacement = {} })
    return M._do(args)
end

M.selection = {}

function M.selection.range(args)
    args = _G.default_args(args, { mode = 'n', buffer = 0})

    local start_line, end_line

    if args['mode'] == 'n' then
        start_line = vim.api.nvim_win_get_cursor(args['buffer'])[1] - 1
        end_line = start_line + 1
    elseif args['mode'] == 'v' then
        vim.api.nvim_input('<esc>')
        start_line = vim.api.nvim_buf_get_mark(args['buffer'], '<')[1] - 1
        end_line = vim.api.nvim_buf_get_mark(args['buffer'], '>')[1]
        
        local difference = end_line - start_line
        if start_line < 0 then
            start_line = 0
        end
    end

    vim.g.start_line = start_line
    vim.g.end_line = end_line
    return { start_line = start_line, end_line = end_line }
end

function M.selection._set_range(args)
    return _G.default_args(args, M.selection.range(args))
end

function M.selection.get(args)
    return M.get(M.selection._set_range(args))
end

function M.selection.set(args)
    return M.set(M.selection._set_range(args))
end

function M.selection.cut(args)
    return M.cut(M.selection._set_range(args))
end


M.cursor = {}
function M.cursor.get()
    return M.selection.get()[1]
end

function M.cursor.set(line)
    return M.selection.set({ replacement = {line} })
end

function M.cursor.cut(args)
    return M.selection.cut()
end


return M
