Spruce = {
    opts = {
        width = 80,
        margins = {
            top = 3,
            bottom = 3,
        },
        win_conf = {
            win = 0,
            style = 'minimal',
            focusable = false,
            noautocmd = true,
        },
        namespaces = {
            spruce_margin = {
                StatusLineNC = {fg = "#1e1e2f"},
                WinSeparator = {fg = "#1e1e2f"},
            },
            spruce_text = {
                StatusLine = {fg = "#1e1e2f"},
                StatusLineNC = {fg = "#1e1e2f"},
                WinSeparator = {fg = "#1e1e2f"},
            },
        },
        keymap = {
            open = {
                ["<leader>q"] = "<cmd>Spruce | quit<cr>",
                ["<c-h>"] = "<NOP>",
                ["<c-j>"] = "<NOP>",
                ["<c-k>"] = "<NOP>",
                ["<c-l>"] = "<NOP>",
            },
            close = {
                ["<leader>q"] = ":q<cr>",
                ["<c-h>"] = "<c-w>h",
                ["<c-j>"] = "<c-w>j",
                ["<c-k>"] = "<c-w>k",
                ["<c-l>"] = "<c-w>l",
            },
            init = {
                ["<leader>dz"] = function() Spruce.toggle() end,
            }
        }
    },
    data = {}
}

function Spruce.apply_keymap(key, opts)
    opts = opts or {silent = true, buffer = true}
    for lhs, rhs in pairs(Spruce.opts.keymap[key]) do
        vim.keymap.set("n", lhs, rhs, opts)
    end
end

function Spruce.open(win)
    win = win or vim.fn.win_getid()

    Spruce.add_margins(win)

    local namespaces = Spruce.get_namespaces()

    vim.api.nvim_win_set_hl_ns(win, namespaces.spruce_text)

    vim.tbl_map(
        function(id) vim.api.nvim_win_set_hl_ns(id, namespaces.spruce_margin) end,
        Spruce.data[win].margins
    )

    vim.b.spruce = true

    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.spell = true

    vim.opt.showmode = false
    vim.opt.showcmd = false

    if vim.opt.ft:get() == 'markdown' then
        require('render-markdown').buf_disable()
        require("plugins.render-markdown")(true)
    end

    Spruce.apply_keymap("open")
    vim.fn.win_gotoid(win)
end

function Spruce.get_namespaces()
    local namespaces = vim.api.nvim_get_namespaces()

    for name, highlights in pairs(Spruce.opts.namespaces) do
        if not namespaces[name] then
            namespaces[name] = vim.api.nvim_create_namespace(name)
            for group, highlight in pairs(highlights) do
                vim.api.nvim_set_hl(namespaces[name], group, highlight)
            end
        end
    end

    return namespaces
end

function Spruce.add_margins(win)
    local horizontal_space = vim.api.nvim_win_get_width(0) - Spruce.opts.width - 2

    Spruce.data[win] = {buffer = vim.api.nvim_create_buf(false, true)}
    Spruce.data[win].margins = vim.tbl_map(
        function(margin)
            return vim.api.nvim_open_win(
                Spruce.data[win].buffer,
                false,
                vim.tbl_extend("force", margin, Spruce.opts.win_conf)
            )
        end,
        {
            {split = 'above', height = Spruce.opts.margins.top},
            {split = 'below', height = Spruce.opts.margins.bottom},
            {split = 'left', width = math.floor(horizontal_space  / 2)},
            {split = 'right', width = math.ceil(horizontal_space  / 2)},
        }
    )

    Spruce.data[win].windows = vim.list_extend({win}, Spruce.data[win].margins)
end

function Spruce.close(win)
    win = win or vim.fn.win_getid()

    if not Spruce.data[win] then
        return false
    end

    vim.api.nvim_win_set_hl_ns(win, 0)

    vim.b.spruce = false

    vim.opt_local.number = true
    vim.opt_local.relativenumber = true
    vim.opt_local.spell = false

    vim.opt.showmode = true
    vim.opt.showcmd = true

    vim.tbl_map(
        function(_win) vim.api.nvim_win_close(_win, true) end,
        Spruce.data[win].margins
    )

    vim.api.nvim_buf_delete(Spruce.data[win].buffer, {force = true})

    Spruce.apply_keymap("close")

    if vim.opt.ft:get() == 'markdown' then
        require("plugins.render-markdown")()
    end

    Spruce.data[win] = nil

    return true
end

function Spruce.toggle()
    Spruce[vim.b.spruce and "close" or "open"](vim.fn.win_getid())
end

Spruce.apply_keymap("init", {silent = true})

vim.api.nvim_create_user_command("Spruce", Spruce.toggle, {bar = true})

vim.api.nvim_create_autocmd(
    {"BufEnter", "BufWinEnter"},
    {
        callback = function()
            local d = Spruce.data[vim.fn.win_getid()] or {}
            vim.tbl_map(
                function(win)
                    vim.wo[win].number = false
                    vim.wo[win].relativenumber = false
                end,
                d.windows or {}
            )
        end,
    }
)

return Spruce
