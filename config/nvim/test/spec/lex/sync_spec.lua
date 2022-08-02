local mock = require('luassert.mock')
local stub = require('luassert.stub')
local m = require'lex.sync'

describe("sync", function()
   before_each(function()
      m = require'lex.sync'
   end)

   describe("on enter", function()
      local read_markers = m.read_markers

      before_each(function()
         m.read_markers = function() return { key = 'val' } end
      end)

      after_each(function()
         m.read_markers = read_markers
      end)


      it("inits properly", function()
         assert.is_nil(vim.g.deleted_markers)
         assert.is_nil(vim.b.markers)
         assert.is_nil(vim.b.renamed_markers_new_to_old)
         assert.is_nil(vim.b.renamed_markers_old_to_new)
         assert.is_nil(vim.b.renamed_markers_old_to_new)
         assert.is_nil(vim.b.deleted_markers)
         assert.is_nil(vim.b.created_markers)

         m.buf_enter()

         assert.is_true(vim.tbl_isempty(vim.g.deleted_markers))
         assert.is_true(vim.tbl_isempty(vim.b.renamed_markers_new_to_old))
         assert.is_true(vim.tbl_isempty(vim.b.renamed_markers_old_to_new))
         assert.is_true(vim.tbl_isempty(vim.b.deleted_markers))
         assert.is_true(vim.tbl_isempty(vim.b.created_markers))
         assert.equals(type(vim.b.markers), 'table')
         assert.equals(vim.tbl_count(vim.b.markers), 1)
         assert.equals(vim.b.markers.key, 'val')
      end)
   end)

   describe("read_markers", function()
      before_each(function()
         local buf = vim.api.nvim_create_buf(false, true)
         vim.api.nvim_command("buffer " .. buf)

      end)

      it("finds markers", function()
         local buffer_text = { "[marker 1]()", "", "[ref](ref)", "[marker 2]()", "nonmarker", ""}
         vim.api.nvim_buf_set_lines(0, 0, -1, true, buffer_text)

         local markers = m.read_markers()

         assert.equals(vim.tbl_count(markers), 2)
         assert.equals(markers['marker 1'], 1)
         assert.equals(markers['marker 2'], 4)
      end)
   end)

   describe("on change", function()
   -- M.buf_change()
   -- M.record_marker_creations_and_deletions
   -- M.check_rename(new, old)
   end)

   describe("on leave", function()
   -- M.buf_leave()
   -- M.process_creations()
   -- M.process_deletions()
   -- M.process_renames()
   end)
end)
