-- https://github.com/altercation/vim-colors-solarized
local C = {
    cterm = {
        black    = 0,
        white    = 7,
        gray     = 10,

        red      = 1,
        orange   = 9,
        yellow   = 3,
        green    = 2,
        blue     = 4,
        cyan     = 6,
        magenta  = 5,
        violet   = 13,

        brblack  = 8,
        brwhite  = 15,

        bryellow = 11,
        brblue   = 12,
        brcyan   = 14,
    },
}

local function set_highlight(args)
    args = _G.default_args(args, {namespace = 0, name = '', val = {}})

    local allowed_keys = {
        'fg',
        'bg',
        'sp',
        'bold',
        'standout',
        'underline',
        'undercurl',
        'underdouble',
        'underdotted',
        'underdashed',
        'strikethrough',
        'italic',
        'reverse',
        'link',
    }
    local val = {}

    for _, key in ipairs(allowed_keys) do
        val[key] = args.val[key]
    end

    for _, key in ipairs({'fg', 'bg'}) do
        if val[key] ~= nil then
            val["cterm" .. key] = C.cterm[table.removekey(val, key)]
        end
    end

    if args.name then
        vim.api.nvim_set_hl(args.namespace, args.name, val)
    end
end

return {
    C = C,
    set_highlight = set_highlight,
}
