local M = {}
local api = vim.api

local writing_journal = 'on-writing'

function M.path(journal_name)
    local cmd = "hnetext journal"

    if vim.b.projectRoot then
        cmd = cmd .. ' -s ' .. vim.b.projectRoot
    end

    if journal_name then
        cmd = cmd .. ' -j ' .. journal_name
    end

    local path = vim.fn.system(cmd)
    return vim.trim(path)
end

return M
