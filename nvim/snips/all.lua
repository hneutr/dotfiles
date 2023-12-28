local ls = require('luasnip')

local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node

local seconds_in_a_day = 86400
local day_str_to_index = {Mon=0, Tue=1, Wed=2, Thu=3, Fri=4, Sat=5, Sun=6}

local function get_date_relative_to_today(args)
    args = _G.default_args(args, {days = 0, format = '%Y%m%d'})

    local today = vim.fn.localtime()
    local date = today + (args.days * seconds_in_a_day)

    return vim.fn.strftime(args.format, date)
end

local function get_day_of_the_week_relative_to_today(args)
    args = args or {}
    local date = get_date_relative_to_today({days=args.days, format="%c"})
    local day_of_the_week_string = date:sub(1, 3)
    return day_str_to_index[day_of_the_week_string]
end

ls.add_snippets("all", {
    -- today
    s("td", { f(function() return vim.fn.strftime("%Y%m%d") end) }),
    -- yesterday
    s("yd", { f(function() return get_date_relative_to_today({days=-1}) end) }),
    -- this week (monday to sunday)
    s("tw", {
        f(function()
            local today = vim.fn.strftime("%Y%m%d")
            local monday = nil
            local sunday = nil

            local day_offset = 0
            while not monday or not sunday do
                local day_of_the_week_after = get_day_of_the_week_relative_to_today({days=day_offset})

                if not monday then
                    if get_day_of_the_week_relative_to_today({days=-1 * day_offset}) == 0 then
                        monday = get_date_relative_to_today({days=-1 * day_offset})
                    end
                end

                if not sunday then
                    if get_day_of_the_week_relative_to_today({days=day_offset}) == 6 then
                        sunday = get_date_relative_to_today({days=day_offset})
                    end
                end

                day_offset = day_offset + 1
            end

            return monday .. "—" .. sunday
        end)
    }),
    s("now", {f(function() return os.date("%H:%M") end)}),
    s("00:00", {f(function() return os.date("%H:%M") end)}),
    s("TT", {f(function() return os.date("%H:%M") end)}),
})
