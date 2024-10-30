local maps = Dict({
    n = {
        -- select last selection
        gV = '`[v`]',

        -- play 'q' macro
        Q = '@q',

        ["<c-e>"] = {"gE", {desc = "go to end of previous word"}},

        -- swap */# (match _W_ord) and g*/g# (match _w_ord)
        ['*'] = 'g*',
        ['g*'] = '*',
        ['#'] = 'g#',
        ['g#'] = '#',

        -- don't store "{"/"}" motions in jump list
        ['{'] = {':<c-u>execute "keepjumps normal! " . v:count1 . "{"<cr>', {silent = true}},
        ['}'] = {':<c-u>execute "keepjumps normal! " . v:count1 . "}"<cr>', {silent = true}},

        -- window navigation
        ["<c-h>"] = "<c-w>h",
        ["<c-j>"] = "<c-w>j",
        ["<c-k>"] = "<c-w>k",
        ["<c-l>"] = "<c-w>l",

        -- leader keys
        ["<leader>"] = {

            q = {":q<cr>", {desc = "quit"}},

            h = {"^", {desc = "go to start of line"}},
            l = {"$", {desc = "go to end of line"}},

            c = {":<c-p><cr>", {desc = "run last command"}},

            [","] = {require('util').modify_line_end(','), {silent = true, desc = "toggle trailing ,"}},
            [";"] = {require('util').modify_line_end(';'), {silent = true, desc = "toggle trailing ;"}},
        },
    },
    i = {
        -- esc
        jk = {"<esc>", {nowait = true}},

        -- paste
        ["<c-]>"] = '<c-r>"',

        -- forward delete (ala macos)
        ["<c-d>"] = "<del>",

        -- delete next/previous word
        ["<c-s>"] = "<c-\\><c-o>de",
        ["<c-w>"] = "<c-\\><c-o>db",

        -- indent/dedent
        ["<c-l>"] = "<c-t>",
        ["<c-h>"] = "<c-d>",

        -- move to start/end of line (shell)
        ["<c-e>"] = "<c-o>A",
        ["<c-a>"] = "<c-o>I",

        -- meta
        ["<M-0>"] = "°",

        ['<M-->'] = "—", -- em dash
        ["<M-=>"] = "≠",
        ["<M-<>"] = "≤",
        ["<M->>"] = "≥",
        ["<M-`>"] = "≈",

        ["<M-Left>"] = "←",
        ["<M-Right>"] = "→",
        ["<M-Up>"] = "↑",
        ["<M-Down>"] = "↓",
    },
    v = {
        -- retain visual selection after indent/dedent
        ['>'] = '>gv',
        ['<'] = '<gv',
    },
    nv = {
        -- move by visual line
        j = "gj",
        k = "gk",

        -- center after jumping + consistent direction next/previous behavior
        n = {"'Nn'[v:searchforward].'zz'", {expr = true}},
        N = {"'nN'[v:searchforward].'zz'", {expr = true}},

        -- center after jumping
        ["<c-u>"] = "<c-u>zz",
        ["<c-d>"] = "<c-d>zz",

        -- idk what a "page" is other than a screen
        ["<c-f>"] = "<c-d>zz",
        ["<c-b>"] = "<c-u>zz",

        -- easy commandmode
        ["<cr>"] = ':',
    },
    c = {
        -- move to start/end of line (ala shell)
        ["<c-a>"] = "<home>",
        ["<c-e>"] = "<end>",

        -- next/previous command (ala shell)
        ["<c-n>"] = "<down>",
        ["<c-p>"] = "<up>",

        -- move to next/previous word (ala shell)
        ["<m-left>"] = "<s-left>",
        ["<m-right>"] = "<s-right>",
    },
    ca = {
        l = "lua",
        lp = "lua vim.print()<Left>",
    },
    t = {
        -- exit
        ["<esc>"] = {"<c-\\><c-n>", {nowait = true}},
        ["<c-[>"] = {"<c-\\><c-n>", {nowait = true}},

        -- paste
        ["<c-]>"] = '<c-\\><c-n>""pA',

        -- <c-r> ala insert mode
        ["<c-r>"] = {[['<c-\><c-n>"'.nr2char(getchar()).'pi']], {expr = true}},

        -- consistent window movement commands
        ["<c-h>"] = {"<c-\\><c-n><c-w>h", {nowait = true}},
        ["<c-j>"] = {"<c-\\><c-n><c-w>j", {nowait = true}},
        ["<c-k>"] = {"<c-\\><c-n><c-w>k", {nowait = true}},
        ["<c-l>"] = {"<c-\\><c-n><c-w>l", {nowait = true}},
    },
    nvit = {
        ["<C-Space>"] = Dict({
            l = "vspl|term",
            j = "spl|term",
            c = "tabnew|term",
            x = "x",
            X = "tabclose",
            ["!"] = "wincmd T",
            ["1"] = "tabn 1",
            ["2"] = "tabn 2",
            ["3"] = "tabn 3",
            ["4"] = "tabn 4",
            ["5"] = "tabn 5",
            ["6"] = "tabn 6",
            ["7"] = "tabn 7",
            ["8"] = "tabn 8",
            ["9"] = "tabn 9",
        }):transformv(function(rhs) return "<cmd>" .. rhs .. "<cr>" end),
    },
})

maps:foreach(function(modes, nested_maps)
    modes = modes:match("a$") and modes or List(modes)

    local submaps = List({nested_maps})
    while #submaps > 0 do
        Dict(submaps:pop()):foreach(function(lhs, val)
            val = type(val) == "string" and {val} or val

            if #val == 0 then
                submaps:append(Dict(val):transformk(function(_lhs) return lhs .. _lhs end))
            else
                vim.keymap.set(modes, lhs, unpack(val))
            end
        end)
    end
end)
