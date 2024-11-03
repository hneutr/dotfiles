List({
    {
        modes = "n",
        mappings = {
            {"gV", '`[v`]', {desc = "reselect last selection"}},

            {'Q', '@q', {desc = "play 'q' macro"}},

            {"<c-e>", "gE", {desc = "go to end of prev word"}},

            -- swap */# (match _W_ord) and g*/g# (match _w_ord)
            {"*", "g*"},
            {'g*', '*'},
            {'#', 'g#'},
            {'g#', '#'},

            -- don't store "{"/"}" motions in jump list
            {'{', ':<c-u>execute "keepjumps normal! " . v:count1 . "{"<cr>', {silent = true}},
            {'}', ':<c-u>execute "keepjumps normal! " . v:count1 . "}"<cr>', {silent = true}},

            -- window navigation
            {"<c-h>", "<c-w>h"},
            {"<c-j>", "<c-w>j"},
            {"<c-k>", "<c-w>k"},
            {"<c-l>", "<c-w>l"},

            -- leader keys
            ["<leader>"] = {
                {'q', ":q<cr>", {desc = "quit"}},

                {"h", "^", {desc = "go to start of line"}},
                {"l", "$", {desc = "go to end of line"}},

                {'c', ":<c-p><cr>", {desc = "rerun previous command"}},

                {",", toggle_trailing_punctuation(','), {silent = true, desc = "toggle trailing ,"}},
                {";", toggle_trailing_punctuation(';'), {silent = true, desc = "toggle trailing ;"}},
            },
        }
    },
    {
        modes = "i",
        mappings = {
            {'jk', "<esc>", {nowait = true}},

            {"<c-]>", '<c-r>"', {desc = "paste"}},

            {"<c-d>", "<del>", {desc = "delete next char (ala macos)"}},

            {"<c-s>", "<c-\\><c-o>de", {desc = "delete next word"}},
            {"<c-w>", "<c-\\><c-o>db", {desc = "delete prev word"}},

            {"<c-l>", "<c-t>", {desc = "indent"}},
            {"<c-h>", "<c-d>", {desc = "dedent"}},

            {"<c-e>", "<c-o>A", {desc = "go to start of line (ala shell)"}},
            {"<c-a>", "<c-o>I", {desc = "go to end of line (ala shell)"}},

            {"<M-0>", "°"},
            {'<M-->', "—", {desc = "em dash"}},
            {"<M-=>", "≠"},
            {"<M-<>", "≤"},
            {"<M->>", "≥"},
            {"<M-`>", "≈"},

            {"<M-Left>", "←"},
            {"<M-Right>", "→"},
            {"<M-Up>", "↑"},
            {"<M-Down>", "↓"},
        },
    },
    {
        modes = "v",
        mappings = {
            {'>', '>gv', {desc = "indent + reselect"}},
            {'<', '<gv', {desc = "dedent + reselect"}},
        },
    },
    {
        modes = {"n", "v"},
        mappings = {
            -- move by visual line
            {"j", "gj"},
            {"k", "gk"},

            -- easy commandmode
            {"<cr>", ':'},

            -- center after jumping + consistent direction next/prev behavior
            {"n", "'Nn'[v:searchforward].'zz'", {expr = true}},
            {"N", "'nN'[v:searchforward].'zz'", {expr = true}},

            -- center after jumping
            {"<c-u>", "<c-u>zz"},
            {"<c-d>", "<c-d>zz"},

            -- idk what a "page" is other than a screen
            {"<c-f>", "<c-d>zz"},
            {"<c-b>", "<c-u>zz"},
        },
    },
    {
        modes = "c",
        mappings = {
            {"<c-a>", "<home>", {desc = "go to start of line (ala shell)"}},
            {"<c-e>", "<end>", {desc = "go to end of line (ala shell)"}},

            {"<c-n>", "<down>", {desc = "next command (ala shell)"}},
            {"<c-p>", "<up>", {desc = "prev command (ala shell)"}},

            {"<m-right>", "<s-right>", {desc = "go to next word (ala shell)"}},
            {"<m-left>", "<s-left>", {desc = "go to prev word (ala shell)"}},
        },
    },
    {
        modes = "ca",
        mappings = {
            {'l', "lua"},
            {'lp', spaceless_abbreviation("lua vim.print()<Left>")},
        },
    },
    {
        modes = "t",
        mappings = {
            -- exit
            {"<esc>", "<c-\\><c-n>", {nowait = true}},
            {"<c-[>", "<c-\\><c-n>", {nowait = true}},

            {"<c-]>", '<c-\\><c-n>""pA', {desc = "paste"}},

            -- <c-r> ala insert mode
            {"<c-r>", [['<c-\><c-n>"'.nr2char(getchar()).'pi']], {expr = true}},

            -- window movements
            {"<c-h>", "<c-\\><c-n><c-w>h", {nowait = true}},
            {"<c-j>", "<c-\\><c-n><c-w>j", {nowait = true}},
            {"<c-k>", "<c-\\><c-n><c-w>k", {nowait = true}},
            {"<c-l>", "<c-\\><c-n><c-w>l", {nowait = true}},

            -- open `@.md`
            {"<C-2>", "vim @.md<cr>"},
        },
    },
    {
        modes = {"n", "v", "i", "t"},
        mappings = {
            ["<C-Space>"] = List({
                {"l", "vspl|term"},
                {"j", "spl|term"},
                {"c", "tabnew|term"},
                {"x", "x"},
                {"X", "tabclose"},
                {"!", "wincmd T"},
                {"1", "tabn 1"},
                {"2", "tabn 2"},
                {"3", "tabn 3"},
                {"4", "tabn 4"},
                {"5", "tabn 5"},
                {"6", "tabn 6"},
                {"7", "tabn 7"},
                {"8", "tabn 8"},
                {"9", "tabn 9"},
            }):transform(function(v)
                v[2] = "<cmd>" .. v[2] .. "<cr>"
                return v
            end),
        },
    },
}):foreach(function(map)
    local keymaps = List(map.mappings)
    Dict(map.mappings):foreach(function(prefix, submaps)
        List(submaps):foreach(function(submap)
            submap[1] = prefix .. submap[1]
            keymaps:append(submap)
        end)
    end)

    keymaps:foreach(function(keymap) vim.keymap.set(map.modes, unpack(keymap)) end)
end)
