--------------------------------------------------------------------------------
--                    structure and guiding principles                        --
--------------------------------------------------------------------------------
-- 1. Be consistent
-- 2. Readability is valuable
-- 3. Functional value > Aesthetic value
-- 4. Comment regularly
-- 5. Comment only when useful
-- 6. Build for yourself
-- 7. Modularity is good when it helps

-- Style:
-- - comments on the line above their referant
--------------------------------------------------------------------------------
require'util'
require'util.tbl'

vim.g.vim_config = _G.joinpath(vim.env.HOME, '.config/nvim/')

require'settings'
require'mappings'

vim.cmd("source " .. _G.joinpath(vim.g.vim_config, "plugins.vim"))

vim.g.python3_host_prog = '/Users/hne/.pyenv/shims/python3'

--------------------------------------------------------------------------------
--                                testing                                     --
--------------------------------------------------------------------------------
-- testing how to avoid stupid paste mode
-- let &t_SI .= "\<Esc>[?2004h"
-- let &t_EI .= "\<Esc>[?2004l"

-- inoremap <special> <expr> <Esc>[200~ XTermPasteBegin()

-- function! XTermPasteBegin()
--     set pastetoggle=<Esc>[201~
--     set paste
--     return ""
-- endfunction
