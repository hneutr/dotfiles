local M = {}
local api = vim.api
local util = require'util'

function M.move(mode)
    local start_line = util.get_selection_start(mode)
    local end_line = util.get_selection_end(mode)
    local lines = util.get_selected_lines(mode)

    if vim.tbl_get(vim.tbl_count(lines)) ~= "" then
      table.insert(lines, "")
    end

    local scratch_file = require'lex.mirror'.get_mirror('scratch')

    if vim.fn.filereadable(scratch_file) ~= 0 then
        for line in io.lines(scratch_file) do
            table.insert(lines, line)
        end
    end

    util.write_file(lines, scratch_file)

    api.nvim_buf_set_lines(0, start_line, end_line, false, {})
end

return M
