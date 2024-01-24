vim.cmd([[colorscheme catppuccin]])

require("catppuccin").setup({
    flavor = "mocha",
    transparent_background = false,
    integrations = {
        cmp = true,
        gitsigns = true,
        nvimtree = true,
        treesitter = true,
        notify = false,
        mini = false,
    }
})
