local Path = require("hl.Path")

vim.g.python3_host_prog = vim.env.NVIM_PYTHON

vim.g.mapleader = " "

-- use "option-char" to insert non-ascii characters
vim.g.symbol_insert_modifier = "M"

-- write all the time
vim.opt.autowriteall = true

vim.opt.background = 'dark'

vim.opt.completeopt = {"menuone", "noinsert", "noselect"}

vim.opt.dictionary = "/usr/dict/words"

vim.opt.fileformats = {"unix", "dos", "mac"}

-- make substitutions global by default
vim.opt.gdefault = true

-- use rg if available
if vim.fn.executable('rg') > 0 then
	vim.opt.grepprg = "rg --vimgrep"
end

-- cursor
vim.opt.guicursor = {
    -- normal/visual/command: block
    "n-v-c:block-Cursor/lCursor-blinkon0",
    -- insert: |
    "i-ci:ver25-Cursor/lCursor",
    -- replace: _
    "r-cr:hor20-Cursor/lCursor",
}

-- show results of a command while typing
vim.opt.inccommand = 'nosplit'

-- redraw less
vim.opt.lazyredraw = true

-- don't clutter with .swp files
vim.opt.swapfile = false

-- shorten status updates:
-- - a: standard abbreviations
-- - c: don't give ins-completion-menu messages
-- - A: don't give the ATTENTION message when a swap file is found
vim.opt.shortmess = "acA"

-- show matching parentheses
vim.opt.showmatch = true

vim.opt.splitbelow = true

vim.opt.splitright = true

-- statusline:
-- left side: full path (%.100F)
-- switch to right side: (%=)
-- right side: (%c)
vim.opt.statusline = "%.100F%=%c"

vim.opt.spellsuggest = {"best", "5"}

-- term colors
vim.opt.termguicolors = true

-- extend mapping timeout time
vim.opt.timeoutlen = 1000

-- shorten key code timeout time
vim.opt.ttimeoutlen = 0

vim.opt.undodir = Path.join(vim.g.vim_config, ".undodir")

-- save things regularly
vim.opt.updatetime = 300

-- ignore some filetypes in completion
vim.opt.wildignore = {
    ".DS_Store",
    ".git",
    ".git/*",
    "*.tmp",
    "*.swp",
    "*.png",
    "*.jpg",
    "*.gif",
    "*.gz",
}

vim.opt.wildignorecase = true

vim.opt.wildmode = {"list:longest", "full"}

-- if there are spaces when </>, round down
vim.opt.shiftround = true

-- ignore case when searching
vim.opt.ignorecase = true

-- override ignore case if search includes capital letters
vim.opt.smartcase = true

--------------------------------------------------------------------------------
--                             window options                                 --
--------------------------------------------------------------------------------
vim.api.nvim_create_autocmd(
    {"VimEnter", "WinEnter"},
    {
        pattern="*",
        callback=function()
            vim.opt_local.linebreak = true

            vim.opt_local.cursorline = false

            -- folds
            vim.opt_local.foldenable = false
            vim.opt_local.foldmethod = 'indent'
            vim.opt_local.foldnestmax = 1
        end
    }
)

--------------------------------------------------------------------------------
--                             buffer options                                 --
--------------------------------------------------------------------------------
vim.api.nvim_create_autocmd(
    {"VimEnter", "BufEnter"},
    {
        pattern="*",
        callback=function()
            vim.opt_local.complete = {
                ".", -- '.': current buffer
                "w", -- 'w': other windows
                "b", -- 'b': buffers in buffer list
                "u", -- 'u': unloaded buffers
            }

            vim.opt_local.textwidth = 100

            vim.opt_local.undofile = true

            vim.opt_local.infercase = true

            vim.opt_local.spelllang = "en_us"

            vim.opt_local.spellfile = Path.join(vim.g.vim_config, "spell/en.utf-8.add")

            -- indent
            vim.opt_local.autoindent = true
            vim.opt_local.cindent = true
            vim.opt_local.shiftwidth = 4
            vim.opt_local.softtabstop = 4
            vim.opt_local.expandtab = true
        end,
    }
)

--------------------------------------------------------------------------------
--                                  plugins                                   --
--------------------------------------------------------------------------------
vim.g.snip_ft_strings = {
    javascript = {print = 'console.log(%s)'},
    lua = {print = 'print(require("inspect")(%s))'},
    python = {print = 'print(%s)'},
    markdown = {comment = '= %s'},
    vim = {print = 'echo %s'},
    zsh = {print = 'echo %s'},
    sh = {print = 'echo %s'},
}
