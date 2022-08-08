local M = {}

function M.path()
    local constants = require'lex.constants'
    local this_month = vim.fn.strftime("%Y%m")
    return _G.joinpath(constants.goals_directory, this_month .. '.md')
end

return M
