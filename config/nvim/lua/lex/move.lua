local M = {}
local l = require'lex.link'
local line_utils = require'lines'
local mirror = require'lex.mirror'
local util = require'util'

function resolve_path(path)
    if path == '.' then
        path = vim.env.PWD
    else
        path = _G.joinpath(vim.env.PWD, path)
    end
    return path
end


--------------------------------------------------------------------------------
--                                    move                                    --
--------------------------------------------------------------------------------
function M.move_path(src, dst)
    src = resolve_path(src)
    dst = resolve_path(dst)

    vim.g.lex_sync_ignore = true
    require'lex.config'.set(vim.env.PWD)
    dst = infer_destination(src, dst)

    updates = M.get_updates(src, dst)

    if vim.fn.fnamemodify(src, ':p:h:h') == dst and _G.isdirectory(src) then
        updates = set_dir_file_name_to_parent_dir(updates, src, dst)
    end

    M.update_paths(updates)
    M.update_references(updates)

    vim.g.lex_sync_ignore = true
end

function M.update_paths(updates)
    for old, new in pairs(updates) do
        util.make_directories(new)
        vim.fn.system("mv " .. old .. " " .. new)
    end
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
                    line_utils.set({ start_line = ln - 1, end_line = ln, replacement = { new_str } })
                end
            end
        end
    end

    vim.cmd("silent! wall")

    if current_file ~= starting_file then
        util.open_path(starting_file)
    end
    vim.g.lex_sync_ignore = false
end

--------------------------------------------------------------------------------
--                             infer_destination                              --
--------------------------------------------------------------------------------
-- inferences to behave more like `mv`
--------------------------------------------------------------------------------
function infer_destination(src, dst)
    dst = infer_filename(src, dst)
    dst = infer_dirname(src, dst)
    return dst
end

--------------------------------------------------------------------------------
--                               infer_filename                               --
--------------------------------------------------------------------------------
-- behave like `mv`
-- if `src` is a file and `dst` doesn't share the same extention,
-- assume it's a directory and move `src` to `dst/{src.name}`
--------------------------------------------------------------------------------
function infer_filename(src, dst)
    if _G.filereadable(src) then
        if vim.fn.fnamemodify(src, ':e') ~= vim.fn.fnamemodify(dst, ':e') then
            dst = _G.joinpath(dst, vim.fn.fnamemodify(src, ':t'))
        end
    end

    return dst
end

--------------------------------------------------------------------------------
--                               infer_dirname                                --
--------------------------------------------------------------------------------
-- behave like `mv`:
-- if:
--      - `src` and `dst` are directories
--      - `dst` does not contain `src`
-- then:
--      - move `src` into `dst` under the name of `dst/src.name`
--------------------------------------------------------------------------------
function infer_dirname(src, dst)
    if _G.isdirectory(src) then
        if _G.isdirectory(dst) then
            if not vim.startswith(src, dst) then
                dst = _G.joinpath(dst, vim.fn.fnamemodify(src, ':t'))
            end
        end
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

function set_dir_file_name_to_parent_dir(updates, src_dir, dst_dir)
    local src_dir_file = _G.joinpath(src_dir, require'lex.constants'.dir_file_name)
    local dst_dir_file = vim.tbl_get(updates, src_dir_file)

    if dst_dir_file then
        local src_dir_name = vim.fn.fnamemodify(src_dir, ':p:h:t')
        updates[src_dir_file] = _G.joinpath(dst_dir, src_dir_name .. ".md")
    end

    return updates
end


return M