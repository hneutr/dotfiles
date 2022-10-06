local maps = {
    n = {
        -- select last paste/visual selection
        {'gV', '`[v`]'},
        -- swap */# (match _W_ord) and g*/g# (match _w_ord)
        {'*', 'g*'},
        {'g*', '*'},
        {'#', 'g#'},
        {'g#', '#'},
        -- restore cursor position after joining lines
        {'J', "mjJ`j"},
        -- play 'q' macro
        {'Q', '@q'},
        -- don't store "{"/"}" motions in jump list
        {'}', ':<c-u>execute "keepjumps normal! " . v:count1 . "}"<cr>', {silent = true}},
        {'{', ':<c-u>execute "keepjumps normal! " . v:count1 . "{"<cr>', {silent = true}},
        -- mark before searching (p = "previous")
        {'/', 'mp/'},
        {'?', 'mp?'},
        -- move to end/start of line easily
        {vim.g.mapleader .. "l", "$"},
        {vim.g.mapleader .. "h", "^"},
        -- Conditionally modify character at end of line
        {vim.g.mapleader .. ",", function() require'util'.modify_line_end(',') end, {silent = true }},
        {vim.g.mapleader .. ";", function() require'util'.modify_line_end(';') end, {silent = true }},
        -- run last command
        {vim.g.mapleader .. "c", ":<c-p><cr>"},
        -- quit with an arpeggiation (save the pinky)
        {vim.g.mapleader .. "q", ":q<cr>"},
        -- kill the buffer with an arpeggiation (stp)
        {vim.g.mapleader .. "k", require'util'.kill_buffer_and_go_to_next, {silent = true}},
        -- <BS> is useless in normal mode; map it to gE
        {"<BS>", "gE"},
        -- switch panes
        {"<c-h>", "<c-w>h"},
        {"<c-j>", "<c-w>j"},
        {"<c-k>", "<c-w>k"},
        {"<c-l>", "<c-w>l"},
        {vim.g.mapleader .. "df", require'fzf-lua'.files},
        {vim.g.mapleader .. "dg", ":GoyoToggle<cr>"},
        -- tab/shift-tab through buffers
        {"<tab>", ":bnext<cr>"},
        {"<s-tab>", ":bprev<cr>"},
    },
    i = {
        {"<esc>", "<esc>", {nowait = true}},
        -- save the pinky
        {"jk", "<esc>"},
        {"<c-c>", "<nop>"},
        -- why would I want to delete only until the start of insert mode? why?
        {"<c-w>", "<c-\\><c-o>db"},
        -- forward delete to end of word
        {"<c-s>", "<c-\\><c-o>de"},
        -- change indent
        {"<c-h>", "<c-d>"},
        {"<c-l>", "<c-t>"},
        -- move to end of line
        {"<c-a>", "<c-o>A"},
        -- paste like in terminal mode
        {"", '<c-r>"'},
        -- forward delete like macos
        {"<c-d>", "<del>"},
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
        -- move vertically by visual line
        {"j", "gj"},
        {"k", "gk"},
        -- recenter the screen after jumping forward
        {"<c-f>", "<c-f>zz"},
        {"<c-b>", "<c-b>zz"},
        -- make n (N) always go forward (backward); recenter after jumping
        {'n', "'Nn'[v:searchforward].'zz'", {expr = true}},
        {'N', "'nN'[v:searchforward].'zz'", {expr = true}},
        -- use enter as colon for faster commands
        {"<cr>", ':'},
    },
    c = {
        -- make start of line and end of line movements match zsh/bash
        {"<c-a>", "<home>"},
        {"<c-e>", "<end>"},
        -- Move by word
        {"<m-b>", "<s-left>"},
        {"<m-f>", "<s-right>"},
        -- make commandline history smarter (use text entered so far)
        { "<c-n>", "<down>"},
        { "<c-p>", "<up>"},
    },
    t = {
        -- I like to get out with one key
        {"<esc>", "<c-\\><c-n>"},
        {"<c-[>", "<c-\\><c-n>"},
        -- consistent window movement commands
        {"<c-h>", "<c-\\><c-n><c-w>h"},
        {"<c-j>", "<c-\\><c-n><c-w>j"},
        {"<c-k>", "<c-\\><c-n><c-w>k"},
        {"<c-l>", "<c-\\><c-n><c-w>l"},
        -- make <c-r> work like in insert mode
        {"<c-r>", [['<c-\><c-n>"'.nr2char(getchar()).'pi']], {expr = true}},
        -- make pasting nice
        {"<c-]>", '<c-\\><c-n>""pA'},
    },
    ox = {
        -- visually select the whole buffer
        {"A", ":<C-U>normal! mzggVG<CR>`z"},
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
