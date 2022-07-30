local M = {}

M.header = {
    size = 'small',
    sizes = {
        small = {
            length = 40,
            line_char = '-',
            text_start_char = '>',
        },
        large = {
            length = 80,
            line_char = '#',
            text_start_char = '#',
        },
    },
}

function M.header.get(args)
    args = args or {}
    local content = vim.tbl_get(args, 'content') or ''
    local size = vim.tbl_get(args, 'size') or M.header.size

    local settings = vim.tbl_get(M.header, 'sizes', size)

    local line = vim.tbl_get(settings, 'line_char') .. string.rep('-', vim.tbl_get(settings, 'length') - 1)
    
    local content_line = vim.tbl_get(settings, 'text_start_char')

    if string.len(content) then
        content_line = content_line .. " " .. content
    end

    return { line, content_line, line, "" }
end

function M.header.insert(args)
    args = args or {}

    local header = M.header.get(args)
    local line = vim.api.nvim_win_get_cursor(0)[1]

    vim.api.nvim_put(header, 'c', 0, 0)

    local column = vim.tbl_get(args, 'column') or 2

    vim.api.nvim_win_set_cursor(0, {line + 1, column})
    vim.api.nvim_input('a')
end

function M.header.insert_marker(size)
    M.header.insert({column = 2, content = "[]()", size = size})
end

return M
