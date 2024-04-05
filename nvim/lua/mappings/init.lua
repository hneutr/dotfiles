local maps = Dict({
    n = {
        -- select last selection
        gV = '`[v`]',
        -- play 'q' macro
        Q = '@q',
        -- easier backstepping
        {"<c-e>", "gE"},
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

        [vim.g.mapleader] = {
            -- start/end of line
            h = "^",
            l = "$",
            -- rerun last command
            c = ":<c-p><cr>",
            -- quit
            q = ":q<cr>",
            -- close buffer
            k = {require('util').kill_buffer_and_go_to_next, {silent = true}},
            -- Conditionally modify character at end of line
            [","] = {function() require('util').modify_line_end(',') end, {silent = true}},
            [";"] = {function() require('util').modify_line_end(';') end, {silent = true}},
        },
    },
    i = Dict.update(
        {
            -- esc
            jk = {"<esc>", {nowait = true}},
            -- paste
            {"<c-]>", '<c-r>"'},
            -- forward delete (macos)
            {"<c-d>", "<del>"},
            -- delete next/previous word
            {"<c-s>", "<c-\\><c-o>de"},
            {"<c-w>", "<c-\\><c-o>db"},
            -- indent/dedent
            {"<c-l>", "<c-t>"},
            {"<c-h>", "<c-d>"},
            -- move to start/end of line (shell)
            {"<c-e>", "<c-o>A"},
            {"<c-a>", "<c-o>I"},
        },
        require('mappings.symbols'):transformk(function(k)
            return string.format("<%s-%s>", vim.g.symbol_insert_modifier, k)
        end)
    ),
    v = {
        -- retain visual selection after indent/dedent
        {'>', '>gv'},
        {'<', '<gv'},
    },
    nx = {
        -- easy align
        ga = "<Plug>(EasyAlign)",
    },
    nv = {
        -- move by visual line
        j = "gj",
        k = "gk",
        -- center after jumping + consistent direction next/previous behavior
        n = {"'Nn'[v:searchforward].'zz'", {expr = true}},
        N = {"'nN'[v:searchforward].'zz'", {expr = true}},
        -- center after jumping
        {"<c-f>", "<c-f>zz"},
        {"<c-b>", "<c-b>zz"},
        -- easy commandmode
        {"<cr>", ':'},
    },
    c = {
        -- move to start/end of line (shell)
        {"<c-a>", "<home>"},
        {"<c-e>", "<end>"},
        -- next/previous command (shell)
        {"<c-n>", "<down>"},
        {"<c-p>", "<up>"},
        -- move to next/previous word (shell)
        {"<m-left>", "<s-left>"},
        {"<m-right>", "<s-right>"},
    },
    t = {
        -- exit
        {"<esc>", "<c-\\><c-n>", {nowait = true}},
        {"<c-[>", "<c-\\><c-n>", {nowait = true}},
        -- paste
        {"<c-]>", '<c-\\><c-n>""pA'},
        -- <c-r> like in insert mode
        {"<c-r>", [['<c-\><c-n>"'.nr2char(getchar()).'pi']], {expr = true}},
        -- consistent window movement commands
        {"<c-h>", "<c-\\><c-n><c-w>h", {nowait = true}},
        {"<c-j>", "<c-\\><c-n><c-w>j", {nowait = true}},
        {"<c-k>", "<c-\\><c-n><c-w>k", {nowait = true}},
        {"<c-l>", "<c-\\><c-n><c-w>l", {nowait = true}},
    },
})

maps:transformv(function(nested_mappings)
    local to_flatten = List({nested_mappings})
    local mappings = List()
    while #to_flatten > 0 do
        local current = to_flatten:pop()

        mappings:extend(List(current))

        Dict(current):foreach(function(lhs, val)
            local rhs, opts
            if type(val) == "table" then
                if #val > 0 then
                    rhs, opts = unpack(val)
                else
                    to_flatten:append(Dict(val):transformk(function(_lhs) return lhs .. _lhs end))
                end
            else
                rhs = val
            end

            if rhs then
                mappings:append({lhs, rhs, opts})
            end
        end)
    end

    return mappings
end):foreach(function(modes, mappings)
    modes = List(modes)
    mappings:foreach(function(mapping)
        local lhs, rhs, opts = unpack(mapping)
        vim.keymap.set(modes, lhs, rhs, opts)
    end)
end)
