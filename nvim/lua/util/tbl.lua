function table.concatenate(tbl, other, ...)
    tbl = tbl or {}

    if other and #other > 0 then
        for _, v in ipairs(other) do 
            table.insert(tbl, v)
        end
    end

    if ... then
        tbl = table.concatenate(tbl, ...)
    end
        
    return tbl
end

function table.removekey(tbl, key)
    local element = tbl[key]
    tbl[key] = nil
    return element
end
