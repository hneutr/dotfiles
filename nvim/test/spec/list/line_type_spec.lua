local util = require('util')
local m = require('list.line_type')

describe("*", function()
    before_each(function()
        m = require('list.line_type')
    end)

    describe("Line", function()
        describe(":new", function() 
            it("makes an empty Item", function()
                local item1 = m.Line({text = "1"})
                local item2 = m.Line({text = "2"})

                assert.equal(item1.text, '1')
                assert.equal(item2.text, '2')
            end)
        end)

        describe(":tostring: ", function()
            it("works", function()
                local x = m.Line({text = '    text'})
                assert.equal(tostring(x), "    text")
            end)
        end)

        describe(":merge: ", function()
            it("Line + Line", function()
                local one = m.Line({text = '1'})
                local two = m.Line({text = ' 2'})

                assert.equal(tostring(one), '1')

                one:merge(two)

                assert.equal(tostring(one), '1 2')
            end)

            it("Line + ListLine", function()
                local one = m.Line({text = '    1    '})
                local two = m.ListLine({text = '2', indent = '    '})

                assert.equal(tostring(one), '    1    ')
                assert.equal(tostring(two), '    - 2')

                one:merge(two)

                assert.equal(tostring(one), '    1 2')
            end)
        end)
    end)

    describe("ListLine", function()
        describe(":new", function() 
            it("makes an empty Item", function()
                local item1 = m.ListLine({text = "1"})
                local item2 = m.ListLine({text = "2"})

                assert.equal(item1.text, '1')
                assert.equal(item2.text, '2')
            end)
        end)

        describe(":tostring:", function()
            it("basic case", function()
                local item = m.ListLine({text = 'text', indent = '    '})

                assert.equal(tostring(item), "    - text")
            end)
        end)

        describe(".get_if_str_is_a:", function()
            it("-", function()
                assert.is_nil(m.ListLine.get_if_str_is_a("string", 0))
            end)

            it("+", function()
                assert.are.same(
                    m.ListLine.get_if_str_is_a("    - string", 0),
                    m.ListLine({text = "string", indent = "    ", line_number = 0})
                )
            end)
        end)
    end)


    describe("NumberedListLine", function()
        describe(":new", function() 
            it("makes an empty Item", function()
                assert.equal(m.NumberedListLine().number, 1)
            end)
        end)

        describe(":tostring", function()
            it("basic case", function()
                local item = m.NumberedListLine({text = 'text', indent = '    '})
                assert.equal(tostring(item), "    1. text")
            end)
        end)

        describe(".get_if_str_is_a", function()
            it("-", function()
                assert.is_nil(m.NumberedListLine.get_if_str_is_a("- string", 0))
            end)

            it("+", function()
                assert.are.same(
                    m.NumberedListLine.get_if_str_is_a("    10. string", 0),
                    m.NumberedListLine({number = 10, text = "string", indent = "    ", line_number = 0})
                )
            end)
        end)
    end)


    describe("get_sigil_line_class", function()
        local CustomListLineClass

        before_each(function()
            CustomListLineClass = m.get_sigil_line_class('?')
        end)

        describe(":tostring", function()
            it("works", function()
                local item = CustomListLineClass({text = 'text', indent = '    '})
                assert.equal(tostring(item), "    ? text")
            end)
        end)

        describe(".get_if_str_is_a", function()
            it("-", function()
                assert.is_nil(CustomListLineClass.get_if_str_is_a("- string", 0))
            end)

            it("+", function()
                assert.are.same(
                    CustomListLineClass.get_if_str_is_a("    ? string", 0),
                    CustomListLineClass({text = "string", indent = "    ", line_number = 0})
                )
            end)
        end)
    end)
end)
