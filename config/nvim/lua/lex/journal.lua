local M = {}

local writing_journal = 'on-writing'

function M.path(journal_name)
    local cmd = "hnetext journal"

    local project_root = vim.tbl_get(require'lex.project'.get_config(), 'root') or ''

    if project_root then
        cmd = cmd .. ' -s ' .. project_root
    end

    if journal_name then
        cmd = cmd .. ' -j ' .. journal_name
    end

    return vim.trim(vim.fn.system(cmd))
end

return M
