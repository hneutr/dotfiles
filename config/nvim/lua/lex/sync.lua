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
line_utils = require'lines'
marker_utils = require'lex.marker'

local M = {}

function M.buf_enter()
    if not vim.g.deleted_markers then
        vim.g.deleted_markers = {}
    end

    vim.b.markers = M.read_markers() -- format: marker: path
    vim.b.renamed_markers = {} -- format: old_name: new_name
    vim.b.deleted_markers = {}
    vim.b.created_markers = {}

    -- M.test()
end

-- function M.test()
--     if not vim.g.marker_references then
--         vim.g.marker_references = marker_utils.reference.list{ include_path_references = false }
--     end
-- end

function M.read_markers()
    local markers = {}
    for i, str in ipairs(line_utils.get()) do
        if marker_utils.marker.is(str) then
            markers[marker_utils.marker.parse(str)] = i
        end
    end

    return markers
end

--------------------------------------------------------------------------------
-- on change functions
--------------------------------------------------------------------------------
function M.buf_change()
    local new_markers = M.read_markers()
    local old_markers = vim.b.markers
    local renamed_markers = vim.b.renamed_markers

    local deletions = M.get_deletions(old_markers, new_markers)
    local creations = M.get_creations(old_markers, new_markers)

    if M.check_rename(old_markers, new_markers, creations, deletions) then
        vim.b.renamed_markers = M.update_renames(deletions[1], creations[1], vim.b.renamed_markers)
    else
        vim.b.created_markers = M.update_creations(deletions, creations, vim.b.created_markers)
        vim.b.deleted_markers = M.update_deletions(deletions, creations, vim.b.deleted_markers)
    end

    vim.b.markers = new_markers
end

function M.get_deletions(old, new)
    local deletions = {}
    for marker, line in pairs(old) do
        if not vim.tbl_get(new, marker) then
            table.insert(deletions, marker)
        end
    end

    return deletions
end

function M.get_creations(old, new)
    local creations = {}
    for marker, line in pairs(new) do
        if not vim.tbl_get(old, marker) then
            table.insert(creations, marker)
        end
    end

    return creations
end

function M.check_rename(old_markers, new_markers, creations, deletions)
    if vim.tbl_count(creations) == 1 and vim.tbl_count(deletions) == 1 then
        local old_marker, new_marker = deletions[1], creations[1]

        if old_markers[old_marker] == new_markers[new_marker] then
            return true
        end
    end

    return false
end

function M.update_renames(old_marker, new_marker, renames)
    for other_old_marker, other_new_marker in pairs(renames) do
        -- if we're renaming the rename of something else, cut out the middle man
        if old_marker == other_new_marker then
            renames[other_old_marker] = nil
            old_marker = other_old_marker
        end
    end

    if old_marker ~= new_marker then
        renames[old_marker] = new_marker
    end

    return renames
end

function M.update_creations(new_deletions, new_creations, creations)
    for i, marker in ipairs(new_creations) do
        creations[marker] = true
    end

    for i, marker in ipairs(new_deletions) do
        creations[marker] = nil
    end

    return creations
end

function M.update_deletions(new_deletions, new_creations, deletions)
    for i, marker in ipairs(new_deletions) do
        deletions[marker] = true
    end

    for i, marker in ipairs(new_creations) do
        deletions[marker] = nil
    end

    return deletions
end


--------------------------------------------------------------------------------
-- on leave functions
--
-- anything created could be from `g:deleted_markers`
-- anything deleted should go into `g:deleted_markers`
-- renames that weren't creations or deletions should be processed
--------------------------------------------------------------------------------
function M.buf_leave()
    local creations = vim.b.created_markers
    local deletions = vim.b.deleted_markers
    local renames = vim.b.renamed_markers
    local previous_deletions = vim.g.deleted_markers

    if M.skip_if_possible(creations, deletions, renames) then
        return
    end

    local updates

    if vim.tbl_count(creations) then
        updates, renames, previous_deletions  = M.process_creations(creations, renames, previous_deletions)
    end

    if vim.tbl_count(deletions) then
        renames, previous_deletions = M.process_deletions(deletions, renames, previous_deletions)
    end

    if vim.tbl_count(renames) then
        updates = M.process_renames(renames, updates)
    end

    vim.g.deleted_markers = previous_deletions

    if vim.tbl_count(updates) then
        return marker_utils.reference.update(updates)
    else
        return
    end
end

function M.skip_if_possible(creations, deletions, renames)
    local n_creations = vim.tbl_count(creations)
    local n_deletions = vim.tbl_count(deletions)
    local n_renames = vim.tbl_count(renames)

    return n_creations == 0 and n_deletions == 0 and n_renames == 0
end

function M.process_creations(creations, renames, previous_deletions)
    local updates = {}
    local path = vim.fn.expand('%:p')

    for marker, i in pairs(creations) do
        local update = { old_path = path, old_text = marker, new_path = path, new_text = marker }

        if vim.tbl_get(renames, marker) then
            update.new_text = table.removekey(renames, marker)
        end

        if vim.tbl_get(previous_deletions, marker) then
            update.old_path = table.removekey(previous_deletions, marker)
        end

        table.insert(updates, update)
    end

    return updates, renames, previous_deletions
end

function M.process_deletions(deletions, renames, previous_deletions)
    local path = vim.fn.expand('%:p')

    local new_to_old = {}
    for old, new in pairs(renames) do
        new_to_old[new] = old
    end

    for marker, i in pairs(deletions) do
        local original_marker = vim.tbl_get(new_to_old, marker)

        if original_marker then
            table.removekey(renames, original_marker)
        end

        previous_deletions[marker] = path
    end

    return renames, previous_deletions
end

function M.process_renames(renames, updates)
    updates = updates or {}
    local path = vim.fn.expand('%:p')

    for from_text, to_text in pairs(renames) do
        table.insert(updates, {old_path = path, old_text = from_text, new_path = path, new_text = to_text})
    end

    return updates
end

return M
