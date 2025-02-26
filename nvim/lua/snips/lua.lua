local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local ps = ls.parser.parse_snippet

return {
    ps("die", "os.exit()\n", {trim_empty = false}),
    ps("pd", "print(Dict($1))"),
    ps("dp", "Dict.print($1)"),
    ps("P", 'print(require("inspect")($1))'),
    -- tests
    ps("before", [[
        before_each(function()
            $1
        end)
    ]]),
    ps("after", [[
        after_each(function()
            $1
        end)
    ]]),
    ps("describe", [[
        describe("$1", function()
            $2
        end)
    ]]),
    ps("it", [[
        it("$1", function()
            $2
        end)
    ]]),
    ps("if", [[
        if $1 then
            $2
        end
    ]]),
    ps("elseif", "elseif $1 then"),
    ps("fn", [[
        function $1($2)
            $3
        end
    ]]),
}
