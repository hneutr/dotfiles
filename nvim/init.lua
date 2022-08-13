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
require'plugins'
