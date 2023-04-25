local Object = require("util.object")
local ulines = require('util.lines')
local Path = require('util.path')
local Constants = require('lex.constants')

local config = require('lex.config')

local fuzzy_actions = {
    ["default"] = "edit",
    ["ctrl-j"] = "split",
    ["ctrl-l"] = "vsplit",
    ["ctrl-t"] = "tabedit",
}

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

function Link:new(args) self = table.default(self, args, self.defaults) end

function Link.str_is_a(str) return str:match(Link.regex) ~= nil end

function Link:str() return "[" .. self.label .. "](" .. self.location .. ")" end

function Link.from_str(str)
    str = str or ulines.cursor.get()

    local before, label, location, after = str:match(Link.regex)

    return Link({label = label, location = location, before = before, after = after})
end

function Link.get_nearest(str)
    str = str or ulines.cursor.get()
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


--------------------------------------------------------------------------------
--                                  Location                                   
--------------------------------------------------------------------------------
-- format: path:text
--------------------------------------------------------------------------------
Location = Object:extend()

Location.regex = "(.-)" .. Constants.path_label_delimiter .."(.*)"

function Location:new(args)
    self = table.default(self, args, {path = Path.current_file(), text = ''})
end

function Location:str()
    local str = Path.remove_from_start(self.path, config.get()['root'])

    if self.text:len() > 0 then
        str = str .. Constants.path_label_delimiter .. self.text
    end

    return str
end

function Location.str_has_text(str) return str:find(Constants.path_label_delimiter) end

function Location.from_str(str)
    str = str or Link.get_nearest(ulines.cursor.get()).location

    local path, text

    if Location.str_has_text(str) then
        path, text = str:match(Location.regex)
    else
        path = str
    end

    path = Path.join(config.get()['root'], path)

    return Location({path = path, text = text})
end

function Location.from_mark_rg_str(str)
    local path, str = unpack(vim.fn.split(str, ':'))
    local mark = Mark.from_str(str)
    return Location({path = path, text = mark.text})
end

Location.list = {}
Location.list.find_files_cmd = "fd -tf '' "

function Location.list.find_files()
    return vim.fn.systemlist(Location.list.find_files_cmd .. config.get()['root'])
end

function Location.list.all(args)
    local locations = table.concatenate(Location.list.marks(args), Location.list.files(args))
    table.sort(locations, function(a, b) return a < b end)
    return locations
end

function Location.list.marks(args)
    args = table.default(args, {as_str = true})

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
    args = table.default(args, {as_str = true})

    local locations = {}
    for _, path in ipairs(Location.list.find_files()) do
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

    if location.path ~= Path.current_file() then
        Path.open(location.path, open_command)
    end

    if location.text:len() > 0 then
        Mark.goto(location.text)
    end
end

function Location.update(args)
    args = table.default(args, {old_location = nil, new_location = nil, scope = 'buffer'})

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

function Mark:new(args) self = table.default(self, args, self.defaults) end

function Mark:str() return Link({label = self.text}):str() end

function Mark.find_all() return vim.fn.systemlist(Mark.rg_cmd .. config.get()['root']) end

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
    self = table.default(self, args, self.defaults)
    self.text = Reference.default_text(self.text, self.location)
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
        text = Path.stem(location.path)

        if text == Constants.dir_file_stem then
            text = Path.stem(Path.parent(location.path))
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
    return Reference({text = text, location = Location({text = text}), before = before, after = after})
end

function Reference.list(args)
    args = table.default(args, {path = config.get()['root']})

    local cmd = Reference.rg_cmd .. args.path

    local references = {}
    for i, str in ipairs(vim.fn.systemlist(cmd)) do
        while Reference.str_is_a(str) do
            local before, text, raw_location, after = str:match(Link.regex)

            if not vim.startswith(raw_location, "http") then
                location = Location.from_str(raw_location)

                if location.text:len() > 0 then
                    references[location:str()] = true
                end
            end

            str = after
        end
    end

    return references
end

function Reference.list_by_file(args)
    local cmd = Reference.by_file_rg_cmd .. config.get()['root']

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

--------------------------------------------------------------------------------
--                                fuzzy finding                                
--------------------------------------------------------------------------------
fuzzy = { sink = {} }

function fuzzy._do(fn)
    local actions = {}
    for key, action in pairs(fuzzy_actions) do
        actions[key] = function(selected) fn(selected[1], action) end
    end

    require('fzf-lua').fzf_exec(Location.list.all(), {actions = actions})
end

function fuzzy.goto()
    fuzzy._do(function(location, action) Location.goto(action, location) end)
end

function fuzzy.put()
    fuzzy._do(function(location)
        vim.api.nvim_put({Reference({location = Location.from_str(location)}):str()} , 'c', 1, 0)
    end)
end

function fuzzy.insert()
    fuzzy._do(fuzzy.insert_selection)
end

function fuzzy.insert_selection(location)
    local line = ulines.cursor.get()
    local line_number, column = unpack(vim.api.nvim_win_get_cursor(0))

    local insert_command = 'i'

    if column == line:len() - 1 then
        column = column + 1
        insert_command = 'a'
    elseif column == 0 then
        insert_command = 'a'
    end

    local content = Reference({location = Location.from_str(location)}):str()

    local new_line = line:sub(1, column) .. content .. line:sub(column + 1)
    local new_column = column + content:len()

    ulines.cursor.set({replacement = {new_line}})

    vim.api.nvim_win_set_cursor(0, {line_number, new_column})
    vim.api.nvim_input(insert_command)
end

return {
    Link = Link,
    Location = Location,
    Reference = Reference,
    Flag = Flag,
    Mark = Mark,
    fuzzy = fuzzy,
}
