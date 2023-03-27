hs.hotkey.bindAll = function(mods, keyToFunction)
    for key, fn in pairs(keyToFunction) do
        hs.hotkey.bind(mods, key, fn)
    end
end

math.round = function(number)
    local floor = math.floor(number)
    local floorDiff = number - floor
    local ceil = math.ceil(number)
    local ceilDiff = ceil - number

    if floorDiff <= ceilDiff then
        return floor
    end
    
    return ceil
end

function boundNumber(args)
    args = args or {}
    val = args.val or 0
    min = args.min or 0
    max = args.max or 0

    val = math.max(min, val)
    val = math.min(max, val)

    return val
end
