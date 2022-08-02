local M = {}

function M.get_mirror_defaults()
    if not vim.g.mirror_defaults then
        vim.g.mirror_defaults = vim.fn.json_decode(vim.fn.readfile(vim.g.mirror_defaults_path))
    end

    return vim.g.mirror_defaults
end


function M.apply_defaults_to_config(config)
    config = config or {}
    local defaults = M.get_mirror_defaults()

    local mirrors_dir_prefix = vim.tbl_get(config, "mirrorsDirPrefix") or defaults['mirrorsDirPrefix']

    local mirrors_dir = _G.joinpath(config['root'], mirrors_dir_prefix)

    local mirrors = {}
    for mirror_type, mirror_config in pairs(defaults['mirrors']) do
        local mirror_config = _G.default_args(vim.tbl_get(config, 'mirrors', mirror_type), mirror_config)

        mirror_config['dir'] = _G.joinpath(mirrors_dir, mirror_config['dirPrefix'])

        if not vim.tbl_get(mirror_config, "disable") then
            mirrors[mirror_type] = mirror_config
        end
    end

    config['mirrors'] = mirrors

    return config
end

------------------------------------ get_mirror ---------------------------------
-- gets the equivalent location of a file for a given prefix.
--
-- defaults:
-- - path: the current file
--
-- For example, if: 
-- - prefix = `scratch`
-- - path = `./text/chapters/1.md` (where "." is the config root)
--
-- it will return `./scratch/text/chapters/1.md`
---------------------------------------------------------------------------------
function M.get_mirror(mirror_type, path)
    path = path or vim.fn.expand('%:p')
    local config = vim.b.lex_config
    return path:gsub(_G.escape(config['root']), config['mirrors'][mirror_type]['dir'], 1)
end

---------------------------------- getSource -----------------------------------
-- gets the "real" location of a file, one with a prefix. For example, the
-- defaults:
-- - path: the current file
--
-- For example, if: 
-- - prefix = `scratch`
-- - path = `./scratch/text/chapters/1.md` (where "." is the config root)
--
-- it will return `./text/chapters/1.md`
--------------------------------------------------------------------------------
function M.get_source(mirror_type, path)
    path = path or vim.fn.expand('%:p')
    local config = vim.b.lex_config
    return path:gsub(_G.escape(config['mirrors'][mirror_type]['dir']), config['root'], 1)
end

--------------------------------- get_origin ----------------------------------
-- returns the path without any mirrors, even recursively
-------------------------------------------------------------------------------
function M.get_origin(path)
    path = path or vim.fn.expand('%:p')

    local config = vim.b.lex_config

    local mirror_prefixes = {}
    for k, mirror_config in ipairs(config['mirrors']) do
        table.insert(mirror_prefixes, mirror_config['dirPrefix'])
    end

    local path = path:gsub(_G.escape(config['root'] .. '/'), '', 1)

    local origin_path_components = {config['root']}
    for component in vim.gsplit(path, "/") do
        if not vim.tbl_contains(mirror_prefixes, component) then
            table.insert(origin_path_components, component)
        end
    end

    return vim.fn.join(origin_path_components, "/")
end

function M.get_mirror_type(path)
    path = path or vim.fn.expand('%:p')
    local config = vim.b.lex_config

    local mirror_type = nil
    for current_mirror_type, mirror_config in pairs(config['mirrors']) do
        if vim.startswith(path, mirror_config['dir']) then
            mirror_type = current_mirror_type
            break
        end
    end

    return mirror_type
end

----------------------------------- get_path -----------------------------------
-- takes a mirror type and a path.
--
-- cases:
-- - `path` != a mirror: return a `mirrorType` mirror of the `path`
-- - `path` == a mirror:
--   - `mirrorType` == the mirror type of the `path`: return the source of the `path`
--   - `mirrorType` has `mirrorOtherMirrors` = True:
--       - `mirrorOtherMirrors` = True for the mirror type of the path:
--           - return the `mirrorType` mirror of the source of the `path`
--       - `mirrorOtherMirrors` = False for the mirror type of the path:
--           - return the `mirrorType` mirror of the `path`
--   - `mirrorType` has `mirrorOtherMirrors` = False:
--       - return the `mirrorType` mirror of the source of the `path`
--------------------------------------------------------------------------------
function M.get_path(mirror_type, path)
    local path_mirror_type = M.get_mirror_type(path)

    local new_path = nil
    if not path_mirror_type then
        new_path = M.get_mirror(mirror_type, path)
    elseif path_mirror_type == mirror_type then
        new_path = M.get_source(mirror_type, path)
    else
        local config = vim.b.lex_config

        if config['mirrors'][mirror_type]['mirrorOtherMirrors'] then
            if config['mirrors'][path_mirror_type]['mirrorOtherMirrors'] then
                new_path = M.get_mirror(mirror_type, M.get_origin(path))
            else
                new_path = M.get_mirror(mirror_type, path)
            end
        else
            new_path = M.get_mirror(mirror_type, M.get_origin(path))
        end
    end
    
    return new_path
end

function M.add_mappings()
    local config = vim.b.lex_config

    local mapper = require'lex.map'
    for mirror_type, mirror_config in pairs(config['mirrors']) do
        local path = M.get_path(mirror_type)
        local prefix = mirror_config['vimPrefix']
        local args = '"' .. path .. '"'

        mapper.map_prefixed_file_openers(prefix, ":lua require'util'.open_path", args)
    end
end

return M
