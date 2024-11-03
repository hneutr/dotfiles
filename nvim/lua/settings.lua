vim.g.python3_host_prog = vim.env.NVIM_PYTHON

vim.g.mapleader = " "

vim.g.snip_ft_strings = {
    javascript = {print = 'console.log(%s)'},
    typescript = {print = 'console.log(%s)'},
    typescriptreact = {print = 'console.log(%s)'},
    lua = {print = 'print(%s)'},
    python = {print = 'print(%s)'},
    vim = {print = 'echo %s'},
    zsh = {print = 'echo %s'},
    sh = {print = 'echo %s'},
}

vim.g.ft_punctuation_toggles = {
    python = {[';'] = ':'},
}

vim.g.filetypes_to_fix_quotes_on_paste = {"markdown"}

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

    spellfile = tostring(Conf.paths.spell_file),

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

    undodir = tostring(Conf.paths.undo_dir),

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
