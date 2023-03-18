local Object = require("util.object")
local util = require('util')
local ulines = require('util.lines')
local Path = require('util.path')

local config = require('lex.config')

local M = {}

local location_path_text_delimiter = ':'
local directory_filename = "@"
local fuzzy_actions = { ["ctrl-v"] = 'vsplit', ["ctrl-x"] = 'split', ["ctrl-t"] = 'tabedit' }

--------------------------------------------------------------------------------
--
-- paths
--
--------------------------------------------------------------------------------
M.path = {}

function M.path.shorten(path)
    path = path or vim.fn.expand('%:p')
    local root = config.get()['root'] .. "/"
    return path:gsub(_G.escape(root), "")
end

function M.path.expand(path)
    path = path or vim.fn.expand('%:p')
    path = path:gsub("^%.", "")

    local root = config.get()['root']

    if not vim.startswith(path, root) then
        path = _G.joinpath(config.get()['root'], path)
    end

    return path
end

--------------------------------------------------------------------------------
--                                    Link                                     
--------------------------------------------------------------------------------
-- format: [label](location)
-- preceded by: any
-- followed by: any
--------------------------------------------------------------------------------
Link = Object:extend()

Link.regex = "%s*(.-)%[(.-)%]%((.-)%)(.*)"
Link.defaults = {
    label = '',
    location = '',
    before = '',
    after = '',
}

function Link:new(args)
    for key, val in pairs(_G.default_args(args, Link.defaults)) do
        self[key] = val
    end
end

function Link.str_is_a(str) return str:match(Link.regex) ~= nil end

function Link:str() return "[" .. self.label .. "](" .. self.location .. ")" end

function Link.from_str(str)
    str = str or ulines.cursor.get()

    local before, label, location, after = str:match(Link.regex)

    return Link({label = label, location = location, before = before, after = after})
end

function Link.get_nearest()
    local str = ulines.cursor.get()
    local cursor_col = vim.api.nvim_win_get_cursor(0)[2]

    local _start, _end = 0, 1
    local start_to_link = {}
    local end_to_link = {}
    while true do
        if Link.str_is_a(str) then
            local link = Link.from_str(str)

            _start = _end + link.before:len()
            start_to_link[_start] = link

            _end = _start + link:str():len() + 1
            end_to_link[_end] = link

            str = link.after
        else
            break
        end
    end

    local starts = vim.tbl_keys(start_to_link)
    table.sort(starts, function(a, b) return math.abs(a - cursor_col) < math.abs(b - cursor_col) end)

    local ends = vim.tbl_keys(end_to_link)
    table.sort(ends, function(a, b) return math.abs(a - cursor_col) < math.abs(b - cursor_col) end)

    local nearest_start = starts[1]
    local nearest_end = ends[1]

    if math.abs(nearest_start - cursor_col) <= math.abs(nearest_end - cursor_col) then
        return start_to_link[nearest_start]
    else
        return end_to_link[nearest_end]
    end
end


M.Link = Link
--------------------------------------------------------------------------------
--                                  Location                                   
--------------------------------------------------------------------------------
-- format: path:text
--------------------------------------------------------------------------------
Location = Object:extend()

Location.regex = "(.-)" .. location_path_text_delimiter .."(.*)"

function Location:new(args)
    args = _G.default_args(args, {path = vim.fn.expand('%:p'), text = ''})
    self.path = args.path
    self.text = args.text
end

function Location:str()
    local str = M.path.shorten(self.path)

    if self.text:len() > 0 then
        str = str .. location_path_text_delimiter .. self.text
    end

    return str
end

function Location.str_has_text(str) return str:find(location_path_text_delimiter) end

function Location.from_str(str)
    str = str or Link.get_nearest().location

    local path, text

    if Location.str_has_text(str) then
        path, text = str:match(Location.regex)
    else
        path = str
    end

    path = M.path.expand(path)

    return Location({path = path, text = text})
end

function Location.from_mark_rg_str(str)
    local path, str = unpack(vim.fn.split(str, ':'))
    local mark = Mark.from_str(str)

    return Location({path = path, text = mark.text})
end

Location.list = {}
Location.list.find_files_cmd = "fd -tf '' "

function Location.list.find_files(path)
    path = path or config.get()['root']
    return vim.fn.systemlist(Location.list.find_files_cmd .. path)
end

function Location.list.all(args)
    local locations = table.concatenate(Location.list.marks(args), Location.list.files(args))

    table.sort(locations, function(a, b) return a < b end)

    return locations
end

function Location.list.marks(args)
    args = _G.default_args(args, {as_str = true})

    local locations = {}
    for i, str in ipairs(Mark.find_all()) do
        if Mark.rg_str_is_a(str) then
            local location = Location.from_mark_rg_str(str)

            if args.as_str then
                location = location:str()
            end

            table.insert(locations, location)
        end
    end

    return locations
end

function Location.list.files(args)
    args = _G.default_args(args, {as_str = true})

    local locations = {}
    for i, path in ipairs(Location.list.find_files()) do
        local location = Location({path = path})

        if args.as_str then
            location = location:str()
        end

        table.insert(locations, location)
    end

    return locations
end

function Location.goto(open_command, str)
    local location = Location.from_str(str)

    if location.path ~= vim.fn.expand('%:p') then
        util.open_path(location.path, open_command)
    end

    if location.text:len() > 0 then
        Mark.goto(location.text)
    end
end

function Location.update(args)
    args = _G.default_args(args, {old_location = nil, new_location = nil, scope = 'buffer'})

    local old = args.old_location:gsub('/', '\\/')
    local new = args.new_location:gsub('/', '\\/')

    if args.scope == 'buffer' then
        local cursor = vim.api.nvim_win_get_cursor(0)

        local cmd = "%s/\\](" .. old .. ")/\\](" .. new .. ")/g"
        pcall(function() vim.cmd(cmd) return end)
        vim.api.nvim_win_set_cursor(0, cursor)
    elseif args.scope == 'project' then
        -- turns out this is a lot slower than just using python...
        local root = require('lex.config').get()['root']

        local pattern = '\\](' .. old .. ')'
        local replace = '\\](' .. new .. ')'
        local sed_exp = "s/" .. pattern .. "/" .. replace .. "/gI"
        local cmd = "cd " .. root .. " && find . -type f -exec gsed -i '" .. sed_exp .. "' {} \\;"

        vim.fn.system(cmd)
    end
end


M.Location = Location

--------------------------------------------------------------------------------
--                                    Mark                                     
--------------------------------------------------------------------------------
-- format: [text]()
-- preceded by: any
-- followed by: Flag or none
--------------------------------------------------------------------------------
Mark = Object:extend()
Mark.defaults = {
    text = '',
    before = '',
    after = '',
}
Mark.rg_cmd = "rg '\\[.*\\]\\(\\)' --no-heading "

function Mark:new(args)
    for key, val in pairs(_G.default_args(args, self.defaults)) do
        self[key] = val
    end
end

function Mark:str() return Link({label = self.text}):str() end

function Mark.find_all(path)
    path = path or config.get()['root']
    return vim.fn.systemlist(Mark.rg_cmd .. path)
end

function Mark.str_is_a(str)
    str = str or ulines.cursor.get()

    if not Link.str_is_a(str) then
        return false
    end

    local before, label, location, after = str:match(Link.regex)

    if location:len() > 0 then
        return false
    end

    return true
end

function Mark.rg_str_is_a(str)
    local path, str = unpack(vim.fn.split(str, ':'))
    return Mark.str_is_a(str)
end

function Mark.from_str(str)
    str = str or ulines.cursor.get()

    local before, text, location, after = str:match(Link.regex)
    return Mark({text = text, before = before, after = after})
end

function Mark.goto(str)
    str = str or ulines.cursor.get()
    for i, line in ipairs(ulines.get()) do
        if line:len() > 0 then
            if Mark.str_is_a(line) and Mark.from_str(line).text == str then
                vim.api.nvim_win_set_cursor(0, {i, 0})
                vim.cmd("normal zz")
                break
            end
        end
    end
end


M.Mark = Mark
--------------------------------------------------------------------------------
--                                  Reference                                  
--------------------------------------------------------------------------------
-- format: [text](location)
-- preceded by: any
-- followed by: any
--------------------------------------------------------------------------------
Reference = Object:extend()
Reference.defaults = {
    text = '',
    location = nil,
    before = '',
    after = '',
}

function Reference:new(args)
    args = _G.default_args(args, self.defaults)
    self.location = args.location
    self.before = args.before
    self.after = args.after
    self.text = Reference.default_text(args.text, self.location)
end

Reference.rg_cmd = "rg '\\[.*\\]\\(.+\\)' --no-heading --no-filename --no-line-number --hidden " 
Reference.by_file_rg_cmd = "rg '\\[.*\\]\\(.+\\)' --no-heading --line-number --hidden " 

function Reference.default_text(text, location)
    if text:len() > 0 then
        return text
    end

    if location.text:len() > 0 then
        text = location.text
    else
        text = vim.fn.fnamemodify(location.path, ':t:r')

        if text == directory_filename then
            text = vim.fn.fnamemodify(location.path, ":p:h:t")
        end
    end

    text = text:gsub("%-", " ")
    return text
end


function Reference.str_is_a(str) return Link.str_is_a(str) end


function Reference:str()
    return Link({label = self.text, location = self.location:str()}):str()
end


function Reference.from_str(str)
    str = str or ulines.cursor.get()

    local before, text, location, after = str:match(Link.regex)
    location = Location({text = text})

    return Reference({text = text, location = location, before = before, after = after})
end

function Reference.from_path(path)
    path = path or vim.fn.expand('%:p')
    return Reference{ location = Location.from_str(path)}
end


function Reference.list(args)
    args = _G.default_args(args, {include_path_references = false, path = config.get()['root']})

    local cmd = Reference.rg_cmd .. args.path

    local references = {}
    for i, str in ipairs(vim.fn.systemlist(cmd)) do
        while Reference.str_is_a(str) do
            local before, text, raw_location, after = str:match(Link.regex)

            if not vim.startswith(raw_location, "http") then
                location = Location.from_str(raw_location)

                if location.text:len() > 0 or args.include_path_references then
                    references[location:str()] = true
                end
            end

            str = after
        end
    end

    return references
end

function Reference.list_by_file(args)
    args = _G.default_args(args, { path = config.get()['root'] })

    local cmd = Reference.by_file_rg_cmd .. args.path

    local references = {}
    for i, str in ipairs(vim.fn.systemlist(cmd)) do
        local path, line_number, ref_str
        for part in vim.gsplit(str, ':') do
            if not path then
                path = part
            elseif not line_number then
                line_number = tonumber(part)
            elseif not ref_str then
                ref_str = part
            else
                ref_str = ref_str .. ':' .. part
            end
        end

        local path_refs = vim.tbl_get(references, path) or {}

        if not vim.tbl_get(path_refs, line_number) then
            path_refs[line_number] = ref_str
        end

        references[path] = path_refs
    end

    return references
end

M.Reference = Reference
--------------------------------------------------------------------------------
--                                   Flagset                                   
--------------------------------------------------------------------------------
-- format: [](flags)
-- precededb by: Mark or Reference
-- followed by: any
--------------------------------------------------------------------------------
Flag = Object:extend()
Flag.defaults = {
    before = '',
    after = '',
}
Flag.types = require('lex.constants').flags

function Flag:new(args)
    for key, val in pairs(_G.default_args(args, Flag.defaults)) do
        self[key] = val
    end
end

function Flag.regex()
    local flag_characters = ""
    for _, flag_info in ipairs(Flag.types) do
        flag_characters = flag_characters .. flag_info.regex_symbol
    end

    local before_re = "(.-)"
    local link_start_re = "%[%]%("
    local flags_re = "([" .. flag_characters .. "]+)"
    local link_end_re = "%)"
    local after_re = "(.*)"

    return before_re .. link_start_re .. flags_re .. link_end_re .. after_re
end

function Flag.str_is_a(str) 
    local before, location, after = str:match(Flag.regex())

    if location ~= nil then
        local partial_location = location
        for _, flag_info in ipairs(Flag.types) do
            partial_location = partial_location:gsub(flag_info.regex_symbol, '')
        end

        if partial_location:len() == 0 then
            return true
        end
    end

    return false
end

function Flag:__tostring()
    local text = ""

    for _, flag_info in ipairs(self.types) do
        if self[flag_info.name] then
            text = text .. flag_info.symbol
        end
    end

    return "[](" .. text .. ")"
end

function Flag.from_str(str)
    str = str or ulines.cursor.get()

    local args = {}
    local before, flags_string, after = str:match(Flag.regex())

    args.before = before
    args.after = after

    for _, flag_info in ipairs(Flag.types) do
        if flags_string:find(flag_info.regex_symbol) then
            args[flag_info.name] = true
        end
    end

    return Flag(args)
end


function Flag.write_find_command(flag_type, file_path)
    local other_flags_re = "["
    local symbol
    for _, flag_info in ipairs(Flag.types) do
        if flag_info.name ~= flag_type then
            other_flags_re = other_flags_re .. "\\" .. flag_info.symbol
        else
            symbol = flag_info.symbol
        end
    end

    other_flags_re = other_flags_re .. "]?"
    local location_re = other_flags_re .. [[\]] .. symbol .. other_flags_re

    local pwd = vim.env.PWD
    config.set(pwd)
    local path = path or config.get()['root']
    local command = [[rg --no-heading "\[\]\(]] .. location_re ..  [[\)"]]
    Path.write(file_path, {"cd " .. path, command, "cd " .. pwd})
end

M.Flag = Flag
--------------------------------------------------------------------------------
--                                fuzzy finding                                
--------------------------------------------------------------------------------
M.fuzzy = { sink = {} }

--------------------------------------------------------------------------------
-- testing
--------------------------------------------------------------------------------
function M.fuzzy._do(actions)
    require'fzf-lua'.fzf_exec(M.Location.list.all(), {actions = actions})
end

function M.fuzzy.goto()
    M.fuzzy._do({
        ["default"] = function(selected, opts) Location.goto("edit", selected[1]) end,
        ["ctrl-j"] = function(selected, opts) Location.goto("split", selected[1]) end,
        ["ctrl-l"] = function(selected, opts) Location.goto("vsplit", selected[1]) end,
        ["ctrl-t"] = function(selected, opts) Location.goto("tabedit", selected[1]) end,
    })
end

function M.fuzzy.put()
    local fn = function(items)
        local ref = Reference{location = Location.from_str(items[1])}
        vim.api.nvim_put({ref:str()} , 'c', 1, 0)
    end

    M.fuzzy._do({
        ["default"] = fn,
        ["ctrl-j"] = fn,
        ["ctrl-l"] = fn,
        ["ctrl-t"] = fn,
    })
end

function M.fuzzy.insert()
    local fn = function(selected) M.fuzzy.insert_selection(selected[1]) end

    M.fuzzy._do({
        ["default"] = fn,
        ["ctrl-j"] = fn,
        ["ctrl-l"] = fn,
        ["ctrl-t"] = fn,
    })
end

function M.fuzzy.insert_selection(selection)
    local line = ulines.cursor.get()
    local line_number, column = unpack(vim.api.nvim_win_get_cursor(0))

    local insert_command = 'i'

    if column == line:len() - 1 then
        column = column + 1
        insert_command = 'a'
    elseif column == 0 then
        insert_command = 'a'
    end

    local content = Reference{location = Location.from_str(selection)}:str()

    local new_line = line:sub(1, column) .. content .. line:sub(column + 1)
    local new_column = column + content:len()

    ulines.cursor.set({ replacement = { new_line } })

    vim.api.nvim_win_set_cursor(0, {line_number, new_column})
    vim.api.nvim_input(insert_command)
end

return M
