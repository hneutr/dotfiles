return require('util.setting').create({
    get = function() return hs.audiodevice.defaultOutputDevice():volume() end,
    set = function(val) hs.audiodevice.defaultOutputDevice():setVolume(val) end,
})
