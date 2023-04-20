local util = require('util')
local line_type = require('list.line_type')
local m = require('list')

describe("Buffer", function()
    local buffer
    local actual, expected

    before_each(function()
        m = require('list')
        vim.b.list_types = nil
        buffer = m.Buffer()
    end)

    describe(":parse_line", function()
        it("basic line", function()
            assert.are.same(
                buffer:parse_line("text", 1),
                line_type.Line({text="text", line_number = 1})
            )
        end)

        it("list line", function()
            assert.are.same(
                buffer:parse_line("- text", 1),
                line_type.ListLine.get_class("bullet")({text="text", line_number = 1})
            )
        end)

        it("numbered list line", function()
            assert.are.same(
                buffer:parse_line("10. text", 1),
                line_type.NumberedListLine({text="text", number = 10, line_number = 1})
            )
        end)

        it("handles vim.b.list_types", function()
            actual = buffer:parse_line("? text", 1)
            expected = line_type.Line({text="? text", line_number = 1})
        
            assert.are.same(actual, expected)
        
            vim.b.list_types = {"question"}
        
            buffer = m.Buffer()
        
            actual = buffer:parse_line("? text", 1)
            expected = line_type.ListLine.get_class("question")({text="text", line_number = 1})
        
            assert.are.same(actual, expected)
        end)
    end)

    describe("join_lines", function()
        local cursor_start_pos
    
        local set_buf_lines = function(lines)
            vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
        end
    
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
