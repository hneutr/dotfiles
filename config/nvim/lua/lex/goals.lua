local M = {}

function M.path()
    return vim.trim(vim.fn.system('hnetext goals'))
end

return M
