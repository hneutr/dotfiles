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
vim.keymap.set("n", "sa", "<Plug>(nvim-surround-normal)", {desc = "Add a surrounding pair"})
vim.keymap.set("n", "sd", "<Plug>(nvim-surround-delete)", {desc = "Delete a surrounding pair"})
vim.keymap.set("n", "sr", "<Plug>(nvim-surround-change)", {desc = "Change a surrounding pair"})
