local M = {}
local yaml = require("hneutil.yaml")
local constants = require('lex.constants')
local Path = require('util.path')

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
    local config = yaml.read(path)

    config['root'] = vim.fn.fnamemodify(path, ':h')

    local mirrors = {}
    for kind, kind_data in pairs(constants.mirror_defaults) do
        for mirror, mirror_data in pairs(kind_data.mirrors) do
            mirror_data = _G.default_args(vim.tbl_get(config, 'mirrors', mirror), mirror_data)
            mirror_data.kind = kind
            mirror_data.dir = Path.join(config['root'], kind_data.dir, mirror)

            if not vim.tbl_get(mirror_data, "disable") then
                mirrors[mirror] = mirror_data
            end
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
