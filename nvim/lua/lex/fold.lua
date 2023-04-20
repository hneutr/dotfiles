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
    vim.wo.foldnestmax = 20
    vim.wo.foldtext = "hnetxt#foldtext()"
    vim.wo.fillchars = "fold: "
    vim.wo.foldlevel = 2
    vim.wo.foldmethod = 'expr'
    vim.wo.foldexpr = 'hnetxt#foldexpr()'

    Color.set_highlight({name = "Folded", val = {fg = 'magenta'}})
end

return M
