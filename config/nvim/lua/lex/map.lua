local M = {}
local config = require'lex.config'


local default_lhs_to_cmd = { e = 'e', o = 'e', l = 'vs', v = 'vs', j = 'sp', s = 'sp' }


function M.add_mappings()
    local mappings = M.get_mirror_mappings()
    table.insert(mappings, { prefix = 'g', fn =  ":lua require'lex.index'.open"})
    table.insert(mappings, { prefix = 'n', fn =  ":lua require'lex.marker'.location.goto"})

    for i, mapping in ipairs(mappings) do
        mapping.lhs_prefix = vim.g.file_opening_prefix .. table.removekey(mapping, 'prefix')
        M.map_openers(mapping)
    end

    M.map_openers({
        fn = ":lua require'lex.marker'.location.goto",
        lhs_to_cmd = {
            ["<M-l>"] = "vsplit",
            ["<M-j>"] = "split",
            ["<M-e>"] = "edit",
        },
        map_args = {},
    })
end


function M.get_mirror_mappings()
    local mappings = {}
    local fn = ":lua require'util'.open_path"
    for m_type, m_config in pairs(vim.tbl_get(config.get(), 'mirrors') or {}) do
        local prefix = m_config['vimPrefix']
        local path = require'lex.mirror'.get_path(m_type)

        table.insert(mappings, { prefix = prefix, fn = fn, fn_args = '"' .. path .. '"'})
    end

    return mappings
end


function M.map_openers(args)
    args = _G.default_args(args, {
        fn = nil,
        fn_args = nil,
        lhs_to_cmd = default_lhs_to_cmd,
        lhs_prefix = '',
        map_args = { silent = true },
    })

    local rhs_start = args.fn .. '('

    if args.fn_args then
        rhs_start = rhs_start .. args.fn_args .. ", "
    end

    for lhs, cmd in pairs(args.lhs_to_cmd) do
        lhs = args.lhs_prefix .. lhs
        local rhs = rhs_start .. "'" ..  cmd .. "')<cr>"
        vim.api.nvim_set_keymap('n', lhs, rhs, args.map_args)
    end
end


return M
