local prefix = "<C-Space>"
local modes = List({"n", "v", "i", "t"})

local mappings = Dict({
    l = "vspl|term",
    j = "spl|term",
    t = "tabnew|term",
    x = "x",
    X = "tabclose",
    ["!"] = "wincmd T",
})

for i in List.range(1, 9):iter() do
    mappings[tostring(i)] = string.format("tabn %s", tostring(i))
end

mappings:foreach(function(lhs, cmd)
    vim.keymap.set(
        modes,
        prefix .. lhs,
        function()
            vim.api.nvim_command(":" .. cmd)
        end,
        {silent = true}
    )
end)

-- vim.opt_global.tabline = "%N"
