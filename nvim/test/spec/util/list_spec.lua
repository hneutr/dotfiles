local mock = require('luassert.mock')
local stub = require('luassert.stub')
local util = require('util')
local m = require('util.list')

describe("renumber_list", function()
    -- local 

    -- describe(".shorten:", function() 
    --     it("path", function()
    --         assert.equal("a/b", m.path.shorten("root/a/b"))
    --     end)
    -- end)
end)

describe("ListItem", function()
   before_each(function()
      m = require('util.list')
   end)

   describe(":new", function() 
      it("makes an empty Item", function()
         local item1 = m.ListItem({text = "1"})
         local item2 = m.ListItem({text = "2"})

         assert.equal(item1.text, '1')
         assert.equal(item2.text, '2')
      end)
   end)

    describe(":str", function()
        it("basic case", function()
            local item = m.ListItem({text = 'text'})
    
            assert.equal(item:str(), "- text")
        end)
    
        it("indent", function()
            local item = m.ListItem({text = 'text', indent = "    "})
    
            assert.equal(item:str(), "    - text")
        end)
    end)

    describe(":get_if_str_is_a", function()
        it("negative case", function()
            assert.is_nil(m.ListItem.get_if_str_is_a("string", 0))
        end)
    
        it("positive case", function()
            assert.are.same(
                m.ListItem.get_if_str_is_a("    - string", 0),
                m.ListItem({text = "string", indent = "    ", line_number = 0})
            )
        end)
    end)
end)

describe("NumberedListItem", function()
   before_each(function()
      m = require('util.list')
   end)

   describe(":new", function() 
      it("makes an empty Item", function()
         local item = m.NumberedListItem()

         assert.equal(item.number, 1)
      end)
   end)

    describe(":str", function()
        it("basic case", function()
            local item = m.NumberedListItem({text = 'text'})
    
            assert.equal(item:str(), "1. text")
        end)
    end)

    describe(":get_if_str_is_a", function()
        it("negative case", function()
            assert.is_nil(m.NumberedListItem.get_if_str_is_a("- string", 0))
        end)
    
        it("positive case", function()
            assert.are.same(
                m.NumberedListItem.get_if_str_is_a("    10. string", 0),
                m.NumberedListItem({number = 10, text = "string", indent = "    ", line_number = 0})
            )
        end)
    end)
end)
