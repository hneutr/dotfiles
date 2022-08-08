local augroup = vim.api.nvim_create_augroup
local aucmd = vim.api.nvim_create_autocmd

-- write all the time
vim.go.autowriteall = true

vim.go.background = 'dark'

vim.o.completeopt = "menuone,noinsert,noselect"

vim.o.dictionary = "/usr/dict/words"

vim.o.fileformats = "unix,dos,mac"

-- make substitutions global by default
vim.o.gdefault = true

-- use rg if available
if vim.fn.executable('rg') > 0 then
	vim.o.grepprg = "rg --vimgrep"
end

-- cursor magic:
-- normal, visual, command = block
local guicursor = "n-v-c:block-Cursor/lCursor-blinkon0"
-- insert = vertical
local insert_guicursor = "i-ci:ver25-Cursor/lCursor"
-- replace = underscore
local replace_guicursor = "r-cr:hor20-Cursor/lCursor"

vim.o.guicursor = guicursor .. ',' .. insert_guicursor .. ',' .. replace_guicursor

-- show results of a command while typing
vim.o.inccommand = 'nosplit'

-- redraw less
vim.o.lazyredraw = true

-- don't clutter with .swp files
vim.o.swapfile = false

-- shorten status updates:
-- - a: standard abbreviations
-- - c: don't give ins-completion-menu messages
-- - A: don't give the ATTENTION message when a swap file is found
vim.o.shortmess = "acA"

-- show matching parentheses
vim.o.showmatch = true

vim.o.splitbelow = true

vim.o.splitright = true

-- statusline:
-- left side: full path (%.100F)
-- switch to right side: (%=)
-- right side: (%c)
vim.o.statusline = "%.100F%=%c"

-- extend mapping timeout time
vim.o.timeoutlen = 1000

-- shorten key code timeout time
vim.o.ttimeoutlen = 0

vim.o.undodir = _G.joinpath(vim.g.vim_config, ".undodir")

-- save things regularly
vim.o.updatetime = 300

-- ignore some filetypes in completion
vim.o.wildignore =".DS_Store,.git,.git/*,*.tmp,*.swp,*.png,*.jpg,*.gif,*.gz"

vim.o.wildignorecase = true

vim.o.wildmode = "list:longest,full"

-------------------------------[ indentation ]----------------------------------
-- if there are spaces when </>, round down
vim.o.shiftround = true

------------------------------------[ searching ]---------------------------------
-- ignore case when searching
vim.o.ignorecase = true

-- override ignore case if search includes capital letters
vim.o.smartcase = true

-- because ftplugins play with formatting opts, settings are in `/after/plugin/formatting.vim`

-----------------------------------[ misc ]-------------------------------------

-- polyglot is super annoying
vim.g.polyglot_disabled = { "autoindent" }

--------------------------------------------------------------------------------
--                             window options                                 --
--------------------------------------------------------------------------------
vim.api.nvim_create_autocmd({ "VimEnter", "WinNew" }, { pattern="*", callback=function() 

vim.wo.linebreak = true

vim.wo.cursorline = false

----------------------------------[ folds ]-------------------------------------
-- turn off folds
vim.wo.foldenable = false
vim.wo.foldmethod = 'indent'
vim.wo.foldnestmax = 1
vim.wo.foldtext = "lib#FoldDisplayText()"

end})

--------------------------------------------------------------------------------
--                             buffer options                                 --
--------------------------------------------------------------------------------
vim.api.nvim_create_autocmd({"BufWinEnter"}, { pattern="*", callback=function() 
-- '.': current buffer
-- 'w': other windows
-- 'b': buffers in buffer list
-- 'u': unloaded buffers
-- 'i': OFF. current and included files
-- 't': OFF. scan tags
vim.bo.complete = ".,w,b,u"

-- 80 is nice
vim.bo.textwidth = 80

vim.bo.undofile = true

vim.bo.infercase = true

-------------------------------[ indentation ]----------------------------------
vim.bo.autoindent = true
vim.bo.cindent = true
vim.bo.shiftwidth = 4
vim.bo.softtabstop = 4
vim.bo.expandtab = true

end})
