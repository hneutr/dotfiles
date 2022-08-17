vim.g.python3_host_prog = vim.env.NVIM_PYTHON

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

-- if there are spaces when </>, round down
vim.o.shiftround = true

-- ignore case when searching
vim.o.ignorecase = true

-- override ignore case if search includes capital letters
vim.o.smartcase = true

-- because ftplugins play with formatting opts, settings are in `/after/plugin/formatting.vim`

--------------------------------------------------------------------------------
--                             window options                                 --
--------------------------------------------------------------------------------
vim.api.nvim_create_autocmd({"WinEnter"}, {pattern="*", callback=require'util'.run_once({
    scope = 'w',
    key = 'win_opts_applied',
    fn = function()
        vim.wo.linebreak = true

        vim.wo.cursorline = false

        -----------------------------------[ folds ]----------------------------
        vim.wo.foldenable = false
        vim.wo.foldmethod = 'indent'
        vim.wo.foldnestmax = 1
    end,
})})

--------------------------------------------------------------------------------
--                             buffer options                                 --
--------------------------------------------------------------------------------
vim.api.nvim_create_autocmd({"BufEnter"}, { pattern="*", callback=require'util'.run_once({
    scope = 'b',
    key = 'buf_opts_applied',
    fn = function()
        -- '.': current buffer
        -- 'w': other windows
        -- 'b': buffers in buffer list
        -- 'u': unloaded buffers
        -- 'i': OFF. current and included files
        -- 't': OFF. scan tags
        vim.bo.complete = ".,w,b,u"

        -- 100 is nice
        vim.bo.textwidth = 100

        vim.bo.undofile = true

        vim.bo.infercase = true

        -------------------------------[ indentation ]--------------------------
        vim.bo.autoindent = true
        vim.bo.cindent = true
        vim.bo.shiftwidth = 4
        vim.bo.softtabstop = 4
        vim.bo.expandtab = true
    end,
})})

--------------------------------------------------------------------------------
--                                  plugins                                   --
--------------------------------------------------------------------------------
vim.g.snip_ft_printstrings = {
    javascript = 'console.log(%s)',
    lua = 'vim.pretty_print(%s)',
    python = 'print(%s)',
    vim = 'echo %s',
    zsh = 'echo %s',
    sh = 'echo %s',
}

-- polyglot is super annoying
vim.g.polyglot_disabled = { "autoindent" }

-- default maps are stupid
vim.g.vim_markdown_no_default_key_mappings = 1
vim.g.vim_markdown_auto_insert_bullets = 0
vim.g.vim_markdown_new_list_item_indent = 0

vim.g.is_pythonsense_alternate_motion_keymaps = 1
