local ls = require("luasnip")
local ps = ls.parser.parse_snippet

return {
    ps("print", "console.log(JSON.stringify($1))"),
}
