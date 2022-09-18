local M = {}
local l = require('lex.link')
local ulines = require('util.lines')
local mirror = require('lex.mirror')
local util = require('util')
local path = require('util.path')


local DIR_FILE_NAME = require('lex.constants').dir_file_name

--------------------------------------------------------------------------------
--                                    move                                    --
--------------------------------------------------------------------------------
function M.move(src, dst)
    src = path.resolve(src)
    dst = path.resolve(dst)

    require('lex.config').set(vim.env.PWD)
    vim.g.lex_sync_ignore = true
    
    if M.is_location(src) then
        M.move_location(src, dst)
    else
        M.move_path(src, dst)
    end
    
    vim.g.lex_sync_ignore = true
end

function M.move_path(src, dst)
    dst = M.infer.destination(src, dst)
    updates = M.get_updates(src, dst)
    
    M.update_paths(updates)
    M.update_references(updates)
end

function M.move_location(src, dst)
    local lines = M.remove_mark_lines(src)
    M.move_mark_lines(lines, dst)
    M.update_references({[src] = dst})
end

function M.remove_mark_lines(src)
    l.Location.goto('edit', src)

    local start_line = vim.fn.getpos('.')[2] - 1
    local end_line

    local mark_lines = {}
    for i, line in ipairs(require('util.lines').get()) do
        if i > start_line + 2 and M.line_is_divider(line) then
            end_line = i - 1
            break
        elseif i >= start_line then
            table.insert(mark_lines, line)
        end
    end

    require('util.lines').cut({start_line = start_line - 1, end_line = end_line})

    return mark_lines
end

function M.move_mark_lines(lines, dst)
    -- if we're moving a marker to a file, remove the marker header
    if not M.is_location(dst) then
        for i = 1, 3 do
            table.remove(lines, 1)
        end
    end

    -- remove excess whitespace
    while string.gsub(lines[#lines], "%s*", "") == "" do
        table.remove(lines, #lines)
    end

    l.Location.goto('edit', dst)
    vim.api.nvim_input('G')

    if vim.fn.getline('.') ~= '' then
        vim.api.nvim_put({""}, "l", true, true)
        vim.api.nvim_input('G')
    end

    vim.api.nvim_put(lines, "l", false, true)
    vim.api.nvim_input('dd')
end

function M.is_location(path)
    return string.match(path, ":")
end

function M.line_is_divider(line)
    local dividers = {
        require("snips.markdown").divider.big.str(),
        require("snips.markdown").divider.small.str(),
    }

    for _, divider in ipairs(dividers) do
        if line == divider then
            return true
        end
    end
end

--------------------------------------------------------------------------------
--                                get_updates                                 --
--------------------------------------------------------------------------------
function M.get_updates(src, dst)
    local root = require'lex.config'.get().root
    local src_stem = path.remove_from_start(src, root)
    local dst_stem = path.remove_from_start(dst, root)

    local updates = {}
    for _, src_path in ipairs(path.list_paths(src)) do
        dst_path = path.gsub(src_path, src_stem, dst_stem, 1)

        dst_path = M.handle_dir_into_parent(src, dst, src_path, dst_path)

        local src_loc = mirror.MLocation({path = src_path})
        local dst_loc = mirror.MLocation({path = dst_path})

        updates = vim.tbl_extend("keep", updates, src_loc:find_updates(dst_loc))
    end

    return updates
end

--------------------------------------------------------------------------------
-- if we're moving the contents of a directory into a parent directory,
-- rename the `@.md` file to the name of the directory
--------------------------------------------------------------------------------
function M.handle_dir_into_parent(src, dst, src_path, dst_path)
    if path.is_dir(src) and path.parent(src) == dst and src_path == path.join(src, DIR_FILE_NAME) then
        return tostring(path.join(dst, path.stem(src) .. ".md"))
    end

    return dst_path
end

function M.update_paths(updates)
    for old, new in pairs(updates) do
        util.make_directories(new)
        vim.fn.system("/bin/mv " .. old .. " " .. new)
    end

    for i, dir in ipairs(path.list_dirs(require'lex.config'.get().root)) do
        if path.is_empty(dir) then
            vim.fn.system("rmdir " .. dir)
        end
    end
end

function M.update_references(updates)
    local root = require'lex.config'.get().root
    vim.g.lex_sync_ignore = true

    local starting_file = vim.fn.expand('%:p')
    local current_file

    local refs_by_file = l.Reference.list_by_file()

    for src, dst in pairs(updates) do
        src = _G.escape(path.remove_from_start(src, root))

        for file, ln_to_ref_str in pairs(refs_by_file) do
            for ln, ref_str in pairs(ln_to_ref_str) do
                if string.find(ref_str, src) then
                    if current_file ~= file then
                        path.open(file)
                        current_file = file
                    end

                    local replacement = ref_str:gsub(src, path.remove_from_start(dst, root))
        
                    ulines.line.set({start_line = ln - 1, replacement = {replacement}})
                end
            end
        end
    end

    vim.cmd("silent! wall")
    
    if current_file ~= starting_file and path.is_file(starting_file) then
        path.open(starting_file)
    end

    vim.g.lex_sync_ignore = false
end

--------------------------------------------------------------------------------
--                                   Infer                                    --
--------------------------------------------------------------------------------
-- inferences to behave more like `mv`
--------------------------------------------------------------------------------
M.infer = {}

function M.infer.destination(src, dst)
    dst = M.infer.file_to_dir(src, dst)
    dst = M.infer.file_into_dir(src, dst)
    dst = M.infer.dir_into_dir(src, dst)
    return dst
end

--------------------------------------------------------------------------------
-- if:
--  - src is a file
--  - dir.name == src.stem
-- then:
--  dst → dst/DIR_FILE_NAME
--------------------------------------------------------------------------------
function M.infer.file_to_dir(src, dst)
    if path.is_file(src) and path.suffix(src) ~= path.suffix(dst) then
        if path.stem(src) == path.stem(dst) then
            dst = path.join(dst, DIR_FILE_NAME)
        end
    end

    return dst
end

--------------------------------------------------------------------------------
-- if:
--  - src is a file
--  - dst is a directory (it's suffix differs from src's)
-- then:
--  dst → dst/src.name (move src into dst)
--------------------------------------------------------------------------------
function M.infer.file_into_dir(src, dst)
    if path.is_file(src) and path.suffix(src) ~= path.suffix(dst) then
        dst = path.join(dst, path.name(src))
    end

    return dst
end

--------------------------------------------------------------------------------
-- if 
--  - src is a directory
--  - dst is a directory (it's extension matches src's) that exists
--  - dst is not the parent of src
-- then:
--  dst → dst/src.name (move src into dst)
--------------------------------------------------------------------------------
function M.infer.dir_into_dir(src, dst)
    if path.is_dir(src) and path.is_dir(dst) and path.parent(src) ~= dst then
        dst = path.join(dst, path.name(src))
    end

    return dst
end

return M
