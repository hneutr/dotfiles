local project = require'lex.project'
local util = require'util'
local line_utils = require'lines'

local M = {}

local location_path_text_delimiter = ':'
local location_text_flags_delimiter = "?="
local directory_filename = "@"
local fuzzy_actions = { ["ctrl-v"] = 'vsplit', ["ctrl-x"] = 'split', ["ctrl-t"] = 'tabedit' }

--------------------------------------------------------------------------------
--
-- paths
--
--------------------------------------------------------------------------------
M.path = {}

function M.path.shorten(path)
    local root = project.get_config()['root'] .. "/"
    return path:gsub(_G.escape(root), "")
end

function M.path.expand(path)
    path = path:gsub("^%.", "")
    path = path:gsub("^/", "")

    return project.get_config()['root'] .. "/" .. path
end

--------------------------------------------------------------------------------
--
-- links
--
-- format: [label](location)
--------------------------------------------------------------------------------
M.link = {}

function M.link.get(label, location)
    return "[" .. label .. "](" .. location .. ")"
end

function M.link.parse(text)
    return text:match(".*%[(.*)%]%((.*)%).*")
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

function M.marker.is(str)
    str = str or line_utils.cursor.get()
    local match = str:match('^[#>]%s%[(.+)%]%(%)$')
    return match or str:match('^%[(.+)%]%(%)$')
end

function M.marker.parse(str)
    str = str or line_utils.cursor.get()
    return M.marker.is(str)
end

function M.marker.find(str)
    str = str or line_utils.cursor.get()
    for i, line in ipairs(require'lines'.get()) do
        if line:len() > 0 then
            if M.marker.is(line) and M.marker.parse(line) == str then
                vim.api.nvim_win_set_cursor(0, {i, 0})
                vim.cmd("normal zz")
                break
            end
        end
    end
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
    text = text or ''

    local location = M.path.shorten(path)

    if text:len() > 0 then
        location = location .. location_path_text_delimiter .. text
    end

    if vim.tbl_count(flags) > 0 then
        location = location .. location_text_flags_delimiter
        for k, v in ipairs(flags) do
            location = location .. v
        end
    end

    return location
end

function M.location.parse(str)
    str = str or vim.fn['lib#getTextInsideNearestParenthesis']()

    local path = ''
    local text = ''
    local flags = {}

    local parts = vim.split(str, location_path_text_delimiter)
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

function M.location.rg_parse(str)
    local path, text = unpack(vim.fn.split(str, ':[#>] ['))

    -- path = path:gsub(_G.escape(root .. '/'), '')
    text = text:gsub(']%(%)', '')

    return path, text
end

function M.location.goto(open_command, str)
    local path, text, flags = unpack(M.location.parse(str))

    -- if the file isn't the one we're currently editing, open it
    if path ~= vim.fn.expand('%:p') then
        util.open_path(path, open_command)
    end

    if text:len() > 0 then
        M.marker.find(text)
    end
end

function M.location.list()
    local root = project.get_config()['root']
    local list_markers_cmd = "rg '^[#>] \\[.*\\]\\(\\)$' --no-heading " .. root
    local list_files_command = "fd -tf '' " .. root

    local locations = {}
    for i, str in ipairs(vim.fn.systemlist(list_markers_cmd)) do
        table.insert(locations, M.location.get(M.location.rg_parse(str)))
    end

    for i, path in ipairs(vim.fn.systemlist(list_files_command)) do
        table.insert(locations, M.location.get(path))
    end

    table.sort(locations, util.sort_ascending)
    return locations
end

--------------------------------------------------------------------------------
--
-- references
--
-- format: [label](location)
--------------------------------------------------------------------------------
M.reference = {}

function M.reference.get(args)
    args = _G.default_args(args, { path = vim.fn.expand('%'), text = M.marker.parse() or '' })

    local location = M.location.get(args.path, args.text)

    local label

    if args.text:len() > 0 then
        label = args.text
    else
        label = vim.fn.fnamemodify(args.path, ':t:r')

        if label == directory_filename then
            label = vim.fn.fnamemodify(args.path, ":p:h:t")
        end
    end

    label = label:gsub("%-", " ")

    return M.link.get(label, location)
end

function M.reference.update(references)
    local cmd = "hnetext update-references"
    cmd = cmd .. " --references '" .. vim.fn.json_encode(references) .. "'"

    vim.fn.system(cmd)
end


---------------------------------------------------------------------------------
--
-- fuzzy finding
--
---------------------------------------------------------------------------------
M.fuzzy = { sink = {} }

function M.fuzzy.start(fn)
    local wrap = vim.fn["fzf#wrap"]({ source = M.location.list()})
    -- wrap['sink*'] = function(a:fn)
    wrap['_action'] = fuzzy_actions
    wrap['options'] = ' +m -x --ansi --prompt "References: " --expect=ctrl-v,ctrl-x,ctrl-t'

    return vim.fn["fzf#run"](wrap)
end

function M.fuzzy.sink.goto(lines)
    local cmd = vim.tbl_get(fuzzy_actions, lines[1]) or "edit"
    M.location.goto(cmd, lines[2])
end

function M.fuzzy.sink.put(lines)
    vim.api.nvim_put({M.fuzzy.get_pick(lines[2])} , 'c', 1, 0)
end

function M.fuzzy.sink.insertPut(lines)
    local line = line_utils.cursor.get()
    local column = vim.api.nvim_win_get_cursor(0)[2] + 1

    local paste_cmd = 'P'
    if column == line:len() or line:len() == 0 then
        paste_cmd = 'p'
    end

    local paste_register_pre = vim.fn.getreg('"')
    vim.fn.setreg('"', M.fuzzy.get_pick(lines[2]))
    vim.api.nvim_input('<ctrl-o>' .. paste_cmd .. 'a')
    vim.fn.setreg('"', paste_register_pre)
end

function M.fuzzy.get_pick(str)
    local path, text, flags = unpack(M.location.parse(str))
    return M.reference.get({ path = path, text = text })
end

return M 
