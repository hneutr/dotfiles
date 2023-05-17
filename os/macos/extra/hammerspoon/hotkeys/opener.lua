local keyToApplication = {
    a = "kitty",
    b = "bitwarden",
    c = "slack",
    d = "dictionary",
    g = "https://mail.google.com/mail/u/1/#inbox",
    i = "https://mail.google.com/mail/u/0/#inbox",
    e = "https://www.etymonline.com",
    m = "messages",
    p = "system settings",
    q = "spotify",
    r = "reminders",
    s = "safari",
    t = "clock",
    w = "weather",
    z = "https://calendar.google.com/calendar/u/1/r",
}

function getKeyToFunction()
    local keyToFunction = {}
    for key, value in pairs(keyToApplication) do
        local opener = hs.application.open

        if string.find(value, "://") then
            opener =  hs.urlevent.openURL
        end

        keyToFunction[key] = function() opener(value) end
    end

    return keyToFunction
end

return getKeyToFunction()
