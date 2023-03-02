local constants = require('lex.constants')
local link = require('lex.link')
local Mirror = require('lex.mirror')
local M = {}

local default_lhs_to_cmd = { e = 'e', o = 'e', l = 'vs', v = 'vs', j = 'sp', s = 'sp' }

function M.get()
    if not vim.g.lex_opener_mappings then
        M.set()
    end

    return vim.g.lex_opener_mappings
end

function M.set()
    local mappings = {
        { prefix = 'g', fn = function(open_cmd) require('lex.index').open(open_cmd) end },
        { prefix = 'n', fn = function(open_cmd) link.Location.goto(open_cmd) end },
    }

    for kind, kind_data in pairs(constants.mirror_defaults) do
        for mirror, mirror_data in pairs(kind_data.mirrors) do
            table.insert(mappings, {
                prefix = mirror_data.opener_prefix,
                fn = function(open_cmd) Mirror.open(mirror, open_cmd) end,
            })
        end
    end

    for i, mapping in ipairs(mappings) do
        mapping.lhs_prefix = constants.opener_prefix .. table.remove(mapping, 'prefix')
    end

    table.insert(mappings, {
        fn = function(open_cmd) link.Location.goto(open_cmd) end,
        lhs_to_cmd = {
            ["<M-l>"] = "vsplit",
            ["<M-j>"] = "split",
            ["<M-e>"] = "edit",
            ["<M-t>"] = "tabedit",
        },
        map_args = {},
    })

    vim.g.lex_opener_mappings = M.format_all(mappings)
end

function M.format_all(raw_mappings)
    local mappings = {}
    for i, raw_mapping in ipairs(raw_mappings) do
        for j, mapping in ipairs(M.format(raw_mapping)) do
            table.insert(mappings, mapping)
        end
    end

    return mappings
end

function M.format(args)
    args = _G.default_args(args, {
        fn = nil,
        lhs_to_cmd = default_lhs_to_cmd,
        lhs_prefix = '',
        map_args = { silent = true, buffer = 0 },
    })

    local mappings = {}
    for lhs, cmd in pairs(args.lhs_to_cmd) do
        lhs = args.lhs_prefix .. lhs

        local rhs = function() args.fn(cmd) end
        table.insert(mappings, { lhs = lhs, rhs = rhs, args = args.map_args })
    end

    return mappings
end

function M.map()
    for i, mapping in ipairs(M.get()) do
        vim.keymap.set('n', mapping.lhs, mapping.rhs, mapping.args)
    end

    -- open notes
    vim.keymap.set(
        "n",
        constants.opener_prefix .. "N",
        function() Mirror.open_mirrors_of_kind("notes") end,
        {silent = true, buffer = 0}
    )
end

return M
