local nvimux = require('nvimux')

local cmd = vim.api.nvim_create_user_command
cmd("Tvsplit", "vspl|term", {})
cmd("Tsplit", "spl|term", {})
cmd("Ttab", "tabnew|term", {})

-- Nvimux custom bindings
nvimux.bindings.bind_all{
  {'j', ':Tsplit', {'n', 'v', 'i', 't'}},
  {'l', ':Tvsplit', {'n', 'v', 'i', 't'}},
  {'c', ':Ttab', {'n', 'v', 'i', 't'}},
  {'X', ':tabclose', {'n', 'v', 'i', 't'}},
}

-- Nvimux configuration
nvimux.config.set_all{
  prefix = '<C-Space>',
  open_term_by_default = true,
  quickterm_direction = 'botright',
  quickterm_orientation = 'vertical',
  quickterm_scope = 't',
  quickterm_size = '80',
}

nvimux.bootstrap()
