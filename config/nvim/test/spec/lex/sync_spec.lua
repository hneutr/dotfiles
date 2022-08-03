local mock = require('luassert.mock')
local stub = require('luassert.stub')
local m = require'lex.sync'
require'util'
require'tbl'

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
         assert.is_nil(vim.b.renamed_markers)
         assert.is_nil(vim.b.deleted_markers)
         assert.is_nil(vim.b.created_markers)

         m.buf_enter()

         assert.is_true(vim.tbl_isempty(vim.g.deleted_markers))
         assert.is_true(vim.tbl_isempty(vim.b.renamed_markers))
         assert.is_true(vim.tbl_isempty(vim.b.deleted_markers))
         assert.is_true(vim.tbl_isempty(vim.b.created_markers))

         assert.are.same(vim.b.markers, { key = 'val' })
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
         assert.are.same(markers, { ['marker 1'] = 1, ['marker 2'] = 4})
      end)
   end)

   describe("on change", function()
      before_each(function()
         local buf = vim.api.nvim_create_buf(false, true)
         vim.api.nvim_command("buffer " .. buf)
      end)

      describe(".get_deletions", function()
         it("finds deletions", function()
            local old = { one = 1, two = 2 }
            local new = { one = 1 }

            assert.are.same(m.get_deletions(old, new), { "two" })
         end)
      end)

      describe(".get_creations", function()
         it("finds creations", function()
            local old = { one = 1 }
            local new = { one = 1, two = 2 }

            assert.are.same(m.get_creations(old, new), { "two" })
         end)
      end)

      describe(".check_rename", function()
         it("finds rename", function()
            local old_markers = { one = 1, two_a = 2 }
            local new_markers = { one = 1, two_b = 2 }
            local deletions = {"two_a"}
            local creations = {"two_b"}

            assert.is_true(m.check_rename(old_markers, new_markers, creations, deletions))
         end)

         it("doesn't find rename", function()
            local old_markers = { one = 1, two = 2 }
            local new_markers = { one = 1, one_and_a_half = 2, two = 3 }
            local deletions = {}
            local creations = {"one_and_a_half"}

            assert.is_false(m.check_rename(old_markers, new_markers, creations, deletions))
         end)

         it("doesn't find rename (2)", function()
            local old_markers = { one = 1, two = 2 }
            local new_markers = { one = 1, three = 3 }
            local deletions = {"two"}
            local creations = {"three"}

            assert.is_false(m.check_rename(old_markers, new_markers, creations, deletions))
         end)
      end)

      describe(".record_rename", function()
         it("basic case", function()
            local actual = m.update_renames("old", "new", {})
            assert.are.same(actual, { old = 'new' })
         end)

         it("rename of something else", function()
            local actual = m.update_renames("old", "new", {older = 'old'})
            assert.are.same(actual, { older = 'new' })
         end)

         it("doesn't overwrite stuff", function()
            local actual = m.update_renames("old", "new", {other_old = 'other_new'})
            assert.are.same(actual, { old = 'new', other_old = 'other_new' })
         end)
      end)

      describe(".update_creations", function()
         it("base case", function()
            local actual = m.update_creations({"old"}, {"new"}, {old = true, other = true})
            assert.are.same(actual, { other = true, new = true })
         end)
      end)

      describe(".update_deletions", function()
         it("base case", function()
            local actual = m.update_deletions({"old"}, {"new"}, {new = true, other = true})
            assert.are.same(actual, { other = true, old = true })
         end)
      end)

      it("records a rename", function()
         local old_text = { "[marker 1]()" }
         vim.api.nvim_buf_set_lines(0, 0, -1, true, old_text)
         m.buf_enter()

         vim.b.renamed_markers = { ['marker 2'] = 'marker 2a'}

         local new_text = { "[marker 1a]()" }
         vim.api.nvim_buf_set_lines(0, 0, -1, true, new_text)
         m.buf_change()

         assert.are.same(vim.b.renamed_markers, { ['marker 1'] = 'marker 1a', ['marker 2'] = 'marker 2a'})
      end)

      it("records a deletion", function()
         local old_text = { "[marker 1]()" }
         vim.api.nvim_buf_set_lines(0, 0, -1, true, old_text)
         m.buf_enter()

         vim.b.created_markers = { ['marker 1'] = true}

         local new_text = {}
         vim.api.nvim_buf_set_lines(0, 0, -1, true, new_text)
         m.buf_change()

         assert.are.same(vim.b.deleted_markers, { ['marker 1'] = true })
         assert.is_true(vim.tbl_isempty(vim.b.created_markers))
         assert.is_true(vim.tbl_isempty(vim.b.markers))
      end)

      it("records a creation", function()
         local old_text = {}
         vim.api.nvim_buf_set_lines(0, 0, -1, true, old_text)
         m.buf_enter()

         vim.b.deleted_markers = { ['marker 1'] = true}

         local new_text = { "[marker 1]()" }

         vim.api.nvim_buf_set_lines(0, 0, -1, true, new_text)
         m.buf_change()

         assert.are.same(vim.b.created_markers, { ['marker 1'] = true })
         assert.is_true(vim.tbl_isempty(vim.b.deleted_markers))
         assert.are.same(vim.b.markers, { ['marker 1'] = 1 })
      end)

   end)

   describe("on leave", function()
      local expand = vim.fn.expand

      before_each(function()
         vim.fn.expand = function() return "path" end
      end)

      after_each(function()
         vim.fn.expand = expand
      end)

      describe("process_creations", function()
         it("handles an unrenamed case", function()
            local creations = { creation = true }
            local renames = {one = 'one a'}
            local deletions = { two = "path/to/two" }

            local updates, renames, deletions = m.process_creations(creations, renames, deletions)

            local expected = {old_path = 'path', old_text = 'creation', new_path = 'path', new_text = 'creation'}

            assert.are.same(updates, {expected})
            assert.are.same(renames, { one = 'one a' })
            assert.are.same(deletions, { two = 'path/to/two' })
         end)

         it("handles a rename+previous_deletion case", function()
            local creations = { one = true }
            local renames = {one = 'one a', two = 'two a'}
            local deletions = { one = "path/to/one", two = 'path/to/two' }

            local updates, renames, deletions = m.process_creations(creations, renames, deletions)

            local expected = {old_path = 'path/to/one', old_text = 'one', new_path = 'path', new_text = 'one a'}

            assert.are.same(updates, {expected})
            assert.are.same(renames, { two = 'two a' })
            assert.are.same(deletions, { two = 'path/to/two' })
         end)
      end)

      describe("process_deletions", function()
         it("handles an unrenamed case", function()
            local deletions = { deletion = true }
            local renames = {one = 'one a'}
            local previous_dels = { two = "path/to/two" }

            local renames, previous_dels = m.process_deletions(deletions, renames, previous_dels)

            assert.are.same(renames, { one = 'one a' })
            assert.are.same(previous_dels, { two = 'path/to/two', deletion = 'path' })
         end)

         it("handles a rename case", function()
            local deletions = { ['one a'] = true }
            local renames = {one = 'one a', two = 'two a'}
            local previous_dels = { two = "path/to/two" }

            local renames, previous_dels = m.process_deletions(deletions, renames, previous_dels)

            assert.are.same(renames, { two = 'two a' })
            assert.are.same(previous_dels, { ['one a'] = 'path', two = 'path/to/two' })
         end)
      end)

      describe("process_renames", function()
         it("base case", function()
            local renames = {one = 'one a', two = 'two a'}

            local updates = m.process_renames(renames)

            table.sort(updates, function(a, b) return a.old_text < b.old_text end)

            local expected = {
               { old_path = 'path', old_text = 'one', new_path = 'path', new_text = 'one a' },
               { old_path = 'path', old_text = 'two', new_path = 'path', new_text = 'two a' },
            }

            assert.are.same(updates, expected)
         end)
      end)

      describe("leave integration", function()
         local marker_utils = require'lex.marker'
         local reference_update = marker_utils.reference.update

         before_each(function()
            marker_utils.reference.update = function(args) return args end
         end)

         after_each(function()
            marker_utils.reference.update = reference_update
         end)

         it("processes things", function()
            vim.b.created_markers = { one = true, two = true }
            vim.b.deleted_markers = { ["three a"] = true }
            vim.b.renamed_markers = { one = "one a", two = "two a", three = "three a" }
            vim.g.deleted_markers = { two = "path/to/two", four = "path/to/four" }

            local updates = m.buf_leave()

            table.sort(updates, function(a, b) return a.old_text < b.old_text end)

            local expected = {
               { old_path = 'path', old_text = 'one', new_path = 'path', new_text = 'one a' },
               { old_path = 'path/to/two', old_text = 'two', new_path = 'path', new_text = 'two a' },
            }

            assert.are.same(updates, expected)

            assert.are.same(vim.g.deleted_markers, { four = 'path/to/four', ['three a'] = 'path' })
         end)
      end)
   end)
end)
