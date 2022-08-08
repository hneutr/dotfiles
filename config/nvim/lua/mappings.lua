local leader = " "
vim.g.mapleader = leader

-- the prefix I use to "namespace" plugin mappings
vim.g.pluginleader = " d"

local maps = {
    n = {
        -- select last paste/visual selection
        { 'gV', '`[v`]' },
        -- swap */# (match _W_ord) and g*/g# (match _w_ord)
        { '*', 'g*' },
        { 'g*', '*' },
        { '#', 'g#' },
        { 'g#', '#' },
        -- restore cursor position after joining lines
        { 'J', "mjJ`j" },
        -- play 'q' macro
        { 'Q', '@q' },
        -- don't store "{"/"}" motions in jump list
        { '}', ':<c-u>execute "keepjumps normal! " . v:count1 . "}"<cr>', { silent = true } },
        { '{', ':<c-u>execute "keepjumps normal! " . v:count1 . "{"<cr>', { silent = true } },
        -- mark before searching (p = "previous")
        { '/', 'mp/' },
        { '?', 'mp?' },
        -- move to end/start of line easily
        { leader .. "l", "$" },
        { leader .. "h", "^" },
        -- Conditionally modify character at end of line
        { leader .. ",", ":call lib#ModifyLineEndDelimiter(',')<cr>", { silent = true } },
        { leader .. ";", ":call lib#ModifyLineEndDelimiter(';')<cr>", { silent = true } },
        -- run last command
        { leader .. "c", ":<c-p><cr>" },
        -- quit with an arpeggiation (save the pinky)
        { leader .. "q", ":q<cr>" },
        -- kill the buffer with an arpeggiation (stp)
        { leader .. "k", ":call lib#KillBufferAndGoToNext()<cr>", { silent = true} },
        -- switch buffers with tab/s-tab
        { "<tab>", ":bn<cr>" },
        { "<s-tab>", ":bp<cr>" },
        -- <BS> is useless in normal mode; map it to gE
        { "<BS>", "gE" },
        -- switch panes
        { "<c-h>", "<c-w>h" },
        { "<c-j>", "<c-w>j" },
        { "<c-k>", "<c-w>k" },
        { "<c-l>", "<c-w>l" },
    },
    i = {
        { "<esc>", "<esc>", { nowait = true} },
        -- save the pinky
        { "jk", "<esc>" },
        { "<c-c>", "<nop>" },
        -- why would I want to delete only until the start of insert mode? why?
        { "<c-w>", "<c-\\><c-o>db"},
        -- forward delete to end of word
        { "<c-s>", "<c-\\><c-o>de" },
        -- change indent
        { "<c-h>", "<c-d>" },
        { "<c-l>", "<c-t>" },
        -- digraphs are good
        { "<M-->", "—" },
        { "<M-=>", "≠" },
        { "<M-Left>", "←" },
        { "<M-Right>", "→" },
        { "<M-Up>", "↑" },
        { "<M-Down>", "↓" },
        -- move to end of line
        { "<c-a>", "<c-o>A" },
        -- paste like in terminal mode
        { "", '<c-r>"' },
    },
    v = {
        -- keep visual selection after indent/unindent
        { '>', '>gv' },
        { '<', '<gv' },
    },
    nx = {
        -- easy align
        { "ga", "<Plug>(EasyAlign)"},
    },
    nv = {
        -- move vertically by visual line
        { "j", "gj" },
        { "k", "gk" },
        -- recenter the screen after jumping forward
        { "<c-f>", "<c-f>zz" },
        { "<c-b>", "<c-b>zz" },
        -- make n (N) always go forward (backward); recenter after jumping
        { 'n', "'Nn'[v:searchforward].'zz'", { expr = true} },
        { 'N', "'nN'[v:searchforward].'zz'", { expr = true} },
        -- use enter as colon for faster commands
        { "<cr>", ':' },
    },
    c = {
        -- make start of line and end of line movements match zsh/bash
        { "<c-a>", "<home>" },
        { "<c-e>", "<end>" },
        -- Move by word
        { "<m-b>", "<s-left>" },
        { "<m-f>", "<s-right>" },
        -- make commandline history smarter (use text entered so far)
        { "<c-n>", "<down>" },
        { "<c-p>", "<up>" },
    },
    t = {
        -- I like to get out with one key
        { "<esc>", "<c-\\><c-n>" },
        { "<c-[>", "<c-\\><c-n>" },
        -- consistent window movement commands
        { "<c-h>", "<c-\\><c-n><c-w>h" },
        { "<c-j>", "<c-\\><c-n><c-w>j" },
        { "<c-k>", "<c-\\><c-n><c-w>k" },
        { "<c-l>", "<c-\\><c-n><c-w>l" },
        -- make <c-r> work like in insert mode
        { "<c-r>", "'<c-\\><c-n>" .. '"' .. "'.nr2char(getchar()).'pi'", { expr = true } },
        -- make pasting nice
        { "<c-]>", '<c-\\><c-n>""pA' },
    },
    ox = {
        -- visually select the whole buffer
        { "A", ":<C-U>normal! mzggVG<CR>`z" },
    },
}

for modes, mode_maps in pairs(maps) do
    for _, map in ipairs(mode_maps) do
        local lhs, rhs, opts = unpack(map)

        opts = _G.default_args(opts, { noremap = true })

        for i = 1, #modes do
            local mode = modes:sub(i, i)
            vim.api.nvim_set_keymap(mode, lhs, rhs, opts)
        end
    end
end