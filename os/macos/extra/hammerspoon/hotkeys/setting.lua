return function(setting)
    return {
        K = function() setting.step('+') end,
        J = function() setting.step('-') end,
        I = function() setting.set(setting.max) end,
        O = function() setting.set(setting.min) end,
        H = function() setting.setToStep(8) end,
    }
end
