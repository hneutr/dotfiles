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
        settings = {
            opt = {
                showmode = false,
                showcmd = false,
            },
            opt_local = {
                number = false,
                relativenumber = false,
                spell = true,
            },
            b = {
                spruce = true,
            }
        },
        namespaces = {
            spruce_text = {
                StatusLine = {fg = "#1e1e2f"},
                StatusLineNC = {fg = "#1e1e2f"},
                WinSeparator = {fg = "#1e1e2f"},
            },
            spruce_margin = {
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
    data = {},
    namespaces = {},
}

function Spruce.apply_namespaces()
    local namespaces = vim.api.nvim_get_namespaces()

    for name, highlights in pairs(Spruce.opts.namespaces) do
        if not Spruce.namespaces[name] then
            Spruce.namespaces[name] = vim.api.nvim_create_namespace(name)
            for group, highlight in pairs(highlights) do
                vim.api.nvim_set_hl(Spruce.namespaces[name], group, highlight)
            end
        end
    end

    return namespaces
end

function Spruce.apply_keymap(key, opts)
    opts = opts or {silent = true, buffer = true}
    for lhs, rhs in pairs(Spruce.opts.keymap[key]) do
        vim.keymap.set("n", lhs, rhs, opts)
    end
end

function Spruce.apply_settings(flip)
    for scope, settings in pairs(Spruce.opts.settings) do
        for setting, value in pairs(settings) do
            if flip then
                value = not value
            end

            vim[scope][setting] = value
        end
    end
end

function Spruce.open(win)
    Spruce.add_margins(win)

    vim.api.nvim_win_set_hl_ns(win, Spruce.namespaces.spruce_text)

    Spruce.apply_keymap("open")
    Spruce.apply_settings()

    if vim.opt.ft:get() == 'markdown' then
        require('render-markdown').buf_disable()
        require("plugins.render-markdown")(true)
    end
end

function Spruce.add_margins(win)
    local horizontal_space = vim.api.nvim_win_get_width(0) - Spruce.opts.width - 2

    Spruce.data[win] = {buffer = vim.api.nvim_create_buf(false, true)}
    Spruce.data[win].margins = vim.tbl_map(
        function(margin)
            local margin_win = vim.api.nvim_open_win(
                Spruce.data[win].buffer,
                false,
                vim.tbl_extend("force", margin, Spruce.opts.win_conf)
            )

            vim.api.nvim_win_set_hl_ns(margin_win, Spruce.namespaces.spruce_margin)

            return margin_win
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
    local data = Spruce.data[win]

    if not data then
        return false
    end

    vim.tbl_map(function(_win) vim.api.nvim_win_close(_win, true) end, data.margins)

    vim.api.nvim_buf_delete(data.buffer, {force = true})
    vim.api.nvim_win_set_hl_ns(win, 0)

    Spruce.data[win] = nil

    Spruce.apply_keymap("close")
    Spruce.apply_settings(true)

    if vim.opt.ft:get() == 'markdown' then
        require("plugins.render-markdown")()
    end

    return true
end

function Spruce.toggle()
    Spruce[vim.b.spruce and "close" or "open"](vim.api.nvim_get_current_win())
end

Spruce.apply_namespaces()
Spruce.apply_keymap("init", {silent = true})

vim.api.nvim_create_user_command("Spruce", Spruce.toggle, {bar = true})
vim.api.nvim_create_autocmd(
    {"BufEnter", "BufWinEnter"},
    {
        callback = function()
            local d = Spruce.data[vim.api.nvim_get_current_win()] or {}
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
