local M = {}
local api = vim.api

function M.path()
    local path = vim.fn.system('hnetext goals')
    return vim.trim(path)
end

return M
