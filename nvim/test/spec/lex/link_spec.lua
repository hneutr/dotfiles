local mock = require('luassert.mock')
local stub = require('luassert.stub')
local m = require('lex.link')
local config = require'lex.config'
require'util'

describe("path", function()
   local get_config = config.get

   before_each(function()
      config.get = function() return {root = 'root'} end
	end)

   after_each(function()
      config.get = get_config
	end)

  describe(".shorten:", function() 
     it("path", function()
        assert.equal("a/b", m.path.shorten("root/a/b"))
     end)
  end)

   describe(".expand:", function()
      it("basic case", function()
         assert.equal("root/a/b", m.path.expand("a/b"))
      end)

      it("path starting with ./", function()
         assert.equal("root/a/b", m.path.expand("./a/b"))
      end)
   end)
end)

describe("Link", function()
   describe("str()", function() 
      it("makes link", function()
         local one = m.Link{ label = 'a', location = 'b' }
         local two = m.Link{ label = 'c', location = 'd' }
         assert.equals("[a](b)", one:str())
         assert.equals("[c](d)", two:str())
      end)
   end)

   describe(".from_str:", function() 
      it("plain", function()
         local actual = m.Link.from_str("[a](b)")
         local expected = m.Link{ label = 'a', location = 'b', before = '', after = '' }
         assert.are.same(actual, expected)
      end)

      it("empty", function()
         local actual = m.Link.from_str("[]()")
         local expected = m.Link{ label = '', location = '', before = '', after = '' }
         assert.are.same(actual, expected)
      end)

      it("+ before and after", function()
         local actual = m.Link.from_str("before [a](b) after")
         local expected = m.Link{ label = 'a', location = 'b', before = 'before ', after = ' after' }

         assert.are.same(actual, expected)
      end)

      it("another link after", function()
         local actual = m.Link.from_str("before [a](b) [c](d)")
         local expected = m.Link{ label = 'a', location = 'b', before = 'before ', after = ' [c](d)' }

         assert.are.same(actual, expected)
      end)
   end)
   describe(".str_is_a:", function() 
      it("negative case", function()
         assert.is_false(m.Link.str_is_a("not a link"))
      end)
   end)

   describe("get_nearest", function()
      local function set_up(line, cursor_col)
         local buf = vim.api.nvim_create_buf(false, true)
         vim.api.nvim_command("buffer " .. buf)
         vim.api.nvim_buf_set_lines(0, 0, -1, true, { line })
         vim.api.nvim_win_set_cursor(0, {1, cursor_col})
      end

      it("1 link: cursor in link", function()
          local line = "a [b](c) d"
          set_up(line, string.find(line, 'b'))
          assert.equal(m.Link.get_nearest():str(), "[b](c)")
      end)

      it("1 link: cursor before link", function()
          local line = "a [b](c) d"
          set_up(line, string.find(line, 'a'))
          assert.equal(m.Link.get_nearest():str(), "[b](c)")
      end)

      it("1 link: cursor after link", function()
          local line = "a [b](c) d"
          set_up(line, string.find(line, 'd'))
          assert.equal(m.Link.get_nearest():str(), "[b](c)")
      end)

      it("2 links: cursor before link 1", function()
          local line = "a [b](c) d [e](f) g"
          set_up(line, string.find(line, 'a'))
          assert.equal(m.Link.get_nearest():str(), "[b](c)")
      end)

      it("2 links: cursor in link 1", function()
          local line = "a [b](c) d [e](f) g"
          set_up(line, string.find(line, 'b'))
          assert.equal(m.Link.get_nearest():str(), "[b](c)")
      end)

      it("2 links: cursor in between links", function()
          local line = "a [b](c) d [e](f) g"
          set_up(line, string.find(line, 'd'))
          assert.equal(m.Link.get_nearest():str(), "[b](c)")
      end)

      it("2 links: cursor in link 2", function()
          local line = "a [b](c) d [e](f) g"
          set_up(line, string.find(line, 'e'))
          assert.equal(m.Link.get_nearest():str(), "[e](f)")
      end)

      it("2 links: cursor in after link 2", function()
          local line = "a [b](c) d [e](f) g"
          set_up(line, string.find(line, 'g'))
          assert.equal(m.Link.get_nearest():str(), "[e](f)")
      end)

      it("3 links: cursor between link 2 and 3", function()
          local line = "a [b](c) d [e](f) g [h](i) j"
          set_up(line, string.find(line, 'g'))
          assert.equal(m.Link.get_nearest():str(), "[e](f)")
      end)
   end)
end)


describe("Mark", function()
   describe("str()", function() 
      it("makes Mark", function()
         local one = m.Mark{ text = 'a' }
         local two = m.Mark{ text = 'b' }
         assert.equals("[a]()", one:str())
         assert.equals("[b]()", two:str())
      end)
   end)

   describe("str_is_a()", function() 
      it("base case: accept", function()
         assert.is_true(m.Mark.str_is_a("[a]()"))
      end)

      it("nonlink: reject", function()
         assert.is_false(m.Mark.str_is_a("test"))
      end)

      it("link with location: reject", function()
         assert.is_false(m.Mark.str_is_a("[a](b)"))
      end)
   end)

   describe("rg_str_is_a()", function() 
      it("base case: accept", function()
         assert.is_true(m.Mark.rg_str_is_a("/path/to/something.md:[a]()"))
      end)

      it("nonlink: reject", function()
         assert.is_false(m.Mark.rg_str_is_a("/path/to/something.md: test"))
      end)
   end)

   describe("from_str()", function() 
      it("basic", function()
         local actual = m.Mark.from_str("[string]()")
         local expected = m.Mark{ text = 'string' }

         assert.are.same(actual, expected)
      end)

      it("before and after", function()
         local actual = m.Mark.from_str("# [string]() after")
         local expected = m.Mark{ text = 'string', before = '# ', after = ' after' }

         assert.are.same(actual, expected)
      end)
   end)

   describe("goto", function() 
      local lines = {
         "line 1",
         "line 2",
         "[marker 1]()",
         "[reference 1](abc)",
         "",
         "[marker 2]()",
         "[reference 2](marker 3)",
      }

      local nvim_win_set_cursor

      before_each(function()
         local buf = vim.api.nvim_create_buf(false, true)
         vim.api.nvim_command("buffer " .. buf)
         vim.api.nvim_buf_set_lines(0, 0, -1, true, lines)

         vim.api.nvim_win_set_cursor(0, {4, 0})

         nvim_win_set_cursor = stub(vim.api, "nvim_win_set_cursor")
      end)

      after_each(function()
         nvim_win_set_cursor:revert()
      end)

      it("doesn't find the mark, doesn't move the cursor", function()
         m.Mark.goto("marker 3")
         assert.stub(nvim_win_set_cursor).was_not_called()
      end)

      it("doesn't find the mark, doesn't move the cursor", function()
         m.Mark.goto("marker 1")
         assert.stub(nvim_win_set_cursor).was_called_with(0, {3, 0})
      end)
   end)
end)

describe("Location", function()
   local get_config = config.get

   before_each(function()
      config.get = function() return {root = 'root'} end
	 end)

   after_each(function()
      config.get = get_config
   end)

   describe("str()", function() 
      local expand = vim.fn.expand

      before_each(function()
         vim.fn.expand = function() return "root/test_path.md" end
      end)

      after_each(function()
         vim.fn.expand = expand
      end)

      it("makes location", function()
         local one = m.Location{ path = 'a', text = 'b' }
         local two = m.Location{ path = 'c' }
         local three = m.Location{ text = 'd'}
         assert.equals("a:b", one:str())
         assert.equals("c", two:str())
         assert.equals("test_path.md:d", three:str())
      end)
   end)

   describe("from_str()", function() 
      it("path and str", function()
         local actual = m.Location.from_str("test.md:label")
         local expected = m.Location{ path = 'root/test.md', text = 'label' }

         assert.are.same(actual, expected)
      end)

      it("path only", function()
         local actual = m.Location.from_str("test.md")
         local expected = m.Location{ path = 'root/test.md' }

         assert.are.same(actual, expected)
      end)
   end)
end)

describe("Flag", function()
    describe("str()", function() 
        it("makes an empty Flag region", function()
            assert.equals("[]()", tostring(m.Flag()))
        end)

        it("makes a Flag region", function()
            assert.equals("[](?*)", tostring(m.Flag({question = true, brainstorm = true})))
        end)
    end)

    describe("str_is_a", function()
        it("rejects text", function()
            assert.is_false(m.Flag.str_is_a("abcde"))
        end)

        it("rejects a link with a body", function()
            assert.is_false(m.Flag.str_is_a("yello [hunter](?) hi"))
        end)

        it("rejects a link with bad location content", function()
            assert.is_false(m.Flag.str_is_a("[](steve)"))
        end)

        it("accepts a link with good location content", function()
            assert.is_true(m.Flag.str_is_a("[](?)"))
        end)

        it("kitchen sink acceptance", function()
            assert.is_true(m.Flag.str_is_a("before [](?*) after"))
        end)
    end)

    describe("from_str", function()
        it("correct flags when present", function()
            local expected = m.Flag({before = 'a ', after = ' z', question = true})
            assert.are.same(expected, m.Flag.from_str("a [](?) z"))
        end)

        it("multiple flags when flags present", function()
            local expected = m.Flag({before = 'a ', after = ' z', question = true, brainstorm = true})
            assert.are.same(expected, m.Flag.from_str("a [](?*) z"))
        end)
    end)
end)

