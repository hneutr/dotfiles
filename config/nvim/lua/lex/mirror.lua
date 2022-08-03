local M = {}
local config = require'lex.config'

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
    local m_config = config.get()['mirrors'][mirror_type]
    return path:gsub(_G.escape(m_config['root']), m_config['dir'], 1)
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
    local m_config = config.get()['mirrors'][mirror_type]
    return path:gsub(_G.escape(m_config['dir']), m_config['root'], 1)
end

--------------------------------- get_origin ----------------------------------
-- returns the path without any mirrors, even recursively
-------------------------------------------------------------------------------
function M.get_origin(path)
    path = path or vim.fn.expand('%:p')

    local _config = config.get()

    local mirror_prefixes = {}
    for k, mirror_config in ipairs(_config['mirrors']) do
        table.insert(mirror_prefixes, mirror_config['dirPrefix'])
    end

    local path = path:gsub(_G.escape(_config['root'] .. '/'), '', 1)

    local origin_path_components = {_config['root']}
    for component in vim.gsplit(path, "/") do
        if not vim.tbl_contains(mirror_prefixes, component) then
            table.insert(origin_path_components, component)
        end
    end

    return vim.fn.join(origin_path_components, "/")
end

function M.get_mirror_type(path)
    path = path or vim.fn.expand('%:p')

    local mirror_type = nil
    for current_mirror_type, mirror_config in pairs(config.get()['mirrors']) do
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
        local _config = config.get()

        if _config['mirrors'][mirror_type]['mirrorOtherMirrors'] then
            if _config['mirrors'][path_mirror_type]['mirrorOtherMirrors'] then
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

return M
