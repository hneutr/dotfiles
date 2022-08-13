local M = {}
local ulines = require'util.lines'

function M.move(mode)
    local lines = ulines.selection.get({ mode = mode })
    ulines.selection.cut({ mode = mode })

    if lines[vim.tbl_count(lines)] ~= "" then
      table.insert(lines, "")
    end

    local scratch_file = require'lex.mirror'.MLocation():get_location('scratch').path

    if vim.fn.filereadable(scratch_file) ~= 0 then
        for line in io.lines(scratch_file) do
            table.insert(lines, line)
        end
    end

    require'util'.write_file(lines, scratch_file)

    -- vim.api.nvim_input('<esc>')
end

return M
