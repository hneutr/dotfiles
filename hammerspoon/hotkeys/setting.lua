return function(setting)
    return {
        ['='] = function() setting.step('+') end,
        ['-'] = function() setting.step('-') end,
        F = function() setting.set(max) end,
        H = function() setting.setToStep(8) end,
        O = function() setting.set(min) end,
    }
end
