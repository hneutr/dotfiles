local get_selection = require("nvim-surround.config").get_selection

require("nvim-surround").setup({
    keymaps = {
        visual = "s",
        visual_line = "S",
    },
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
