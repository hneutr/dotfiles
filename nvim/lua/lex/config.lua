local M = {}
local constants = require('lex.constants')

--------------------------------------------------------------------------------
-- file
--------------------------------------------------------------------------------
M.file = {}

function M.file.find(start_path)
    start_path = start_path or vim.fn.expand('%:p')

    local path

    local current_path = ''
    for part in vim.gsplit(start_path, '/') do
        current_path = _G.joinpath(current_path, part)

        local possible_path = _G.joinpath(current_path, require('lex.constants').config_file_name)

        if vim.fn.filereadable(possible_path) ~= 0 then
            path = possible_path
        end
    end

    return path
end

function M.file.build(path)
    local config = vim.fn.json_decode(vim.fn.readfile(path))

    config['root'] = vim.fn.fnamemodify(path, ':h')

    local mirror_defaults = constants.mirror_defaults

    local mirrors = {}
    for m_type, m_defaults in pairs(mirror_defaults['mirrors']) do
        local m_config = _G.default_args(vim.tbl_get(config, 'mirrors', m_type), m_defaults)

        m_config['dir'] = _G.joinpath(config['root'], m_config.dir_prefix)
        m_config['root'] = config['root']

        if not vim.tbl_get(m_config, "disable") then
            mirrors[m_type] = m_config
        end
    end

    config['mirrors'] = mirrors

    return config
end

--------------------------------------------------------------------------------
-- config
--------------------------------------------------------------------------------
function M.set(start_path)
    if type(start_path) == 'table' then
        start_path = start_path.match
    end

    local configs = vim.g.lex_configs or {}

    local path = M.file.find(start_path)

    if path then
        vim.b.lex_config_path = path

        if not vim.tbl_get(configs, path) then
            configs[path] = M.file.build(path)
        end
    end

    vim.g.lex_configs = configs
end

function M.get()
    return vim.tbl_get(vim.g.lex_configs or {}, vim.b.lex_config_path) or {}
end

--------------------------------------------------------------------------------
-- commands
--------------------------------------------------------------------------------
function M.push()
    vim.fn.system("cd " .. vim.tbl_get(M.get(), 'root') or '.')
    vim.fn.system("git add .")
    vim.fn.system("git commit -m " .. vim.fn.strftime("%Y%m%d"))
    vim.fn.system("git push")
end

return M
