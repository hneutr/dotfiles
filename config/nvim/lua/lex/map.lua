local M = {}
local api = vim.api

local default_opener_cmds = { edit = 'e', vsplit = 'vs', split = 'sp'}

function M.map_prefixed_file_openers(prefix, fn, args, cmds)
    cmds = cmds or default_opener_cmds

    local lhs_prefix = vim.g.file_opening_prefix .. prefix
    local rhs_start = fn .. '('
    local rhs_end = ")<cr>"

    if args then
        rhs_start = rhs_start .. args .. ", "
    end

    local mappings = {}

    local edit_command = vim.tbl_get(cmds, "edit")

    if edit_command then
        mappings["o"] = edit_command
        mappings["e"] = edit_command
    end

    local vsplit_command = vim.tbl_get(cmds, "vsplit")
    if vsplit_command then
        mappings["l"] = vsplit_command
        mappings["v"] = vsplit_command
    end

    local split_command = vim.tbl_get(cmds, "split")
    if split_command then
        mappings["j"] = split_command
        mappings["s"] = split_command
    end

    for key, cmd in pairs(mappings) do
        local lhs = lhs_prefix .. key
        local rhs = rhs_start .. "'" ..  cmd .. "'" .. rhs_end
        api.nvim_set_keymap('n', lhs, rhs, { noremap = true, silent = true })
    end
end

return M
