local stub = require('luassert.stub')
local Path = require('util.path')

local m = require('lex.move')

local eq = assert.are.same

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
           it("test false", function()
               Path.is_file.returns(false)
               eq(m.infer.file_to_dir("dir/file.md", "dir/subdir"), "dir/subdir")
           end)

           it("file to same named dir: change", function()
               Path.is_file.returns(true)
               eq(m.infer.file_to_dir("dir/subdir.md", "dir/subdir"), "dir/subdir/@.md")
           end)
        end)

       describe("file_into_dir:", function()
           it("dir to dir: no change", function()
               Path.is_file.returns(false)
               eq(m.infer.file_into_dir("dir", "other_dir"), "other_dir")
           end)
       
           it("file to file: no change", function()
               Path.is_file.returns(true)
               eq(m.infer.file_into_dir("dir/test.md", "dir/subdir/test.md"), "dir/subdir/test.md")
           end)
       
           it("file to dir: change", function()
               Path.is_file.returns(true)
               eq(m.infer.file_into_dir("dir/test.md", "dir/subdir"), "dir/subdir/test.md")
           end)
        end)

       describe("dir_into_dir:", function()
           it("dst exists: src → dst/src", function()
               Path.is_dir.returns(true)
               eq(m.infer.dir_into_dir("subdir", "dir"), "dir/subdir")
           end)

           it("dst doesn't exist: src → dst", function()
               Path.is_dir.on_call_with('subdir').returns(true)
               Path.is_dir.on_call_with('dir').returns(false)
               eq(m.infer.dir_into_dir("subdir", "dir"), "dir")
           end)

           it("dst exists but is parent of src: no change", function()
               Path.is_dir.returns(true)
               eq(m.infer.dir_into_dir("dir/subdir", "dir"), "dir")
           end)
       end)
   end)
end)
