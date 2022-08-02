_mirror = require'lex.mirror'

local M = {}

M.file = {}

function M.file.find(start_path)
    start_path = start_path or vim.fn.expand('%:p')

    local path

    local current_path = ''
    for part in vim.gsplit(start_path, '/') do
        current_path = _G.joinpath(current_path, part)

        local possible_path = _G.joinpath(current_path, vim.g.config_file_name)

        if vim.fn.filereadable(possible_path) ~= 0 then
            path = possible_path
        end
    end

    return path
end

function M.file.build(path)
    local config = vim.fn.json_decode(vim.fn.readfile(path))

    config['root'] = vim.fn.fnamemodify(path, ':h')

    config = _mirror.apply_defaults_to_config(config)
    return config
end

function M.set(start_path)
    local configs = vim.g.lex_configs or {}

    local path = M.file.find(start_path)

    if path then
        vim.b.lex_config_path = path

        if not vim.tbl_get(configs, path) then
            configs[path] = M.file.build(path)
        end

        vim.b.lex_config = configs[path]

        _mirror.add_mappings()
    else
        vim.b.lex_config = {}
    end

    vim.g.lex_configs = configs
end

function M.push()
    vim.fn.system("git add " .. M.get()['root'])
    vim.fn.system("git commit -m ${TD}")
    vim.fn.system("git push")
end

return M
