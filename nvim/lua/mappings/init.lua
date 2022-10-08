local maps = {
    n = {
        -- select last selection
        {'gV', '`[v`]'},
        -- restore cursor position after joining lines
        {'J', function() require("list").Buffer():join_lines() end, {silent = true}},
        -- continue lists
        {'o', [[o<cmd>lua require('list').autolist()<cr>]], {buffer = true}},
        -- play 'q' macro
        {'Q', '@q'},
        -- <BS> is useless in normal mode
        {"<BS>", "gE"},
        -- swap */# (match _W_ord) and g*/g# (match _w_ord)
        {'*', 'g*'},
        {'g*', '*'},
        {'#', 'g#'},
        {'g#', '#'},
        -- don't store "{"/"}" motions in jump list
        {'}', ':<c-u>execute "keepjumps normal! " . v:count1 . "}"<cr>', {silent = true}},
        {'{', ':<c-u>execute "keepjumps normal! " . v:count1 . "{"<cr>', {silent = true}},
        -- mark before searching (p = "previous")
        {'/', 'mp/'},
        {'?', 'mp?'},
        -- windows navigation
        {"<c-h>", "<c-w>h"},
        {"<c-j>", "<c-w>j"},
        {"<c-k>", "<c-w>k"},
        {"<c-l>", "<c-w>l"},
        -- next/previous buffer
        {"<tab>", ":bnext<cr>"},
        {"<s-tab>", ":bprev<cr>"},
        -- move to end/start of line
        {vim.g.mapleader .. "l", "$"},
        {vim.g.mapleader .. "h", "^"},
        -- Conditionally modify character at end of line
        {vim.g.mapleader .. ",", function() require('util').modify_line_end(',') end, {silent = true}},
        {vim.g.mapleader .. ";", function() require('util').modify_line_end(';') end, {silent = true}},
        -- run last command
        {vim.g.mapleader .. "c", ":<c-p><cr>"},
        -- quit
        {vim.g.mapleader .. "q", ":q<cr>"},
        -- close buffer
        {vim.g.mapleader .. "k", require('util').kill_buffer_and_go_to_next, {silent = true}},
        -- fuzzy search
        {vim.g.mapleader .. "df", require('fzf-lua').files},
        -- start goyo
        {vim.g.mapleader .. "dg", ":GoyoToggle<cr>"},
    },
    i = {
        -- esc
        {"jk", "<esc>", {nowait=true}},
        -- paste
        {"<c-]>", '<c-r>"'},
        -- forward delete (macos)
        {"<c-d>", "<del>"},
        -- delete next/previous word
        {"<c-s>", "<c-\\><c-o>de"},
        {"<c-w>", "<c-\\><c-o>db"},
        -- indent/unindent
        {"<c-l>", "<c-t>"},
        {"<c-h>", "<c-d>"},
        -- move to start/end of line (shell)
        {"<c-e>", "<c-o>A"},
        {"<c-a>", "<c-o>I"},
        -- continue lists
        {"<cr>", [[<cr><cmd>lua require('list').autolist()<cr>]], {buffer = true}},
        
    },
    v = {
        -- keep visual selection after indent/unindent
        {'>', '>gv'},
        {'<', '<gv'},
    },
    nx = {
        -- easy align
        {"ga", "<Plug>(EasyAlign)"},
    },
    nv = {
        -- enter commandmode easily
        {"<cr>", ':'},
        -- move by visual line
        {"j", "gj"},
        {"k", "gk"},
        -- center after jump
        {"<c-f>", "<c-f>zz"},
        {"<c-b>", "<c-b>zz"},
        -- center after jump + consistent direction next/previous behavior
        {'n', "'Nn'[v:searchforward].'zz'", {expr = true}},
        {'N', "'nN'[v:searchforward].'zz'", {expr = true}},
    },
    c = {
        -- move to start/end of line (shell)
        {"<c-a>", "<home>"},
        {"<c-e>", "<end>"},
        -- next/previous command (shell)
        { "<c-n>", "<down>"},
        { "<c-p>", "<up>"},
        -- move to next/previous word (shell)
        {"<m-left>", "<s-left>"},
        {"<m-right>", "<s-right>"},
    },
    t = {
        -- exit
        {"<esc>", "<c-\\><c-n>", {nowait=true}},
        {"<c-[>", "<c-\\><c-n>", {nowait=true}},
        -- paste
        {"<c-]>", '<c-\\><c-n>""pA'},
        -- <c-r> like in insert mode
        {"<c-r>", [['<c-\><c-n>"'.nr2char(getchar()).'pi']], {expr = true}},
        -- consistent window movement commands
        {"<c-h>", "<c-\\><c-n><c-w>h", {nowait=true}},
        {"<c-j>", "<c-\\><c-n><c-w>j", {nowait=true}},
        {"<c-k>", "<c-\\><c-n><c-w>k", {nowait=true}},
        {"<c-l>", "<c-\\><c-n><c-w>l", {nowait=true}},
    },
}

for _, mapping in ipairs(require('mappings.symbols')) do
    table.insert(maps.i, mapping)
end

for modes_str, maps in pairs(maps) do
    local modes = {}
    for i = 1, #modes_str do
        table.insert(modes, modes_str:sub(i, i))
    end

    for _, map in ipairs(maps) do
        local lhs, rhs, opts = unpack(map)
        vim.keymap.set(modes, lhs, rhs, opts)
    end
end
