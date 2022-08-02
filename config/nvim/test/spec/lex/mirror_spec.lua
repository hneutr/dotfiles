local mock = require('luassert.mock')
local stub = require('luassert.stub')
local m = require('lex.mirror')
require('util')


describe("apply_mirror_defaults_to_config", function()
   local get_mirror_defaults = m.get_mirror_defaults
   before_each(function()
      m = require'lex.mirror'
      m.get_mirror_defaults = function() return defaults end
   end)

   after_each(function()
      m.get_mirror_defaults = get_mirror_defaults
   end)

   it("basics", function()
      local config = {
         root = '/root',
         mirrors = {
            two = {
               mirrorOtherMirrors = true,
            },
            three = {
               disable = true,
            },
         },
      }

      local defaults = {
         mirrorsDirPrefix = '',
         mirrors = {
            one = {
               vimPrefix = '1',
               dirPrefix = '1',
               mirrorOtherMirrors = false,
            },
            two = {
               vimPrefix = '2',
               dirPrefix = '2',
               mirrorOtherMirrors = false,
            },
            three = {
               vimPrefix = '3',
               dirPrefix = '3',
               mirrorOtherMirrors = true,
            },
         }
      }

      local expected = {
         root = '/root',
         mirrors = {
            one = {
               vimPrefix = '1',
               dirPrefix = '1',
               mirrorOtherMirrors = false,
               dir = '/root/1',
            },
            two = {
               vimPrefix = '2',
               dirPrefix = '2',
               mirrorOtherMirrors = true,
               dir = '/root/2',
            },
         }
      }

      m.get_mirror_defaults = function() return defaults end

      local actual = m.apply_defaults_to_config(config)
      local a_mirrors = actual.mirrors

      assert.equal(vim.tbl_count(a_mirrors), 2)
      assert.not_nil(a_mirrors.one)
      assert.not_nil(a_mirrors.two)
      assert.is_true(a_mirrors.two.mirrorOtherMirrors)
      assert.equals(a_mirrors.one.dir, '/root/1')
      assert.equals(a_mirrors.two.dir, '/root/2')
   end)
end)
