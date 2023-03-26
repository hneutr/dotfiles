local openApplicationChord = {"cmd", "ctrl"}
local keyToApplication = {
    a = "kitty",
    b = "bitwarden",
    c = "slack",
    d = "dictionary",
    g = "https://mail.google.com/mail/u/1/#inbox",
    i = "https://mail.google.com/mail/u/0/#inbox",
    m = "messages",
    p = "system settings",
    q = "spotify",
    r = "reminders",
    s = "chrome",
    t = "clock",
    w = "weather",
    z = "https://calendar.google.com/calendar/u/1/r",
}

function bindApplicationOpeners()
    for key, value in pairs(keyToApplication) do
        local opener = hs.application.open

        if string.find(value, "://") then
            opener =  hs.urlevent.openURL
        end

        hs.hotkey.bind(openApplicationChord, key, function() opener(value) end)
    end
end
bindApplicationOpeners()
