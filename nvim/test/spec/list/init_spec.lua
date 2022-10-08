local mock = require('luassert.mock')
local stub = require('luassert.stub')
local util = require('util')
local m = require('list')
require("util")

describe("Line", function()
   before_each(function()
      m = require('list')
   end)

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
   before_each(function()
      m = require('list')
   end)

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
   before_each(function()
      m = require('list')
   end)

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

    describe("get_list_line_class_with_sigil", function()
        local CustomListLineClass

        before_each(function()
            CustomListLineClass = m.ListLine.get_list_line_class_with_sigil('?')
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


describe("Buffer", function()
    local buffer

    before_each(function()
        m = require('list')
        buffer = m.Buffer()
    end)

    describe(":parse_line", function()
        it("basic line", function()
            assert.are.same(
                buffer:parse_line("text", 1),
                m.Line({text="text", line_number = 1})
            )
        end)

        it("list line", function()
            assert.are.same(
                buffer:parse_line("- text", 1),
                m.ListLine({text="text", line_number = 1})
            )
        end)

        it("numbered list line", function()
            assert.are.same(
                buffer:parse_line("10. text", 1),
                m.NumberedListLine({text="text", number = 10, line_number = 1})
            )
        end)
    end)

    describe("join_lines", function()
        local cursor_start_pos

        local set_buf_lines = function(lines)
            vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
        end

        -- local get_buf_lines = function()
        --     return vim.api.nvim_buf_get_lines(0, 0, vim.fn.line('$'), false)
        -- end
        local assert_lines_match_expectation = function(expected)
            assert.are.same(
                vim.api.nvim_buf_get_lines(0, 0, vim.fn.line('$'), false),
                expected
            )
        end


        before_each(function()
            local _buf = vim.api.nvim_create_buf(false, true)
            vim.api.nvim_command("buffer " .. _buf)

            cursor_start_pos = vim.api.nvim_win_get_cursor(0)
        end)

        after_each(function()
            assert.are.same(cursor_start_pos, vim.api.nvim_win_get_cursor(0))
        end)

        it("no lines", function()
            buffer:join_lines()
            assert_lines_match_expectation({""})
        end)

        it("single line", function()
            set_buf_lines({"single line"})
            buffer:join_lines()
            assert_lines_match_expectation({"single line"})
        end)

        it("l1 + l2 → 11 l2", function()
            set_buf_lines({"l1", "l2"})
            buffer:join_lines()
            assert_lines_match_expectation({"l1 l2"})
        end)

        it("pre + l1 + l2 + post → pre + l1 l2 + post", function()
            set_buf_lines({"pre", "l1", "l2", "post"})
            cursor_start_pos = {2, 1}
            vim.api.nvim_win_set_cursor(0, cursor_start_pos)

            buffer:join_lines()
            assert_lines_match_expectation({"pre", "l1 l2", "post"})
        end)
    end)
end)


-- describe("renumber_list", function()
-- end)
