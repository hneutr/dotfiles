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
end)
