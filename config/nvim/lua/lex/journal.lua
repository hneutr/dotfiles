local M = {}

function M.path(journal_name)
    local cmd = "hnetext journal"

    local root = vim.tbl_get(config.get(), 'root') or ''

    if root then
        cmd = cmd .. ' -s ' .. root
    end

    if journal_name then
        cmd = cmd .. ' -j ' .. journal_name
    end

    return vim.trim(vim.fn.system(cmd))
end

return M
