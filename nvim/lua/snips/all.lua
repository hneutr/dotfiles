local ls = require('luasnip')

local s = ls.snippet
local f = ls.function_node

return {
    -- today
    s("td", {f(function() return vim.fn.strftime("%Y%m%d") end)}),
}
