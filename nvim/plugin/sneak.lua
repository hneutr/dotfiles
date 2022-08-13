-- move to next match immediately, tab through stuff
vim.g['sneak#label'] = 1

-- always go the same way.
vim.g['sneak#absolute_dir'] = 1

-- case dependent on ignorecase+smartcase
vim.g['sneak#use_ic_scs'] = 1

vim.g['sneak#label_esc'] = "<c-c>"

vim.api.nvim_set_keymap('', 's', '<Plug>Sneak_s', {})
vim.api.nvim_set_keymap('', 'S', '<Plug>Sneak_S', {})
vim.api.nvim_set_keymap('', 'f', '<Plug>Sneak_f', {})
vim.api.nvim_set_keymap('', 'F', '<Plug>Sneak_F', {})
vim.api.nvim_set_keymap('', 't', '<Plug>Sneak_t', {})
vim.api.nvim_set_keymap('', 'T', '<Plug>Sneak_T', {})
