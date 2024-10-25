return {
    compile_path = tostring(Path.home / ".cache/catppuccin"),
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
}
