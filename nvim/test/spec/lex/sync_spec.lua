local mock = require('luassert.mock')
local stub = require('luassert.stub')
local m = require'lex.sync'
local Reference = require("hnetxt-lua.element.reference")

require'util'
require'util.tbl'

describe("sync", function()
   before_each(function()
      m = require'lex.sync'
      vim.b.hnetxt_project_root = 'root'
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
        local Location = require("hnetxt-nvim.text.location")

        before_each(function()
            local buf = vim.api.nvim_create_buf(false, true)
            vim.api.nvim_command("buffer " .. buf)

            Location.update = function() return end
        end)

        after_each(function()
            Location.update = location_update
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

      describe("process_renames", function()
         it("base case", function()
            local renames = {one = 'one a', two = 'two a'}
            local refs = { ['path:one'] = true }
            local creations = {}
            local deletions = {}

            local a_updates, a_renames, a_references = m.process_renames(renames, deletions, creations, refs)
            assert.are.same(a_updates, {{ new_location = "path:one a", old_location = "path:one" }})
            assert.are.same(a_references, { ["path:one a"] = true })
            assert.are.same(a_renames, renames)
         end)

         it("handles deletion", function()
            local renames = {one = 'one a', two = 'two a'}
            local refs = { ['path:one'] = true }
            local creations = {}
            local deletions = { ["two a"] = true }

            local a_updates, a_renames, a_references = m.process_renames(renames, deletions, creations, refs)
            assert.are.same(a_updates, {{ new_location = "path:one a", old_location = "path:one" }})
            assert.are.same(a_references, { ["path:one a"] = true })
            assert.are.same(a_renames, { one = 'one a' })
         end)

         it("handles creation", function()
            local renames = {one = 'one a', two = 'two a'}
            local refs = { ['path:one'] = true }
            local creations = { one = true }
            local deletions = { ["two a"] = true }

            local a_updates, a_renames, a_references = m.process_renames(renames, deletions, creations, refs)
            assert.are.same(a_updates, {})
            assert.are.same(a_references, { ["path:one a"] = true })
            assert.are.same(a_renames, { one = 'one a' })
         end)

         it("adds references", function()
            local references_list = Reference.get_referenced_mark_locations

            Reference.get_referenced_mark_locations = function() return {"new"} end

            local renames = {one = 'one a', two = 'two a'}
            local refs = {['path:one'] = true}
            local creations = {}
            local deletions = {["two a"] = true}

            local a_updates, a_renames, a_references = m.process_renames(renames, deletions, creations, refs)
            assert.are.same({{new_location = "path:one a", old_location = "path:one"}}, a_updates)
            assert.are.same({["path:one a"] = true, new = true}, a_references)
            assert.are.same(renames, a_renames)

            Reference.get_referenced_mark_locations = references_list
         end)
      end)

      describe("process_creations", function()
         it("handles an unrenamed case", function()
            local creations = { two = true }
            local renames = {one = 'one a'}
            local deletions = { two = "path/to/two" }
            local refs = { ['path/to/two:two'] = true }

            local updates, deletions, refs = m.process_creations(creations, renames, deletions, refs)

            assert.are.same(updates, {{ new_location = "path:two", old_location = "path/to/two:two"}})
            assert.are.same(deletions, {})
            assert.are.same(refs, {['path:two'] = true})
         end)

         it("handles a rename", function()
            local creations = {two = true}
            local renames = {one = 'one a', two = 'two a'}
            local deletions = {two = "path/to/two"}
            local refs = {['path/to/two:two'] = true}

            local updates, deletions, refs = m.process_creations(creations, renames, deletions, refs)

            assert.are.same({{new_location = "path:two a", old_location = "path/to/two:two"}}, updates)
            assert.are.same({}, deletions)
            assert.are.same({['path:two a'] = true}, refs)
         end)
      end)

      describe("process_deletions", function()
         it("handles an unrenamed case", function()
            local deletions = { one = true }
            local previous_dels = { two = "path/to/two" }
            local refs = { ['path:one'] = true }

            local previous_dels = m.process_deletions(deletions, previous_dels, refs)

            assert.are.same(previous_dels, { two = 'path/to/two', one = 'path' })
         end)
      end)
   end)
end)
