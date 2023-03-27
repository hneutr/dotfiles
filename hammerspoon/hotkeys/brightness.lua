local settings = require('util.setting.brightness')
local hotkeys = require('hotkeys.setting')(settings)

hotkeys.W = function() settings.setToStep(settings.steps - 2) end

return hotkeys
