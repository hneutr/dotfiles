local mock = require('luassert.mock')
local stub = require('luassert.stub')
local m = require('lex.list')


describe("Item", function()
   before_each(function()
      m = require('lex.list')
   end)

   describe(":new", function() 
      it("makes an empty Item", function()
         local item = m.Item()

         assert.equal(item.sigil, '-')
         assert.equal(item.text, '')
         assert.equal(item.indent, 0)
      end)

      it("makes an non-empty Item", function()
         local item = m.Item { sigil = '?', text = 'hey' }

         assert.equal(item.sigil, '?')
         assert.equal(item.text, 'hey')
      end)

      it("checks that items have different namespaces", function()
         local item1 = m.Item { text = "1" }
         local item2 = m.Item { text = "2" }

         assert.equal(item1.text, '1')
         assert.equal(item2.text, '2')
      end)
   end)

   describe(":str", function()
      it("basic case", function()
         local item = m.Item { text = 'text' }

         assert.equal(item:str(), "- text")
      end)

      it("indent", function()
         local item = m.Item { text = 'text', indent = 8 }

         assert.equal(item:str(), "        - text")
      end)
   end)

   describe(".str_is_a", function()
      it("finds base case", function()
         assert.equal(m.Item.str_is_a("- hunter"), true)
      end)

      it("doesn't find", function()
         assert.equal(m.Item.str_is_a("hunter"), false)
      end)

      it("finds indented", function()
         assert.equal(m.Item.str_is_a("  - hunter"), true)
      end)

      it("doesn't find indented", function()
         assert.equal(m.Item.str_is_a("  hunter"), false)
      end)

      it("doesn't find empty string", function()
         assert.equal(m.Item.str_is_a(""), false)
      end)
      it("doesn't find '-text'", function()
         assert.equal(m.Item.str_is_a("-text"), false)
      end)
   end)

   describe(".from_str", function() 
      it("base case", function()
         local expected = m.Item({sigil = "?", text = "what's up", indent = 4})
         local actual = m.Item.from_str("    ? what's up")

         assert.equal(actual.sigil, expected.sigil)
         assert.equal(actual.text, expected.text)
         assert.equal(actual.indent, expected.indent)
      end)

      it("wide sigil", function()
         local expected = m.Item({sigil = "✓", text = "what's up", indent = 4})
         local actual = m.Item.from_str("    ✓ what's up")

         assert.equal(actual.sigil, expected.sigil)
         assert.equal(actual.text, expected.text)
         assert.equal(actual.indent, expected.indent)
      end)
   end)

   describe(".is_a", function() 
      it("base case", function()
         assert.equal(Item.is_a(m.Item(), Item), true)
      end)

      it("negative case", function()
         assert.equal(Item.is_a("hello", Item), false)
      end)
   end)
end)

describe("toggle sigil", function()
   before_each(function()
      m = require('lex.list')
      line_utils = require'lines'
   end)

   describe("Lines", function()
      describe(".get", function()
         it("gets Items and NonItems", function()
            line_utils.selection.get = function() return { "nonitem", "- hello", "    ? test" } end

            local e_1 = m.NonItem{text = "nonitem"}
            local e_2 = m.Item{text = "hello", sigil = '-'}
            local e_3 = m.Item{text = "test", sigil = '?'}

            local actual = m.lines.get()
            local a_1 = actual[1]
            local a_2 = actual[2]
            local a_3 = actual[3]

            assert.equal(m.NonItem.is_a(a_1, m.NonItem), true)
            assert.equal(m.Item.is_a(a_2, m.Item), true)
            assert.equal(m.Item.is_a(a_3, m.Item), true)

            assert.equal(a_1.text, "nonitem")
            assert.equal(a_2.text, "hello")
            assert.equal(a_3.text, "test")
            assert.equal(a_3.sigil, '?')
         end)
      end)

      describe(".set", function()
         local set
         local get

         before_each(function()
            set = line_utils.selection.set
            line_utils.selection.set = function(args) return args end
            get = line_utils.selection.get
            line_utils.selection.get = function() return { "nonitem", "- hello", "    ? test", "? other" } end
         end)

         after_each(function()
            line_utils.selection.set = set
            line_utils.selection.get = get
         end)

         it("works without a sigil", function()
            local actual = m.lines.set({ lines = m.lines.get() })

            assert.equal(actual.replacement[1], "nonitem")
            assert.equal(actual.replacement[2], "- hello")
            assert.equal(actual.replacement[3], "    ? test")
            assert.equal(actual.replacement[4], "? other")
         end)

         it("works with a sigil", function()
            local actual = m.lines.set({ lines = m.lines.get(), sigil = '✓' })

            assert.equal(actual.replacement[1], "nonitem")
            assert.equal(actual.replacement[2], "✓ hello")
            assert.equal(actual.replacement[3], "    ✓ test")
            assert.equal(actual.replacement[4], "✓ other")
         end)
      end)
   end)

   describe("get_min_indent_sigil", function()
      it("returns nil when no list items present", function()
         line_utils.selection.get = function() return { "nonitem", "hello", "    test", "other" } end
         local lines = m.lines.get()

         assert.equal(m.get_min_indent_sigil(lines), nil)
      end)
      it("finds the appropriate min sigil", function()
         line_utils.selection.get = function() return { "nonitem", "- hello", "    ? test", "? other" } end
         local lines = m.lines.get()

         assert.equal(m.get_min_indent_sigil(lines), "-")
      end)

      it("finds the appropriate min sigil (2)", function()
         line_utils.selection.get = function() return { "nonitem", "    ? test", "✓ hello", "? other" } end
         local lines = m.lines.get()

         assert.equal(m.get_min_indent_sigil(lines), "✓")
      end)
   end)

   describe("get_new_sigil", function()
      it("returns nil without a min_sigil found", function()
         m.get_min_indent_sigil = function() return nil end
         assert.equal(m.get_new_sigil(lines, '?'), nil)
      end)

      it("returns default when toggle sigil found", function()
         m.get_min_indent_sigil = function() return '?' end
         assert.equal(m.get_new_sigil(lines, '?'), '-')
      end)

      it("returns toggle sigil when non-toggle sigil found", function()
         m.get_min_indent_sigil = function() return '-' end
         assert.equal(m.get_new_sigil(lines, '?'), '?')
      end)
   end)
end)
