local keyToApplication = {
    a = "kitty",
    b = "bitwarden",
    c = "slack",
    d = "dictionary",
    e = "https://www.etymonline.com",
    -- f
    g = "https://mail.google.com/mail/u/0/#inbox",
    -- h
    i = "https://mail.google.com/mail/u/1/#inbox",
    -- j
    -- k
    -- l
    m = "messages",
    -- n
    -- o
    p = "system settings",
    q = "spotify",
    r = "reminders",
    s = "safari",
    t = "clock",
    -- u
    v = "Cisco AnyConnect Secure Mobility Client",
    w = "weather",
    -- x
    -- y
    z = "https://calendar.google.com/calendar/u/0/r",
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
