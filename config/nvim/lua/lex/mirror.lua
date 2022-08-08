require'class'
local M = {}
local config = require'lex.config'


--------------------------------------------------------------------------------
--                                Location                                    --
--------------------------------------------------------------------------------
-- collected path functions in an object
--
-- a location is a file.
--
-- a location has a `type`:
-- - origin
-- - mirror
--------------------------------------------------------------------------------
MLocation = class(function(self, args)
    args = _G.default_args(args, { path = vim.fn.expand('%:p') })
    self.path = args.path

    self.config = config.get()

    self:set_type()
    self:set_origin()
    self:set_mirrors_other_mirrors()
end)

function MLocation:set_origin()
    -- if we didn't start in a mirrors dir, return the root path
    if self.type == 'origin' then
        self.origin = self
        return
    end

    local path = self:remove_type()

    while true do
        local subbed_this_round = false

        for mirror_type, mirror_config in pairs(self.config.mirrors) do
            local prefix = mirror_config.dirPrefix .. '/'

            if vim.startswith(path, prefix) then
                subbed_this_round = true
                path = path:gsub(prefix, '', 1)
                break
            end
        end

        if subbed_this_round then
            subbed_this_round = false
        else
            break
        end
    end
    
    self.origin = MLocation({path = _G.joinpath(self.config.root, path) })
end

function MLocation:set_type()
    local root = self.config.root
    if vim.startswith(self.path, self.config.mirrors_root) then
        root = self.config.mirrors_root
    end

    local path = self.path:gsub(_G.escape(root .. '/'), '', 1)

    self.type = 'origin'

    for _type, _config in pairs(self.config.mirrors) do
        if vim.startswith(path, _config.dirPrefix .. '/') then
            self.type = _type
            break
        end
    end

    return
end


function MLocation:set_mirrors_other_mirrors()
    local mirror_config = vim.tbl_get(self.config.mirrors, self.type) or {}
    self.mirrors_other_mirrors = vim.tbl_get(mirror_config, 'mirrorOtherMirrors') or false
end


function MLocation:remove_type()
    local root = self.config.root

    if self.type ~= 'origin' then
        root = self.config.mirrors_root
    end

    return self.path:gsub(_G.escape(root .. '/'), '', 1)
end


function MLocation:get_location_of_type(location_type)
    local path = self:remove_type()
    path = _G.joinpath(self.config.mirrors[location_type].dir, path)
    return MLocation({ path = path })
end


function MLocation:get_location(location_type)
    local location
    if self.type == location_type then
        location = self.origin
    elseif not self.mirrors_other_mirrors and self.config.mirrors[location_type].mirrorOtherMirrors then
        location = self:get_location_of_type(location_type)
    else
        location = self.origin:get_location_of_type(location_type)
    end

    return location
end

M.MLocation = MLocation

--------------------------------------------------------------------------------

function M.open(mirror_type, open_command)
    require'util'.open_path(MLocation():get_location(mirror_type).path, open_command)
end

------------------------------------ get_mirror ---------------------------------
-- gets the equivalent location of a file for a given prefix.
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
-- gets the "real" location of a file, one with a prefix.
--
-- For example, if: 
-- - mirror_type = `scratch`
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
    for mirror_type, mirror_config in pairs(_config['mirrors']) do
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
    for current_mirror_type, mirror_config in pairs(config.get()['mirrors']) do
        if vim.startswith(path, mirror_config['dir']) then
            return current_mirror_type
        end
    end
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
