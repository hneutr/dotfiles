local mock = require('luassert.mock')
local stub = require('luassert.stub')
local m = require('util.path')
require('util')


describe("Path:", function()
   local pwd

   describe("init:", function()
       it("works", function()
           local one = m("1.md")
           local two = m("2.md")
           assert.equal(one.path, "1.md")
           assert.equal(two.path, "2.md")
       end)
   end)

   describe("eq:", function()
       it("path ~= path", function()
           assert.is_true(m("1.md") ~= m("2.md"))
       end)
       
       it("path == path", function()
           assert.is_true(m("1.md") == m("1.md"))
       end)
       
       it("path ~= string", function()
           assert.is_true(m("1.md") ~= "2.md")
       end)
       --
       -- it("path == string", function()
       --     assert.is_true(m("1.md") == "1.md")
       -- end)
   end)

   describe("__tostring:", function()
       it("works", function()
           assert.equal(tostring(m("1.md")), "1.md")
       end)
   end)

   describe("suffix:", function()
       it("doesn't have suffix", function()
           local p = m("dir")
           assert.equal(p:suffix(), "")
           assert.equal(m.suffix(p), "")
       end)

       it("has suffix", function()
           local p = m("dir/file.md")
           assert.equal(p:suffix(), "md")
           assert.equal(m.suffix(p), "md")
       end)
   end)

   describe("name:", function()
       it("works", function()
           local p = m("dir/file.md")
           assert.equal(p:name(), "file.md")
           assert.equal(m.name(p), "file.md")
       end)
   end)

   describe("stem:", function()
       it("works", function()
           local p = m("dir/file.md")
           assert.equal(p:stem(), "file")
           assert.equal(m.stem(p), "file")
       end)
   end)

   describe("is_file:", function()
       local filereadable = vim.fn.filereadable

       after_each(function()
           vim.fn.filereadable = filereadable
       end)

       it("=", function()
           vim.fn.filereadable = function() return 1 end
           local p = m("dir/file.md")
           assert.equal(p:is_file(p), true)
           assert.equal(m.is_file(p), true)
       end)

       it("!", function()
           vim.fn.filereadable = function() return 0 end
           local p = m("dir")
           assert.equal(p:is_file(p), false)
           assert.equal(m.is_file(p), false)
       end)
   end)

   describe("is_dir:", function()
       local isdirectory = vim.fn.isdirectory

       after_each(function()
           vim.fn.isdirectory = isdirectory
       end)

       it("=", function()
           vim.fn.isdirectory = function() return 1 end
           local p = m("dir")
           assert.equal(p:is_dir(p), true)
           assert.equal(m.is_dir(p), true)
       end)

       it("!", function()
           vim.fn.isdirectory = function() return 0 end
           local p = m("dir/file.md")
           assert.equal(p:is_file(p), false)
           assert.equal(m.is_file(p), false)
       end)
   end)

   describe("is:", function()
       it("=", function()
           local p = m("dir")
           assert.equal(p:is(m), true)
           assert.equal(m.is(p, m), true)
       end)

       it("!", function()
           local s = "string"
           assert.equal(m.is(s, m), false)
       end)
   end)

   describe("is_path:", function()
       it("=", function()
           local p = m("dir")
           assert.equal(p:is_path(), true)
           assert.equal(m.is_path(p), true)
       end)

       it("!", function()
           local s = "string"
           assert.equal(m.is_path(s), false)
       end)
   end)

   describe("join:", function()
       it("clean", function()
           local left = "/dir"
           local right = "subdir/file.md"
           local joined = "/dir/subdir/file.md"

           assert.are.same(m.join(left, right), joined)
           assert.are.same(m(left):join(right), m(joined))
           assert.are.same(m(left):join(m(right)), m(joined))
       end)

       it("trailing/starting /", function()
           local left = "/dir/"
           local right = "/subdir/file.md"
           local joined = "/dir/subdir/file.md"

           assert.are.same(m.join(left, right), joined)
       end)

       it("empty left", function()
           local left = ""
           local right = "/dir/file.md"
           local joined = "/dir/file.md"

           assert.are.same(m.join(left, right), joined)
       end)

       it("empty right", function()
           local left = "/dir"
           local right = nil
           local joined = "/dir"

           assert.are.same(m.join(left, right), joined)
       end)

       it("> 2 args", function()
           assert.are.same(m.join("/dir", "subdir", "file"), "/dir/subdir/file")
       end)
   end)

   describe("resolve:", function()
       local pwd = vim.env.PWD
       before_each(function()
           vim.env.PWD = "/pwd/"
       end)

       after_each(function()
           vim.env.PWD = pwd
       end)
       
       it("absolute", function()
           local p = "/pwd/file.md"
           assert.are.same(m.resolve(p), p)
           assert.are.same(m(p):resolve(), m(p))
       end)
       
       it(".", function()
           local p = "."
           local resolved = "/pwd/"
           assert.are.same(m.resolve(p), resolved)
           assert.are.same(m(p):resolve(), m(resolved))
       end)

       it("relative", function()
           local p = "dir/file.md"
           local resolved = "/pwd/dir/file.md"
           assert.are.same(m.resolve(p), resolved)
           assert.are.same(m(p):resolve(), m(resolved))
       end)
   end)

   describe("remove_from_start:", function()
       it("does start", function()
           local p = "/dir/file.md"
           local to_remove = "/dir"
           local result = "file.md"
           assert.are.same(m.remove_from_start(p, to_remove), result)
           assert.are.same(m(p):remove_from_start(to_remove), m(result))
       end)
   end)

   describe("parent:", function()
       it("has", function()
           local p = "/dir/file.md"
           local parent = "/dir"
           assert.are.same(m.parent(p), parent)
           assert.are.same(m(p):parent(), m(parent))
       end)
   end)
end)
