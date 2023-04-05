local min = 0
local max = 100
local nSteps = 16
local increment = math.round(max / nSteps)

function incrementInDirection(val, increment, direction)
    local multiplier

    if direction == '+' then
        multiplier = 1
    elseif direction == '-' then
        multiplier = -1
    end

    return val + (increment * multiplier)
end

local function _set(set)
    return function(val) set(boundNumber({val = math.round(val), max = max, min = min})) end
end

local function _step(get, set)
    return function(direction) set(incrementInDirection(get(), increment, direction)) end
end

local function create(args)
    local get = args.get
    local set = _set(args.set)
    local step = _step(get, set)
    return {
        min = min,
        max = max,
        increment = increment,
        steps = nSteps,
        set = set,
        get = get,
        step = step,
        setToStep = function(step) set(increment * step) end
    }
end

return {
    max = max,
    min = min,
    increment = increment,
    create = create,
}
