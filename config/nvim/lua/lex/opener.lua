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
        { prefix = 'g', fn = function(open_cmd) require'lex.index'.open(open_cmd) end },
        { prefix = 'n', fn = function(open_cmd) require'lex.link'.Location.goto(open_cmd) end },
    }

    for mirror_type, mirror_config in pairs(vim.g.lex_mirror_defaults.mirrors) do
        table.insert(mappings, {
            prefix = mirror_config['vimPrefix'],
            fn = function(open_cmd) require'lex.mirror'.open(mirror_type, open_cmd) end,
        })
    end

    for i, mapping in ipairs(mappings) do
        mapping.lhs_prefix = vim.g.file_opening_prefix .. table.removekey(mapping, 'prefix')
    end

    table.insert(mappings, {
        fn = function(open_cmd) require'lex.link'.Location.goto(open_cmd) end,
        lhs_to_cmd = {
            ["<M-l>"] = "vsplit",
            ["<M-j>"] = "split",
            ["<M-e>"] = "edit",
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
end

return M
