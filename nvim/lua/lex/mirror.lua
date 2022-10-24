local M = {}
local class = require'util.class'
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
            local prefix = mirror_config.dir_prefix .. '/'

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
    local path = require('util.path').remove_from_start(self.path, self.config.root)

    self.type = 'origin'

    for _type, _config in pairs(self.config.mirrors) do
        if vim.startswith(path, _config.dir_prefix) then
            self.type = _type
            break
        end
    end

    return
end


function MLocation:set_mirrors_other_mirrors()
    local mirror_config = vim.tbl_get(self.config.mirrors, self.type) or {}
    self.mirrors_other_mirrors = vim.tbl_get(mirror_config, 'mirror_other_mirrors') or false
end


function MLocation:remove_type()
    local root = self.config.root

    if self.type ~= 'origin' then
        root = self.config.root
    end

    return self.path:gsub(_G.escape(root .. '/'), '', 1)
end


function MLocation:get_location_of_type(location_type)
    local path = self:remove_type()
    path = _G.joinpath(self.config.mirrors[location_type].dir, path)
    return MLocation({ path = path })
end


function MLocation:get_location(location_type)
    if self.type == location_type then
        return self.origin
    elseif not self.mirrors_other_mirrors and self.config.mirrors[location_type].mirror_other_mirrors then
        return self:get_location_of_type(location_type)
    else
        return self.origin:get_location_of_type(location_type)
    end
end

function MLocation:find_updates(new_location, updates)
    local do_not_mirror_other_mirrors = {}
    local mirror_other_mirrors = {}
    local types = {}

    for _type, _config in pairs(config.get()['mirrors']) do
        table.insert(types, _type)
        if _config.mirror_other_mirrors then
            table.insert(mirror_other_mirrors, _type)
        else
            table.insert(do_not_mirror_other_mirrors, _type)
        end
    end

    local origin = self.origin
    local new_origin = new_location.origin
    local updates = {}

    updates[origin.path] = new_origin.path

    for i, _type in ipairs(types) do
        local m = origin:get_location_of_type(_type)
        local new_m = new_origin:get_location_of_type(_type)
        updates[m.path] = new_m.path

        if vim.tbl_contains(do_not_mirror_other_mirrors, _type) then
            for j, o_type in ipairs(mirror_other_mirrors) do
                local m_sub = m:get_location_of_type(o_type)
                local new_m_sub = new_m:get_location_of_type(o_type)
                updates[m_sub.path] = new_m_sub.path
            end
        end
    end

    for key, val in pairs(updates) do
        if not _G.filereadable(key) then
            updates[key] = nil
        end
    end

    return updates
end

M.MLocation = MLocation

--------------------------------------------------------------------------------

function M.open(mirror_type, open_command)
    require('util').open_path(MLocation():get_location(mirror_type).path, open_command)
end

return M
