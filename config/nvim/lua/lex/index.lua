local M = {}
local api = vim.api
local util = require'util'

local default_index_path = vim.env.TMPDIR .. 'index.md'

function M.make(path, index_path)
    path = path or api.nvim_buf_get_name(0)
    index_path = index_path or default_index_path

    local cmd = "hnetext index"
    cmd = cmd .. " --source " .. path
    cmd = cmd .. " --dest " .. index_path

    vim.cmd("silent call system('" .. cmd .. "')")

    return index_path
end

function M.open(open_command)
    local project_config_file = vim.b.projectConfigFile
    local project_root = vim.b.projectRoot

    local path = M.make()

    util.open_path(path, open_command)

    vim.b.projectConfigFile = project_config_file
    vim.b.projectRoot = project_root
end

return M
