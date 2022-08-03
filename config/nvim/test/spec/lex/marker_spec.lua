local mock = require('luassert.mock')
local stub = require('luassert.stub')
local m = require('lex.marker')
local config = require'lex.config'


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

   describe(".expand: ", function()
      it("path", function()
         assert.equal("root/a/b", m.path.expand("a/b"))
      end)

      it("path starting with ./", function()
         assert.equal("root/a/b", m.path.expand("./a/b"))
      end)
   end)
end)

describe("link", function()
   describe(".get:", function() 
      it("makes link", function()
         assert.equals("[a](b)", m.link.get("a", "b"))
      end)
   end)

   describe(".parse:", function() 
      it("plain link", function()
         local a, b = m.link.parse("[a](b)")
         assert.are.same({"a", "b"}, {a, b})
      end)
   end)
end)

describe("marker", function()
   before_each(function()
      line_utils = require('lines')
      line_utils.cursor.get = function() return "[testing]()" end

      local lines = {"nonmarker", "", "[other marker]()", "[marker]()", "[another marker]()"}

      line_utils.get = function() return lines end
   end)

   describe(".is", function() 
      it("'#' started marker", function()
         assert.is.truthy(m.marker.is("# [a]()"))
      end)

      it("'>' start marker", function()
         assert.is.truthy(m.marker.is("> [a]()"))
      end)

      it("no leadup marker", function()
         assert.is.truthy(m.marker.is("[a]()"))
      end)

      it("bad prefix", function()
         assert.is.not_truthy(m.marker.is(" [a]()"))
      end)

      it("bad suffix", function()
         assert.is.not_truthy(m.marker.is("[a]() "))
      end)

      it("has location", function()
         assert.is.not_truthy(m.marker.is("[a](a) "))
      end)

      it("lacks label", function()
         assert.is.not_truthy(m.marker.is("[]() "))
      end)

      it("gets from current line without arg", function()
         assert.is.truthy(m.marker.is())
      end)
   end)

   describe(".parse", function() 
      it("basic", function()
            assert.equal("a 123 - b c", m.marker.parse("[a 123 - b c]()"))
      end)

      it("from line", function()
         line_utils.cursor.get = function() return "[testing]()" end
         assert.equal("testing", m.marker.parse())
      end)
   end)

   describe('.find', function()
      local nvim_win_set_cursor
      local cmd

      before_each(function()
         nvim_win_set_cursor = stub(vim.api, "nvim_win_set_cursor")
         cmd = stub(vim, "cmd")
      end)

      after_each(function()
         nvim_win_set_cursor:revert()
         cmd:revert()
      end)

      it("finds", function()
         m.marker.find("marker")

         assert.stub(nvim_win_set_cursor).was_called_with(0, {4, 0})
         assert.stub(cmd).was_called_with("normal zz")
      end)

      it("finds different marker", function()
         m.marker.find("another marker")

         assert.stub(nvim_win_set_cursor).was_called_with(0, {5, 0})
         assert.stub(cmd).was_called_with("normal zz")
      end)

      it("doesn't find", function()
         m.marker.find("fake marker")

         assert.stub(nvim_win_set_cursor).was_not_called()
         assert.stub(cmd).was_not_called()
      end)
   end)
end)

describe("location", function()
   local get_config = config.get

   before_each(function()
      config.get = function() return {root = 'root'} end
	end)

   after_each(function()
      config.get = get_config
	end)

   describe(".get", function()
      it("path", function()
         assert.equal("a/b", m.location.get("root/a/b"))
      end)

      it("path and text", function()
         assert.equal("a/b:test", m.location.get("root/a/b", "test"))
      end)

      it("path and text and flags", function()
         assert.equal("a/b:test?=abc", m.location.get("root/a/b", "test", {"a", "b", "c"}))
      end)
      it("path and flags", function()
         assert.equal("a/b?=abc", m.location.get("root/a/b", "", {"a", "b", "c"}))
      end)
   end)
end)
