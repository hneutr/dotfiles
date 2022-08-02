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
    local lex_config_path = vim.b.lex_config_path

    require'util'.open_path(M.make(), open_command)

    vim.b.lex_config_path = lex_config_path
end

return M
