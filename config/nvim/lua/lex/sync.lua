------------------------------------- syncing ----------------------------------
-- "syncing" is updating references when makes change
--
-- there are two kinds of reference updates that we want to handle:
-- 1. renames: an existing marker's label changes
-- 2. moves: an existing marker is moved from one file to another
--
-- RENAMES:
-- - we look to see if the existing line contains a marker
-- - if it does, and there was a marker with a different label there prior to the edit
-- - then we consider that a rename
--
-- MOVES:
-- - when a marker is deleted from a file, add it to the "deleted" list
-- - when a marker is added to another file, check to see if it was in the
--   "deleted" list
-- - if so, queue up a "delete move"
-- - if a marker is deleted from a file:
--   - remove it from the "delete move" list
--   - add it back onto the "deleted" list
--------------------------------------------------------------------------------
-- these are in the format: old_label: old_path
local M = {}

local marker_utils = require'lex.marker'

function M.buf_enter()
    if not vim.g.deleted_markers then
        vim.g.deleted_markers = {}
    end

    vim.b.markers = M.read_markers()
    vim.b.renamed_markers_new_to_old = {}
    vim.b.renamed_markers_old_to_new = {}
    vim.b.deleted_markers = {}
    vim.b.created_markers = {}
end


function M.buf_change()
    local new_markers = M.read_markers()

    local deleted = {}
    for marker, line in pairs(vim.b.markers) do
        if not vim.tbl_get(new_markers, marker) then
            table.insert(deleted, marker)
        end
    end

    local created = {}
    for marker, line in pairs(new_markers) do
        if not vim.tbl_get(vim.b.markers, marker) then
            table.insert(created, marker)
        end
    end

    if vim.tbl_count(created) == 1 and vim.tbl_count(deleted) == 1 then
        created, deleted = M.check_rename(created[1], deleted[1])
    end

    M.record_marker_creations_and_deletions(created, deleted)

    vim.b.markers = new_markers
end


function M.buf_leave()
    M.handle_deleted_markers()

    local updates = M.handle_created_markers()
    for i, update in ipairs(M.handle_renamed_markers()) do
        table.insert(updates, update)
    end

    return updates
    -- marker_utils.reference.update(updates)
end


function M.record_marker_creations_and_deletions(newly_created, newly_deleted)
    for i, marker in ipairs(newly_deleted) do
        table.vim.set('b', 'deleted_markers', marker, true)

        if vim.tbl_get(vim.b.created_markers, marker) then
            table.vim.removekey('b', 'created_markers', marker)
        end
    end

    for i, marker in ipairs(newly_created) do
        table.vim.set('b', 'created_markers', marker, true)

        if vim.tbl_get(vim.b.deleted_markers, marker) then
            table.vim.removekey('b', 'deleted_markers', marker)
        end
    end
end

function M.handle_created_markers()
    local updates = {}
    local path = vim.fn.expand('%:p')
    for text, i in pairs(vim.b.created_markers) do
        local update = { from_path = path, from_text = text, to_path = path, to_text = text }
        if vim.tbl_get(vim.b.renamed_markers_old_to_new, text) then
            update.to_text = table.vim.removekey('b', 'renamed_markers_old_to_new', text)
            table.vim.removekey('b', 'renamed_markers_new_to_old', update.to_text)
        end

        if vim.tbl_get(vim.g.deleted_markers, text) then
            update.from_path = table.vim.removekey('g', 'deleted_markers', text)
        end

        table.insert(updates, update)
    end

    return updates
end

function M.handle_deleted_markers()
    local path = vim.fn.expand('%:p')

    for marker, i in pairs(vim.b.deleted_markers) do
        if vim.tbl_get(vim.b.renamed_markers_new_to_old, marker) then
            marker = table.vim.removekey('b', 'renamed_markers_new_to_old', marker)
            table.vim.removekey('b', 'renamed_markers_old_to_new', marker)
        end

        table.vim.set('g', 'deleted_markers', marker, path)
    end
end

function M.handle_renamed_markers()
    local path = vim.fn.expand('%:p')

    local updates = {}
    for from_text, to_text in pairs(vim.b.renamed_markers_old_to_new) do
        table.insert(updates, {old_path = path, old_text = from_text, new_path = path, new_text = to_text})
    end

    return updates
end

function M.read_markers()
    local markers = {}
    for i, str in ipairs(require'lines'.get()) do
        if marker_utils.marker.is(str) then
            markers[marker_utils.marker.parse(str)] = i
        end
    end

    return markers
end

function M.check_rename(new, old)
    local new_line_number = vim.api.nvim_win_get_cursor(0)[1]
    local old_line_number = vim.b.markers[old]

    local created, deleted = { new }, { old }
    if old_line_number == new_line_number then
        local original = old
        if vim.tbl_get(vim.b.renamed_markers_new_to_old, old) then
            old = table.vim.removekey('b', 'renamed_markers_new_to_old', old)
        end

        if new == original then
            table.vim.removekey('b', 'renamed_markers_old_to_new', original)
        else
            table.vim.set('b', 'renamed_markers_new_to_old', new, original)
            table.vim.set('b', 'renamed_markers_old_to_new', original, new)
        end

        table.vim.removekey('b', 'markers', old)
        table.vim.set('b', 'markers', new, new_line_number)

        created, deleted = {}, {}
    end

    return created, deleted
end

return M
