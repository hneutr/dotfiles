local M = {}

function M.path()
    local path = vim.fn.system('hnetext goals')
    return vim.trim(path)
end

return M
