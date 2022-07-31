local M = {}

local default_index_path = vim.env.TMPDIR .. 'index.md'

function M.make(path, index_path)
    path = path or vim.api.nvim_buf_get_name(0)
    index_path = index_path or default_index_path

    local cmd = "hnetext index"
    cmd = cmd .. " --source " .. path
    cmd = cmd .. " --dest " .. index_path

    vim.fn.system(cmd)

    return index_path
end

function M.open(open_command)
    local project_config_file = vim.b.project_config_file

    require'util'.open_path(M.make(), open_command)

    vim.b.projectConfigFile = project_config_file
end

return M
