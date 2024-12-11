Dict({
    n = {
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
    },

    i = {
        {'jk', "<esc>", {nowait = true}},

        {"<c-]>", '<c-r>"', {desc = "paste"}},

        {"<c-d>", "<del>", {desc = "delete next char (ala macos)"}},

        {
            "<c-s>",
            function()
                local row, col = unpack(vim.api.nvim_win_get_cursor(0))
                local line = vim.api.nvim_buf_get_text(0, row - 1, col, row, -1, {})[1]:lstrip()
                local object = line:find("%s") ~= 2 and "e" or "l" -- deals with the 1 char case
                vim.api.nvim_input("<C-o>d" .. object)
            end,
            {desc = "delete next word"}
        },
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

    v = {
        {'>', '>gv', {desc = "indent + reselect"}},
        {'<', '<gv', {desc = "dedent + reselect"}},
    },

    ["n v"] = {
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

    c = {
        {"<c-a>", "<home>", {desc = "go to start of line (ala shell)"}},
        {"<c-e>", "<end>", {desc = "go to end of line (ala shell)"}},

        {"<c-n>", "<down>", {desc = "next command (ala shell)"}},
        {"<c-p>", "<up>", {desc = "prev command (ala shell)"}},

        {"<m-right>", "<s-right>", {desc = "go to next word (ala shell)"}},
        {"<m-left>", "<s-left>", {desc = "go to prev word (ala shell)"}},
    },

    ca = {
        {'l', "lua"},
        {'lp', spaceless_abbreviation("lua vim.print()<Left>")},
    },

    t = {
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

    ["n v i t"] = {
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
        }):map(function(v)
            return {v[1], "<cmd>" .. v[2] .. "<cr>"}
        end),
    },
}):foreach(function(modes, keymaps)
    modes = modes:split()

    Dict(keymaps):foreach(function(prefix, submaps)
        List(submaps):foreach(function(submap)
            submap[1] = prefix .. submap[1]
            List.append(keymaps, submap)
        end)
    end)

    List(keymaps):foreach(function(keymap) vim.keymap.set(modes, unpack(keymap)) end)
end)
