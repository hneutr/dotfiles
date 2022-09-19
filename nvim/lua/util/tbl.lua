function table.removekey(tbl, key)
    local element = tbl[key]
    tbl[key] = nil
    return element
end
