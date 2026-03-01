local get_selection = require("nvim-surround.config").get_selection

require("nvim-surround").setup({
    surrounds = {
        ["("] = {
            add = {"(", ")"},
            find = function() return get_selection({motion = "a("}) end,
            delete = "^(.)().-(.)()$",
            change = {target = "^(.)().-(.)()$"},
        },
        [")"] = {
            add = {"( ", " )"},
            find = function() return get_selection({motion = "a)"}) end,
            delete = "^(. ?)().-( ?.)()$",
            change = {target = "^(. ?)().-( ?.)()$"},
        },
        ["{"] = {
            add = {"{", "}"},
            find = function() return get_selection({motion = "a{"}) end,
            delete = "^(.)().-(.)()$",
            change = {target = "^(.)().-(.)()$"},
        },
        ["}"] = {
            add = {"{ ", " }"},
            find = function() return get_selection({motion = "a}"}) end,
            delete = "^(. ?)().-( ?.)()$",
            change = {target = "^(. ?)().-( ?.)()$"},
        },
        ["<"] = {
            add = {"<", ">"},
            find = function() return get_selection({motion = "a<"}) end,
            delete = "^(.)().-(.)()$",
            change = {target = "^(.)().-(.)()$"},
        },
        [">"] = {
            add = {"< ", " >"},
            find = function() return get_selection({motion = "a>"}) end,
            delete = "^(. ?)().-( ?.)()$",
            change = {target = "^(. ?)().-( ?.)()$"},
        },
        ["["] = {
            add = {"[", "]"},
            find = function() return get_selection({motion = "a["}) end,
            delete = "^(.)().-(.)()$",
            change = {target = "^(.)().-(.)()$"},
        },
        ["]"] = {
            add = {"[ ", " ]"},
            find = function() return get_selection({motion = "a]"}) end,
            delete = "^(. ?)().-( ?.)()$",
            change = {target = "^(. ?)().-( ?.)()$"},
        },
    }
})

vim.g.nvim_surround_no_normal_mappings = true
-- normal
vim.keymap.set("n", "ys", "<Plug>(nvim-surround-normal)", {desc = "surround {motion}"})
vim.keymap.set("n", "yss", "<Plug>(nvim-surround-normal-cur)", {desc = "surround the current line"})
vim.keymap.set("n", "yS", "<Plug>(nvim-surround-normal-line)", {desc = "surround {motion} on new lines"})
vim.keymap.set("n", "ySS", "<Plug>(nvim-surround-normal-cur-line)", {desc = "surround current line on new lines"})
vim.keymap.set("n", "ds", "<Plug>(nvim-surround-delete)", {desc = "delete surrounding pair"})
vim.keymap.set("n", "cs", "<Plug>(nvim-surround-change)", {desc = "change surrounding pair"})
vim.keymap.set("n", "cS", "<Plug>(nvim-surround-change-line)", {desc = "change surrounding pair + put on new lines"})

-- visual
vim.keymap.set("x", "s", "<Plug>(nvim-surround-visual)", {desc = "surround visual selection"})
vim.keymap.set("x", "gS", "<Plug>(nvim-surround-visual-line)", {desc = "surround visual selection on new lines"})
