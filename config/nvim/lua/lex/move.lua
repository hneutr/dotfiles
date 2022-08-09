local M = {}
local l = require'lex.link'
local mirror = require'lex.mirror'


--------------------------------------------------------------------------------
--                                    move                                    --
--------------------------------------------------------------------------------
function M.move_path(src, dst)
    dst = infer_destination(src, dst)
    updates = M.get_updates(src, dst)
    if vim.fn.fnamemodify(src, ':p:h') == dst and vim.fn.isdirectory(src) == 1 then
        updates = set_dir_file_name_to_parent_dir(updates, src)
    end

    -- TODO:
    -- M.update_paths(updates)
    -- M.update_references(updates)
end

function M.update_paths(updates)
end


function M.update_references(updates)
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
-- if `from_path` is a file and `to_path` doesn't share the same extention,
-- assume it's a directory and move `from_path` to `to_path/{from_path.name}`
--------------------------------------------------------------------------------
function infer_filename(src, dst)
    if vim.fn.filereadable(src) == 1 then
        if vim.fn.fnamemodify(src, ':e') ~= vim.fn.fnamemodify(dst, ':e') then
            dst = _G.joinpath(dst, vim.fn.fnamemodify(src, ':h'))
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
    if vim.fn.isdirectory(src) == 0 then
        return dst
    elseif vim.fn.isdirectory(dst) == 0 then
        return dst
    elseif vim.startswith(src, dst) then
        return dst
    end

    return _G.joinpath(dst, vim.fn.fnamemodify(src, ':t'))
end

--------------------------------------------------------------------------------
--                                get_updates                                 --
--------------------------------------------------------------------------------
function M.get_updates(src, dst)
    local root = require'lex.config'.get().root

    local src_stem = src:gsub(_G.escape(root .. '/'), '', 1)
    local dst_stem = dst:gsub(_G.escape(root .. '/'), '', 1)

    local files = {}
    if vim.fn.isdirectory(src) then
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

        if vim.fn.isdirectory(path) == 1 then
            results = vim.tbl_extend('keep', results, _tree(path))
        else
            results[path] = true
        end
    end

    return results
end

function set_dir_file_name_to_parent_dir(updates, src_dir)
    local src_dir_file = _G.joinpath(src_dir, require'lex.constants'.dir_file_name)
    local dst_dir_file = vim.tbl_get(updates, src_dir_file)

    if dst_dir_file then
        local src_dir_name = vim.fn.fnamemodify(':p:h:t')

        updates[src_dir_file] = vim.fn.fnamemodify(dst_dir_file, ':p:h') .. src_dir_name .. ".md"
    end

    return updates
end


return M
