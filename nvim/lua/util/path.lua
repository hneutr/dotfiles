local fnamemodify = vim.fn.fnamemodify

local Object = require("util.object")

-- TODO:
-- Path.with_suffix(path, suffix)
-- Path.with_name(path, name)
-- Path.with_stem(path, stem)
local Path = Object:extend()

function Path:new(path)
    self.path = tostring(path)
end

function Path:__tostring() return self.path end

-------------------------------------[ eq ]-------------------------------------
function Path:__eq(other)
    return tostring(self) == tostring(other)
end

-----------------------------------[ suffix ]-----------------------------------
-- dir/file.suffix → suffix
function Path.suffix(path)
    return vim.fn.fnamemodify(tostring(path), ':e')
end

------------------------------------[ name ]------------------------------------
-- dir/file.suffix → file.suffix
function Path.name(path)
    return vim.fn.fnamemodify(tostring(path), ":t")
end

------------------------------------[ stem ]------------------------------------
-- dir/file.suffix → file
function Path.stem(path)
    return vim.fn.fnamemodify(Path.name(path), ":r")
end


-----------------------------------[ parent ]-----------------------------------
function Path.parent(path)
    local called_with = path
    local parent = vim.fn.fnamemodify(tostring(path), ":h")
    return Path.match_call_type(called_with, parent)
end

-------------------------------------[ is ]-------------------------------------
function Path.is_file(path)
    return vim.fn.filereadable(tostring(path)) == 1
end

function Path.is_dir(path)
    return vim.fn.isdirectory(tostring(path)) == 1
end

function Path.is_path(thing)
    return Path.is(thing, Path)
end

------------------------------------[ misc ]------------------------------------
function Path.current_file()
    return vim.fn.expand('%:p')
end

------------------------------[ output handling ]-------------------------------
function Path.match_call_type(called_with, to_match)
    to_match = tostring(to_match)
    if Path.is_path(called_with) then
        to_match = Path(to_match)
    end

    return to_match
end

------------------------------------[ trim ]------------------------------------
function Path.ltrim(path)
    local called_with = path
    path = path or ''
    path = tostring(path):gsub("^/", "", 1)
    return Path.match_call_type(called_with, path)
end

function Path.rtrim(path)
    local called_with = path
    path = path or ''
    path = tostring(path):gsub("/$", "", 1)
    return Path.match_call_type(called_with, path)
end

function Path.trim(path)
    return Path.ltrim(Path.rtrim(path))
end

------------------------------------[ join ]------------------------------------
function Path.join(left, right, ...)
    local path = tostring(Path.rtrim(left)) .. '/' .. tostring(Path.ltrim(right))
    path = Path.rtrim(path)

    if ... then
        path = Path.join(path, ...)
    end
    
    return Path.match_call_type(left, path)
end

----------------------------------[ resolve ]-----------------------------------
function Path.resolve(path)
    local called_with = path

    path = tostring(path)

    local new_path
    local pwd = vim.env.PWD
    if vim.startswith(path, pwd) then
        new_path = path
    elseif path == '.' then
        new_path = pwd
    else
        new_path = Path.join(pwd, path)
    end

    return Path.match_call_type(called_with, new_path)
end

-----------------------------[ remove_from_start ]------------------------------
function Path.remove_from_start(path, to_remove)
    local called_with = path

    path = tostring(path):gsub(_G.escape(to_remove), '')
    path = Path.ltrim(path)

    return Path.match_call_type(called_with, path)
end

------------------------------------[ gsub ]------------------------------------
function Path.gsub(path, pattern, replacement, count)
    local called_with = path
    path = path:gsub(_G.escape(pattern), replacement, count)
    return Path.match_call_type(called_with, path)
end

---------------------------------[ make_dirs ]----------------------------------
function Path.make_dirs(path)
    path = Path(path)

    -- if the path has a suffix, only make it's parents into directories
    if path:suffix() ~= '' then
        path = path:parent()
    end

    local current_path = Path('')
    for part in vim.gsplit(tostring(path), '/') do
        current_path = current_path:join(part)

        if tostring(current_path) ~= '' and not current_path:is_dir() then
            vim.cmd("silent! execute '!mkdir " .. tostring(current_path) .. "'")
        end
    end
end

------------------------------------[ open ]------------------------------------
function Path.open(path, open_command)
    open_command = open_command or "edit"

    path = Path(path)
    path:make_dirs()

    if path:is_dir() then
        -- if it's a directory, open a terminal at that directory
        vim.cmd("silent " .. open_command)
        vim.cmd("silent terminal")

        local term_id = vim.b.terminal_job_id

        vim.cmd("silent call chansend(" .. term_id .. ", 'cd " .. tostring(path) .. "\r')")
        vim.cmd("silent call chansend(" .. term_id .. ", 'clear\r')")
    else
        vim.cmd("silent " .. open_command .. " " .. tostring(path))
    end
end

---------------------------------[ list_paths ]---------------------------------
function Path.list_paths(path)
    local paths = {}
    for path, _ in pairs(Path._list_paths(tostring(path))) do
        table.insert(paths, path)
    end

    return paths
end

function Path._list_paths(path)
    local paths = {}
    if Path.is_file(path) then
        paths[path] = true
    else
        for _, stem in ipairs(vim.fn.readdir(path)) do
            subpath = Path.join(path, stem)
            paths = vim.tbl_extend('keep', paths, Path._list_paths(subpath))
        end
    end

    return paths
end

---------------------------------[ list_dirs ]----------------------------------
function Path.list_dirs(path)
    local paths = {}
    for path, _ in pairs(Path._list_dirs(tostring(path))) do
        table.insert(paths, path)
    end

    return paths
end

function Path._list_dirs(path)
    local dirs = {}
    if Path.is_dir(path) then
        dirs[path] = true

        for _, stem in ipairs(vim.fn.readdir(path)) do
            subpath = Path.join(path, stem)
            dirs = vim.tbl_extend('keep', dirs, Path._list_dirs(subpath))
        end
    end

    return dirs
end

----------------------------------[ is_empty ]----------------------------------
function Path.is_empty(path)
    return Path.is_dir(path) and vim.tbl_count(vim.fn.readdir(path)) == 0
end


return Path
