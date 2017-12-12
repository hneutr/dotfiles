lua << EOF
local nvimux = require('nvimux')

-- Nvimux custom bindings
nvimux.bindings.bind_all{
  {'j', ':TermHorizontalSplit', {'n', 'v', 'i', 't'}},
  {'l', ':TermVerticalSplit', {'n', 'v', 'i', 't'}},
  {'c', ':TermTab', {'n', 'v', 'i', 't'}},
}

-- Nvimux configuration
nvimux.config.set_all{
  prefix = '<C-Space>',
  open_term_by_default = true,
  new_window_buffer = 'single',
  quickterm_direction = 'botright',
  quickterm_orientation = 'vertical',
  -- Use 'g' for global quickterm
  quickterm_scope = 't',
  quickterm_size = '80',
}

EOF
