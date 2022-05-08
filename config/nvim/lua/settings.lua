-- write all the time
vim.o.autowriteall = true

vim.o.background = 'dark'

-- '.': current buffer
-- 'w': other windows
-- 'b': buffers in buffer list
-- 'u': unloaded buffers
-- 'i': OFF. current and included files
-- 't': OFF. scan tags
vim.bo.complete = ".,w,b,u"

vim.o.completeopt = "menuone,noinsert,noselect"

vim.o.fileformats = "unix,dos,mac"

-- make substitutions global by default
vim.o.gdefault = true

-- show results of a command while typing
vim.o.inccommand = 'nosplit'

-- redraw less
vim.o.lazyredraw = true

-- break at words
vim.o.linebreak = true

-- don't clutter with .swp files
vim.o.swapfile = false

-- shorten status updates:
-- - a: standard abbreviations
-- - c: don't give ins-completion-menu messages
-- - A: don't give the ATTENTION message when a swap file is found
vim.o.shortmess = 'acA'

-- show matching parentheses
vim.o.showmatch = true

vim.o.splitbelow = true

vim.o.splitright = true

-- statusline:
-- left side: full path (%.100F)
-- switch to right side: (%=)
-- right side: (%c)
vim.o.statusline = "%.100F%=%c"

vim.o.textwidth = 100

-- extend mapping timeout time
vim.o.timeoutlen = 1000

-- shorten key code timeout time
vim.o.ttimeoutlen = 0

vim.o.undodir = "~/.config/nvim/undodir"

vim.bo.undofile = true

-- ignore some filetypes in completion
vim.o.wildignore =".DS_Store,.git,.git/*,*.tmp,*.swp,*.png,*.jpg,*.gif,*.gz"

vim.o.wildignorecase = true

vim.o.wildmode = "list:longest,full"

------------------------------------[ folds ]-----------------------------------

-- I don't really like folds
vim.o.foldenable = false

-- but if they're on...
-- use indentation
vim.o.foldmethod = 'indent'

-- and only fold one level
vim.o.foldnestmax = 1

---------------------------------[ indentation ]--------------------------------
-- I like my comments to autowrap
vim.o.autoindent = true

vim.bo.cindent = true

-- I don't think this does anythign with expandtab and softtabstop
-- vim.bo.shiftwidth = 4

vim.bo.softtabstop = 4

vim.o.expandtab = true

-- if there are spaces when </>, round down
vim.o.shiftround = true

----------------------------------[ searching ]---------------------------------
-- ignore case when searching
vim.o.ignorecase = true

-- make completions case-intelligent
vim.bo.infercase = true

-- override ignore case if search includes capital letters
vim.o.smartcase = true
