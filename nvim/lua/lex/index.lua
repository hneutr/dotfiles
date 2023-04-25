local M = {}
local snips = require('snips.markdown')
local util = require('util')

local Location = require("hnetxt-nvim.text.location")
local Mark = require("hnetxt-nvim.text.mark")
local Reference = require("hnetxt-lua.element.reference")

local default_index_path = vim.env.TMPDIR .. 'index.md'
local stem_exclusions = {'.git', '.gitignore', '.mirrors', '.project'}

function M.open(open_command)
    local lines = vim.tbl_flatten({
        M.get_file_index(),
        {""},
        M.get_dir_index(),
    })

    util.write_file(lines, default_index_path)

    local lex_config_path = vim.b.lex_config_path
    util.open_path(default_index_path, open_command)

    vim.b.lex_sync_ignore = true
    vim.b.lex_config_path = lex_config_path

    require('lex.opener').map()
end


function M.get_file_index(path)
    local marks = {}
    local min_indent = 1000
    for i, str in ipairs(require('util.lines').get()) do
        if Mark.str_is_a(str) then
            local mark = Mark.from_str(str)

            if mark.before == '> ' then
                min_indent = math.min(min_indent, 1)
            else
                min_indent = 0
            end

            table.insert(marks, mark)
        end
    end

    local mark_reference_lines = {}
    for i, mark in ipairs(marks) do
        local prefix = '- '
        if mark.before == '> ' then
            if i == 1 then
                table.insert(mark_reference_lines, "- general:")
            end

            if min_indent ~= 1 then
                prefix = string.rep(" ", vim.bo.shiftwidth) .. prefix
            end
        end

        local reference = Reference({location = Location({label = mark.label})})
        local str = prefix .. tostring(reference)

        table.insert(mark_reference_lines, str)
    end

    local lines = vim.tbl_flatten({
        snips.header.big.str('file'),
        {""},
        mark_reference_lines,
    })

    return lines
end

function M.get_dir_index(path)
    path = path or vim.fn.expand('%:p:h')
    local lines = vim.tbl_flatten({
        snips.header.big.str('dir'),
        {""},
        _format_dir_index(tree(path)),
    })

    return lines
end

function _format_dir_index(dir_tree, indent)
    indent = indent or 0

    local lines = {}

    for key, val in pairs(dir_tree) do
        if val == true and vim.endswith(key, '@.md)') then
            dir_tree[key] = nil
            table.insert(lines, _format_dir_index_entry(key, math.min(0, indent - 1)))
        end
    end

    local keys = vim.tbl_keys(dir_tree)
    table.sort(keys)

    for i, key in ipairs(keys) do
        local val = dir_tree[key]

        table.insert(lines, _format_dir_index_entry(key, indent))

        if val and val ~= true then
            table.insert(lines, _format_dir_index(val, indent + 1))
        end
    end

    return vim.tbl_flatten(lines)
end

function _format_dir_index_entry(str, indent)
    return string.rep(string.rep(" ", vim.bo.shiftwidth), indent) .. '- ' .. str
end

function _get_definition_key(key)
    return _G.joinpath(key:sub(1, key:len() - 1), "@.md)")
end

function _clean_dir_tree(dir_tree)
    local clean_tree = {}
    for key, val in pairs(dir_tree) do
        if val ~= true then
            local definition_key = _get_definition_key(key)

            if vim.tbl_get(val, definition_key) then
                val[definition_key] = nil
                key = definition_key
            end
        end
        clean_tree[key] = val
    end

    return clean_tree
end


function tree(dir)
    local results = {}
    for i, stem in ipairs(vim.fn.readdir(dir)) do
        if not vim.tbl_contains(stem_exclusions, stem) then
            path = _G.joinpath(dir, stem)

            local key = tostring(Reference({location = Location({path = path})}))

            if vim.fn.isdirectory(path) ~= 0 then
                results[key] = tree(path)
            else
                results[key] = true
            end
        end
    end

    return _clean_dir_tree(results)
end

return M
