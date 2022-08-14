-- move to next match immediately, tab through stuff
vim.g['sneak#label'] = 1

-- always go the same way.
vim.g['sneak#absolute_dir'] = 1

-- case dependent on ignorecase+smartcase
vim.g['sneak#use_ic_scs'] = 1

vim.g['sneak#label_esc'] = "<c-c>"

vim.keymap.set('n', 's', '<Plug>Sneak_s', {remap = true})
vim.keymap.set('n', 'S', '<Plug>Sneak_S', {remap = true})
vim.keymap.set('', 'f', '<Plug>Sneak_f', {remap = true})
vim.keymap.set('', 'F', '<Plug>Sneak_F', {remap = true})
vim.keymap.set('', 't', '<Plug>Sneak_t', {remap = true})
vim.keymap.set('', 'T', '<Plug>Sneak_T', {remap = true})
