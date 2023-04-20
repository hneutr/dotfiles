--[[
foldexpr setup: https://github.com/nvim-treesitter/nvim-treesitter/blob/master/autoload/nvim_treesitter.vim
--]]
local Lines = require("util.lines")
local Color = require("color")
string = require("hneutil.string")

local M = {}

function M.get_fold_text(lnum)
    local text = Lines.line.get({start_line = lnum})
    local whitespace, text = text:match("^(%s*)(.*)")
    return whitespace .. "..."
end

function M.set_options()
    vim.wo.foldenable = true
    vim.wo.foldmethod = 'marker'
    vim.wo.foldnestmax = 20
    vim.wo.foldtext = "hnetxt#foldtext()"
    vim.wo.fillchars = "fold: "

    Color.set_highlight({name = "Folded", val = {fg = 'magenta'}})

    vim.cmd([[syn match FoldStart /^\s*{{{$/]])
    vim.cmd([[syn match FoldEnd /^\s*}}}$/]])

    Color.set_highlight({name = "FoldStart", val = {fg = 'magenta'}})
    Color.set_highlight({name = "FoldEnd", val = {fg = 'magenta'}})
end

function M.toggle(mode)
    local range = Lines.selection.range({mode = mode})
    local start_line = range.start_line
    local end_line = range.end_line

    if mode == 'n' then
        end_line = end_line - 1
    end

    local fold_start_mark = "{{{"
    local fold_end_mark = "}}}"

    local fold_start = vim.fn.search(fold_start_mark, "bn") - 1
    local fold_end = vim.fn.search(fold_end_mark, "n") - 1

    local within_fold = fold_start < start_line and end_line < fold_end

    if within_fold then
        Lines.line.cut({start_line = fold_end})
        Lines.line.cut({start_line = fold_start})
    else
        local lines = {fold_start_mark}
        local indent
        for _, line in ipairs(Lines.selection.get({mode = mode})) do
            lines[#lines + 1] = line

            local line_indent = line:match("^(%s*).*")

            if indent == nil or indent:len() > line_indent:len() then
                indent = line_indent
            end
        end

        lines[1] = indent .. lines[1]
        lines[#lines + 1] = indent .. fold_end_mark

        Lines.selection.set({mode = mode, replacement = lines})
    end
end

return M
