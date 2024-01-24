local Path = require("hl.Path")
local List = require("hl.List")
local Dict = require("hl.Dict")

vim.g.vim_config = tostring(Path.home:join('.config/nvim/'))

vim.g.python3_host_prog = vim.env.NVIM_PYTHON

vim.g.mapleader = " "

-- use "option-char" to insert non-ascii characters
vim.g.symbol_insert_modifier = "M"

vim.g.snip_ft_strings = {
    javascript = {print = 'console.log(%s)'},
    lua = {print = 'print(require("inspect")(%s))'},
    python = {print = 'print(%s)'},
    markdown = {comment = '= %s'},
    vim = {print = 'echo %s'},
    zsh = {print = 'echo %s'},
    sh = {print = 'echo %s'},
}

Dict({
    -- write all the time
    autowriteall = true, 

    background = 'dark',

    cindent = true,

    complete = {
        ".", -- '.': current buffer,
        "w", -- 'w': other windows,
        "b", -- 'b': buffers in buffer list,
        "u", -- 'u': unloaded buffers,
    },

    completeopt = {"menuone", "noinsert", "noselect"},

    cursorline = false,

    dictionary = "/usr/dict/words",

    expandtab = true,

    fileformats = {"unix", "mac"}, 

    foldenable = false,

    foldmethod = 'indent',

    foldnestmax = 1,

    -- substitutions default to global
    gdefault = true, 

	grepprg = "rg --vimgrep",

    guicursor = {
        -- normal/visual/command: block
        "n-v-c:block-Cursor/lCursor-blinkon0",
        -- insert: |
        "i-ci:ver25-Cursor/lCursor",
        -- replace: _
        "r-cr:hor20-Cursor/lCursor",
    },

    -- ignore case when searching
    ignorecase = true,

    -- show command results
    inccommand = 'nosplit',

    -- adjust case when searching
    infercase = true,

    -- redraw less
    lazyredraw = true,

    -- break lines at word boundaries
    linebreak = true,

    -- if there are spaces when </>, round down
    shiftround = true,

    shiftwidth = 4,

    -- shorten messages
    shortmess = List({
        "a", -- standard abbreviations
        "c", -- no ins-completion-menu messages
        "A", -- no swap file messages
    }):join(),

    -- show matching parentheses
    showmatch = true,

    -- consider case when search includes capital letters
    smartcase = true,

    softtabstop = 4,

    splitbelow = true,

    splitright = true,

    -- full path
    statusline = "%.100F", 

    spellfile = Path.join(vim.g.vim_config, "spell/en.utf-8.add"),

    spelllang = "en_us",

    spellsuggest = {"best", "5"},

    -- .swp files suck
    swapfile = false,

    termguicolors = true,

    textwidth = 100,

    -- extend mapping timeout time
    timeoutlen = 1000,

    -- shorten key code timeout time
    ttimeoutlen = 0,

    undodir = Path.join(vim.g.vim_config, ".undodir"),

    undofile = true,

    -- save things regularly
    updatetime = 300,

    -- filetypes to ignore in completion
    wildignore = {
        ".DS_Store",
        ".git",
        ".git/*",
        "*.tmp",
        "*.swp",
        "*.png",
        "*.jpg",
        "*.gif",
        "*.gz",
    },

    -- ignore case when completing
    wildignorecase = true,

    wildmode = {"list:longest", "full"},
}):foreach(function(key, val)
    vim.opt[key] = val
end)
