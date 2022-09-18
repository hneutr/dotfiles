local m = require('lex.move')

describe("move:", function()
   describe("infer:", function()
       local path
   
       before_each(function()
           path = require('util.path')
       end)
   
       describe("file_to_dir:", function()
           it("file to other dir: no change", function()
               path.is_file = function() return true end
               assert.equal(m.infer.file_to_dir("dir/file.md", "dir/subdir"), "dir/subdir")
           end)
   
           it("file to same named dir: change", function()
               path.is_file = function() return true end
               assert.equal(m.infer.file_to_dir("dir/subdir.md", "dir/subdir"), "dir/subdir/@.md")
           end)
       end)
   
       describe("file_into_dir:", function()
           it("dir to dir: no change", function()
               path.is_file = function() return false end
               assert.equal(m.infer.file_into_dir("dir", "other_dir"), "other_dir")
           end)
         
           it("file to file: no change", function()
               path.is_file = function() return true end
               assert.equal(m.infer.file_into_dir("dir/test.md", "dir/subdir/test.md"), "dir/subdir/test.md")
           end)
         
           it("file to dir: change", function()
               path.is_file = function() return true end
               assert.equal(m.infer.file_into_dir("dir/test.md", "dir/subdir"), "dir/subdir/test.md")
           end)
       end)

       describe("dir_into_dir:", function()
           it("dst exists: src → dst/src", function()
               path.is_dir = function() return true end
               assert.equal(m.infer.dir_into_dir("subdir", "dir"), "dir/subdir")
           end)

           it("dst doesn't exist: src → dst", function()
               path.is_dir = function(p) return p == 'subdir' end
               assert.equal(m.infer.dir_into_dir("subdir", "dir"), "dir")
           end)
       end)
   end)
end)
