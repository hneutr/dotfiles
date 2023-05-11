local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

ls.add_snippets("lua", {
    -- tests
    s("before", {t({"before_each(function()", "    "}), i(1), t({"", "end)"})}),
    s("after", {t({"after_each(function()", "    "}), i(1), t({"", "end)"})}),
    s("describe", {t{'describe("'}, i(1), t{'", function()', "", 'end)'}}),
    s("it", {t{'it("'}, i(1), t{'", function()', "", 'end)'}}),
})
