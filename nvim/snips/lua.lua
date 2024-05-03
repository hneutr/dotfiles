local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local ps = ls.parser.parse_snippet

ls.add_snippets("lua", {
    ps("die", "os.exit()\n", {trim_empty = false}),
    ps("pd", "print(Dict($1))"),
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
})
