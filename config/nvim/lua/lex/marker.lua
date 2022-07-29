local M = {}
local api = vim.api

local location_path_text_delimiter = ':'
local location_text_flags_delimiter = "?="
local directory_filename = "@"

M.link = {}


--------------------------------------------------------------------------------
--
-- paths
--
--------------------------------------------------------------------------------
function M.path.shorten(path)
    local root = vim.b.projectRoot .. "/"
    return string.gsub(path, root, "")
end

function M.path.expand(path)
    path = string.gsub(path, "^%.", "")
    path = string.gsub(path, "^/", "")

    return vim.b.projectRoot .. "/" .. path
end

--------------------------------------------------------------------------------
--
-- links
--
-- format: [label](location)
--------------------------------------------------------------------------------
function M.link.get(label, location)
    return "[" .. label .. "](" .. location .. ")"
end

function M.link.parse(text)
    return string.match(text, ".*%[(.*)%]%((.*)%).*")
end

--------------------------------------------------------------------------------
--
-- markers
-- 
-- format: [label]()
-- can be preceded by: 
-- - "# "
-- - "# "
-- - "" (nothing)
-- can be followed by: nothing
--------------------------------------------------------------------------------
M.marker = {}

function M.marker.is(text)
    return string.match(text, '^[#>]?%s?%[.+%]%(%)$')
end

function M.marker.parse(text)
    return M.link.parse(text)[1]
end

--------------------------------------------------------------------------------
--
-- locations
-- 
-- format: path:text?=flags
--------------------------------------------------------------------------------
M.location = {}
function M.location.get(path, text, flags)
    flags = flags or {}

    local location = M.path.shorten(path)

    if text then
        location = location .. location_path_text_delimiter .. text
    end

    if vim.tbl_count(flags) then
        location = location .. location_text_flags_delimiter
        for k, v in ipairs(flags) do
            location = location .. v
        end
    end

    return location
end

function M.location.parse(location)
    local path = ''
    local text = ''
    local flags = {}

    local parts = vim.split(location, location_path_text_delimiter)
    for k, v in ipairs(parts) do
        if k == 1 then
            path = v
        else
            text = text .. v
        end
    end

    path = M.path.expand(path)

    local parts = vim.split(text, location_text_flags_delimiter)
    for k, v in ipairs(parts) do
        if k == 1 then
            text = v
        else
            table.insert(flags, v)
        end
    end

    return {path, text, flags}
end

return M
