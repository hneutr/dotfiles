local util = require('util')

local general_g = vim.api.nvim_create_augroup('general_g', {clear = true})
local aucmd = vim.api.nvim_create_autocmd

-- diagnostics suck
aucmd({"BufEnter"}, {pattern='*', group=general_g, callback=function() vim.diagnostic.disable(0) end})

-- save whenever things change
aucmd({"TextChanged", "InsertLeave"}, {pattern='*', callback=util.save_and_restore_visual_selection_marks})

-- turn numbers on for normal buffers; turn them off for terminal buffers
aucmd({"TermOpen", "BufWinEnter"}, {pattern='*', callback=util.set_number_display})

-- enter insert mode whenever we're in a terminal
aucmd({"TermOpen", "BufWinEnter", "BufEnter"}, {pattern="term://*", command="startinsert"})
aucmd({"VimEnter", "BufWinEnter", "BufEnter", "WinEnter", "TermOpen"}, {pattern="*", callback=util.set_statusline})

-- open file at last point
aucmd({"BufReadPost"}, {pattern='*', command=[[if @% !~# '\.git[\/\\]COMMIT_EDITMSG$' && line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif]]})
