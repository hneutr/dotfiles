local Object = require("util.object")
local config = require('lex.config')
local Path = require('util.path')

--[ --------------------------------------------------------------------------------
--                                   Mirror                                   --
--------------------------------------------------------------------------------
-- collected path functions in an object
--
-- a mirror is a file.
--
-- a mirror has a `type`:
-- - origin
-- - MIRROR
--------------------------------------------------------------------------------
Mirror = Object:extend()

function Mirror:new(args)
    args = _G.default_args(args, {path = Path.current_file()})
    self.path = args.path

    self.config = config.get()

    self.type = self.get_type(self.path, self.config)
    self.type_config = vim.tbl_get(self.config.mirrors, self.type) or {}
    self.origin = self:get_origin()

    self.mirrors_other_mirrors = vim.tbl_get(self.type_config, 'mirror_other_mirrors')

    -- self:set_mirrors_other_mirrors()
end


function Mirror.get_type(path, config)
    for mirror, mirror_data in pairs(config.mirrors) do
        if vim.startswith(path, mirror_data.dir) then
            return mirror
        end
    end

    return 'origin'
end

function Mirror:remove_kind_from_path()
    local type_dir = vim.tbl_get(self.type_config, 'dir') or self.config.root

    path = Path.remove_from_start(self.path, type_dir)

    if self.type ~= 'origin' then
        path = Path.join(self.type, path)
    end

    return path
end


function Mirror:get_origin()
    -- if we didn't start in a mirrors dir, return the root path
    if self.type == 'origin' then
        return self
    end

    path = self:remove_kind_from_path()
    path = Mirror._strip_mirrors(path, self.config)
    
    return Mirror({path = Path.join(self.config.root, path) })
end

function Mirror._strip_mirrors(path, config)
    for mirror, _ in pairs(config.mirrors) do
        if vim.startswith(path, mirror) and path ~= mirror .. ".md" then
            path = Path.remove_from_start(path, mirror)
            return Mirror._strip_mirrors(path, config)
        end
    end

    return path
end

function Mirror:set_mirrors_other_mirrors()
    self.mirrors_other_mirrors = vim.tbl_get(self.config.mirrors, self.type, 'mirror_other_mirrors')
end


function Mirror:remove_type()
    local root = self.config.root

    if self.type ~= 'origin' then
        root = self.config.root
    end

    return self.path:gsub(_G.escape(root .. '/'), '', 1)
end


function Mirror:get_mirror_of_type(mirror_type)
    local mirror_type_config = self.config.mirrors[mirror_type]

    local path
    if vim.tbl_get(self.type_config, 'kind') == vim.tbl_get(mirror_type_config, 'kind') then
        path = Mirror:remove_kind_from_path()
    else
        path = Path.remove_from_start(self.path, self.config.root)
    end

    return Mirror({path = Path.join(mirror_type_config.dir, path)})
end


function Mirror:get_location(location_type)
    if self.type == location_type then
        return self.origin
    elseif not self.mirrors_other_mirrors and self.config.mirrors[location_type].mirror_other_mirrors then
        return self:get_mirror_of_type(location_type)
    else
        return self.origin:get_mirror_of_type(location_type)
    end
end

function Mirror:find_updates(new_location, updates)
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
        local m = origin:get_mirror_of_type(_type)
        local new_m = new_origin:get_mirror_of_type(_type)
        updates[m.path] = new_m.path

        if vim.tbl_contains(do_not_mirror_other_mirrors, _type) then
            for j, o_type in ipairs(mirror_other_mirrors) do
                local m_sub = m:get_mirror_of_type(o_type)
                local new_m_sub = new_m:get_mirror_of_type(o_type)
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

function Mirror.open_mirrors_of_kind(kind)
    local origin = Mirror().origin

    Path.open(origin.path, 'tabedit')

    local open_command = "vsplit"
    for mirror_type, mirror_data in pairs(config.get().mirrors) do
        if mirror_data.kind == kind then
            local mirror = origin:get_location(mirror_type)

            if Path.is_file(mirror.path) then
                Path.open(mirror.path, open_command)

                if open_command == "vsplit" then
                    open_command = "split"
                end
            end
        end
    end
end

function Mirror.open(mirror_type, open_command)
    Path.open(Mirror():get_location(mirror_type).path, open_command)
end

--------------------------------------------------------------------------------

return Mirror
