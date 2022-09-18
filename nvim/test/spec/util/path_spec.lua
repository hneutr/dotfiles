local mock = require('luassert.mock')
local stub = require('luassert.stub')
local m = require('util.path')

describe("resolve:", function()
   local pwd

   before_each(function()
       pwd = vim.env.PWD
       vim.env.PWD = "/root/dir"
   end)

   after_each(function()
       vim.env.PWD = pwd
   end)

   describe("resolve", function()
       it("converts . into pwd", function()
           assert.equal(m.resolve("."), "/root/dir")
       end)

       it("adds pwd onto path", function()
           assert.equal(m.resolve("file.md"), "/root/dir/file.md")
       end)
   end)
end)
