local stub = require('luassert.stub')
local Path = require('util.path')

local m = require('lex.move')

describe("move:", function()
   describe("infer:", function()
        before_each(function()
            stub(Path, "is_file")
            stub(Path, "is_dir")
        end)
        
        after_each(function()
            Path.is_file:revert()
            Path.is_dir:revert()
        end)
        
       describe("file_to_dir:", function()
           local f = m.infer.file_to_dir
           it("test false", function()
               Path.is_file.returns(false)
               eq(f("a/1.md", "a/b"), "a/b")
           end)

           it("file to same named dir: change", function()
               Path.is_file.returns(true)
               eq(f("a/b.md", "a/b"), "a/b/@.md")
           end)
        end)

       describe("file_into_dir:", function()
           local f = m.infer.file_into_dir
           it("dir to dir: no change", function()
               Path.is_file.returns(false)
               eq(f("a", "b"), "b")
           end)
       
           it("file to file: no change", function()
               Path.is_file.returns(true)
               eq(f("a/b.md", "a/c/b.md"), "a/c/b.md")
           end)
       
           it("file to dir: change", function()
               Path.is_file.returns(true)
               eq(f("a/b.md", "a/c"), "a/c/b.md")
           end)
        end)

       describe("dir_into_dir:", function()
           local f = m.infer.dir_into_dir
           it("dst exists: src → dst/src", function()
               Path.is_dir.returns(true)
               eq(f("a", "b"), "b/a")
           end)

           it("dst doesn't exist: src → dst", function()
               Path.is_dir.on_call_with('a').returns(true)
               Path.is_dir.on_call_with('b').returns(false)
               eq(f("a", "b"), "b")
           end)

           it("dst exists but is parent of src: no change", function()
               Path.is_dir.returns(true)
               eq(f("a/b", "a"), "a")
           end)
       end)
   end)
end)
