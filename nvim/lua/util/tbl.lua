function table.concatenate(...)
    return table._concatenate({}, ...)
end

function table._concatenate(...)
    local args = {...}
    local t1 = {}
    
    if #args > 0 then
        t1 = table.remove(args, 1)
    end
    
    if #args > 0 then
        local t2 = table.remove(args, 1)
        for _, v in ipairs(t2) do 
            table.insert(t1, v)
        end
    end
    
    if #args > 0 then
        t1 = table._concatenate(t1, unpack(args))
    end
    
    return t1
end

function table.removekey(tbl, key)
    local element = tbl[key]
    tbl[key] = nil
    return element
end
