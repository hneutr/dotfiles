local mappings = Dict({
    l = "vspl|term",
    j = "spl|term",
    c = "tabnew|term",
    x = "x",
    X = "tabclose",
    ["!"] = "wincmd T",
})

for i in List.range(1, 9):iter() do
    mappings[tostring(i)] = string.format("tabn %s", tostring(i))
end

mappings:transformv(function(cmd)
    return {function() vim.api.nvim_command(":" .. cmd) end, {silent = true}}
end)

return mappings
