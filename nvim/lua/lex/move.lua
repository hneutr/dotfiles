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

    vim.g.lex_sync_ignore = true
    require('lex.config').set(vim.env.PWD)
    
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
    
    if vim.fn.fnamemodify(src, ':p:h:h') == dst and _G.isdirectory(src) then
        updates = set_dir_file_name_to_parent_dir(updates, src, dst)
    end
    
    M.update_paths(updates)
    M.update_references(updates)
end

function M.update_paths(updates)
    for old, new in pairs(updates) do
        util.make_directories(new)
        vim.fn.system("/bin/mv " .. old .. " " .. new)
    end
end

function M.is_location(path)
    return string.match(path, ":")
end

-- first, get the marker content
-- then:
--      - if dst is a path:label location, put the content at the end of the file
--      - if dst is a path, remove the marker header and put content in the file
-- then update references
function M.move_location(src, dst)
    l.Location.goto('edit', src)

    local dividers = {
        require("snips.markdown").divider.big.str(),
        require("snips.markdown").divider.small.str(),
    }

    local start_line = vim.fn.getpos('.')[2] - 1
    local end_line

    local lines = {}
    for i, line in ipairs(require('util.lines').get()) do
        if i > start_line + 2 then
            for _, divider in ipairs(dividers) do
                if line == divider then
                    end_line = i - 1
                    break
                end
            end
        end

        if end_line ~= nil then
            break
        end

        if i >= start_line then
            table.insert(lines, line)
        end
    end

    require('util.lines').cut({start_line = start_line - 1, end_line = end_line})

    if not M.is_location(dst) then
        local new_lines = {}
        for i, line in ipairs(lines) do
            if i > 3 then
                table.insert(new_lines, line)
            end

            lines = new_lines
        end
    end

    l.Location.goto('edit', dst)
    vim.api.nvim_input('G')
    vim.api.nvim_put(lines, "l", false, true)

    local updates = {}
    updates[src] = dst

    M.update_references(updates)
end

function M.update_references(updates)
    vim.g.lex_sync_ignore = true
    local root = require'lex.config'.get().root

    local refs_by_file = l.Reference.list_by_file()
    local starting_file = vim.fn.expand('%:p')
    local current_file

    for key, val in pairs(updates) do
        key = key:gsub(_G.escape(root .. '/'), '')
        key = _G.escape(key)
        val = val:gsub(_G.escape(root .. '/'), '')

        for file, ln_to_ref_str in pairs(refs_by_file) do
            for ln, ref_str in pairs(ln_to_ref_str) do
                if string.find(ref_str, key) then
                    if current_file ~= file then
                        util.open_path(file)
                        current_file = file
                    end
        
                    local new_str = ref_str:gsub(key, val)
                    ulines.line.set({ start_line = ln - 1, replacement = { new_str } })
                end
            end
        end
    end

    vim.cmd("silent! wall")
    
    if current_file ~= starting_file and _G.filereadable(starting_file) then
        util.open_path(starting_file)
    end
    vim.g.lex_sync_ignore = false
end

--------------------------------------------------------------------------------
-- if we're moving the contents of a directory into a parent directory,
-- rename the `@.md` file to the name of the directory
--------------------------------------------------------------------------------
function set_dir_file_name_to_parent_dir(updates, src_dir, dst_dir)
    local src_dir_file = _G.joinpath(src_dir, DIR_FILE_NAME)
    local dst_dir_file = vim.tbl_get(updates, src_dir_file)

    if dst_dir_file then
        local src_dir_name = vim.fn.fnamemodify(src_dir, ':p:h:t')
        updates[src_dir_file] = _G.joinpath(dst_dir, src_dir_name .. ".md")
    end

    return updates
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
    if path.is_file(src) and not path.suffixes_match(src, dst) then
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
    if path.is_file(src) and not path.suffixes_match(src, dst) then
        dst = path.join(dst, path.name(src))
    end

    return dst
end

--------------------------------------------------------------------------------
-- if 
--  - src is a directory
--  - dst is a directory (it's extension matches src's) that exists
-- then:
--  dst → dst/src.name (move src into dst)
--------------------------------------------------------------------------------
function M.infer.dir_into_dir(src, dst)
    if path.is_dir(src) and path.is_dir(dst) then
        dst = path.join(dst, path.name(src))
    end

    return dst
end

--------------------------------------------------------------------------------
--                                get_updates                                 --
--------------------------------------------------------------------------------
function M.get_updates(src, dst)
    local root = require'lex.config'.get().root

    local src_stem = src:gsub(_G.escape(root .. '/'), '', 1)
    local dst_stem = dst:gsub(_G.escape(root .. '/'), '', 1)

    local files = {}
    if _G.isdirectory(src) then
        files = _tree(src)
    else
        files[src] = true
    end

    local updates = {}
    for old_path, _ in pairs(files) do
        local old_location = mirror.MLocation({ path = old_path })
        local new_location = mirror.MLocation({ path = old_path:gsub(_G.escape(src_stem), dst_stem, 1) })

        updates = vim.tbl_extend("keep", updates, old_location:find_updates(new_location))
    end

    return updates
end

function _tree(dir)
    local results = {}
    for i, stem in ipairs(vim.fn.readdir(dir)) do
        path = _G.joinpath(dir, stem)

        if _G.isdirectory(path) then
            results = vim.tbl_extend('keep', results, _tree(path))
        else
            results[path] = true
        end
    end

    return results
end

return M
