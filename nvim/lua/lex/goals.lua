local M = {}

function M.path()
    local this_month = vim.fn.strftime("%Y%m")
    return _G.joinpath(require'lex.constants'.goals_directory, this_month .. '.md')
end

return M
