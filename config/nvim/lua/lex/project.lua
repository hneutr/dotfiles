local M = {}

local project_configs = {}

function M.set_root(path)
    path = path or vim.fn.expand('%:p')

    -- if the path is a file, start the search from its parent directory
    if vim.fn.filereadable(path) then
         path = vim.fn.fnamemodify(path, ':h')
    end

    local config_file = nil

    local current_path = ''
    for part in vim.gsplit(path, '/') do
        if not vim.endswith(current_path, '/') then
            current_path = current_path .. '/'
        end

        current_path = current_path .. part

        local possible_config_file = vim.g.project_file_name

        if not vim.endswith(current_path, '/') then
            possible_config_file = current_path .. '/' .. possible_config_file
        end

        if vim.fn.filereadable(possible_config_file) ~= 0 then
            config_file = possible_config_file
        end
    end

    if config_file then
        vim.b.project_config_file = config_file
        M.set_config(config_file)
    end
end

function M.set_config(config_file)
    if not vim.g.project_configs then
        vim.g.project_configs = vim.empty_dict()
    end

    if not vim.tbl_get(vim.g.project_configs, config_file) then
        local config = vim.fn.json_decode(vim.fn.readfile(config_file))

        config['root'] = vim.fn.fnamemodify(config_file, ':h')

        config = require'lex.mirror'.apply_defaults_to_config(config)

        -- unclear why this swapping has to be done, but it does
        project_configs = vim.g.project_configs
        project_configs[config_file] = config
        vim.g.project_configs = project_configs
    end

    require'lex.mirror'.add_mappings()
end

function M.get_config()
    return vim.tbl_get(vim.g.project_configs, vim.b.project_config_file) or {}
end

function M.push()
    vim.fn.system("git add " .. vim.b.projectRoot)
    vim.fn.system("git commit -m ${TD}")
    vim.fn.system("git push")
end

return M
