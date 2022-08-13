local map = vim.keymap.set

vim.g.sandwich_no_default_key_mappings = 1
vim.g.operator_sandwich_no_default_key_mappings = 1

-- I use sneak more than sandwich, and I only ever use qq;
-- map sandwich bindings to q<etc>

-- add
map({'n', 'x'}, 'qa', "<Plug>(operator-sandwich-add)", {silent = true, remap = true})
map({'o'}, 'qa', "<Plug>(operator-sandwich-g@)", {silent = true, remap = true})

-- delete
map({'x'}, 'qd', "<Plug>(operator-sandwich-delete)", {silent = true, remap = true})

-- replace
map({'x'}, 'qr', "<Plug>(operator-sandwich-replace)", {silent = true, remap = true})

-- combos
map(
    {'n'},
    'qd',
    "<Plug>(operator-sandwich-delete)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-query-a)",
    {silent=true, remap=true, unique=true}
)

map(
    'n',
    'qr',
    "<Plug>(operator-sandwich-replace)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-query-a)",
    {silent = true, remap = true, unique=true}
)

map(
    'n',
    'qdb',
    "<Plug>(operator-sandwich-delete)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-auto-a)",
    {silent = true, remap = true, unique=true}
)

map(
    'n',
    'qrb',
    "<Plug>(operator-sandwich-replace)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-auto-a)",
    {silent = true, remap = true, unique=true}
)
