local Path = require('util.path')
local M = {}

local GOALS_DIR = require('lex.constants').goals_directory

function M.path()
    local this_month = vim.fn.strftime("%Y%m")
    local path = Path.join(GOALS_DIR, this_month .. '.md')

    if not Path.is_file(path) then
        local template_path = Path.join(GOALS_DIR, '.template.md')
        vim.fn.system("cp " .. template_path .. " " .. path)
    end

    return path
end

return M
