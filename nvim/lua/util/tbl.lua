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

function table.remove(tbl, key)
    local element = tbl[key]
    tbl[key] = nil
    return element
end


function table.default(tbl, other)
    tbl = tbl or {}
    for k, v in pairs(other) do
        if tbl[k] == nil then
            tbl[k] = other[k]
        elseif type(v) == 'table' then
            tbl[k] = table.default(tbl[k], v)
        end
    end

    return tbl
end

