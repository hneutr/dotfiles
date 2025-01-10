local M = {
    opts = {
        width = 80,
        margins = {
            top = 3,
            bottom = 3,
        },
        win_conf = {
            win = 0,
            style = 'minimal',
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
        }
    },
}

local data = {}

function M.open(win)
    win = win or vim.fn.win_getid()

    M.add_margins(win)

    local namespaces = M.get_namespaces()

    vim.api.nvim_win_set_hl_ns(win, namespaces.spruce_text)

    vim.tbl_map(
        function(id) vim.api.nvim_win_set_hl_ns(id, namespaces.spruce_margin) end,
        data[win].margins
    )

    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.spell = true

    vim.opt.showmode = false
    vim.opt.showcmd = false

    if vim.opt.ft:get() == 'markdown' then
        require("plugins.render-markdown")(true)
    end

    vim.keymap.set("n", "<leader>q", "<cmd>Spruce | quit<cr>", {silent = true})
end

function M.get_namespaces()
    local namespaces = vim.api.nvim_get_namespaces()
    for name, highlights in pairs(M.opts.namespaces) do
        if not namespaces[name] then
            namespaces[name] = vim.api.nvim_create_namespace(name)
            for group, highlight in pairs(highlights) do
                vim.api.nvim_set_hl(namespaces[name], group, highlight)
            end
        end
    end
    return namespaces
end

function M.add_margins(win)
    local horizontal_space = vim.api.nvim_win_get_width(0) - M.opts.width - 2

    data[win] = {buffer = vim.api.nvim_create_buf(false, true)}

    data[win].margins = vim.tbl_map(
        function(margin)
            return vim.api.nvim_open_win(
                data[win].buffer,
                false,
                vim.tbl_extend("force", margin, M.opts.win_conf)
            )
        end,
        {
            {split = 'above', height = M.opts.margins.top},
            {split = 'below', height = M.opts.margins.bottom},
            {split = 'left', width = math.floor(horizontal_space  / 2)},
            {split = 'right', width = math.ceil(horizontal_space  / 2)},
        }
    )
end

function M.close(win)
    win = win or vim.fn.win_getid()

    if not data[win] then
        return false
    end

    vim.api.nvim_win_set_hl_ns(win, 0)

    vim.opt_local.number = true
    vim.opt_local.relativenumber = true
    vim.opt_local.spell = false

    vim.opt.showmode = true
    vim.opt.showcmd = true

    vim.tbl_map(function(_win) vim.api.nvim_win_close(_win, true) end, data[win].margins)
    vim.api.nvim_buf_delete(data[win].buffer, {force = true})

    vim.keymap.set("n", " q", ":q<cr>", {silent = true})

    if vim.opt.ft:get() == 'markdown' then
        require("plugins.render-markdown")()
    end

    data[win] = nil

    return true
end

function M.toggle()
    local win = vim.fn.win_getid()
    return M.close(win) or M.open(win)
end

vim.keymap.set({"n"}, "<leader>ds", M.toggle)
vim.api.nvim_create_user_command("Spruce", M.toggle, {bar = true})
Spruce = M

return M
