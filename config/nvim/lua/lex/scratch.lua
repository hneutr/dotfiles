local M = {}
local line_utils = require'lines'

function M.move(mode)
    local lines = line_utils.selection.get({ mode = mode })
    line_utils.selection.cut({ mode = mode })

    if lines[vim.tbl_count(lines)] ~= "" then
      table.insert(lines, "")
    end

    local scratch_file = require'lex.mirror'.get_mirror('scratch')

    if vim.fn.filereadable(scratch_file) ~= 0 then
        for line in io.lines(scratch_file) do
            table.insert(lines, line)
        end
    end

    require'util'.write_file(lines, scratch_file)

    -- line_utils.selection.cut({ mode = mode })
    vim.api.nvim_input('<esc>')
end

return M
