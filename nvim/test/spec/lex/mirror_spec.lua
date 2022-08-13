local mock = require('luassert.mock')
local stub = require('luassert.stub')
local m = require('lex.mirror')
require('util')


describe("Location", function()
    local config = require'lex.config'
    local _config = {
        root = '/a',
        mirrors_dir_prefix = 'b',
        mirrors_root = '/a/b',
        mirrors = {
            type_one = {
                dir_prefix = 'type_one',
                mirror_other_mirrors = false,
                dir = '/a/b/type_one',
            },
            type_two = {
                dir_prefix = 'type_two/two',
                mirror_other_mirrors = true,
                dir = '/a/b/type_two/two',
            },
            type_three = {
                dir_prefix = 'type_three',
                mirror_other_mirrors = true,
                dir = '/a/b/type_three',
            },
        },
    }

    local config_get = config.get

    before_each(function()
        config.get = function() return _config end
    end)

    after_each(function()
        config.get = config_get
    end)

    describe("init", function()
        it("infers path", function()
            local one = m.MLocation()
            assert.equal(one.path, vim.fn.expand('%:p'))
        end)
    end)

    describe("get_type", function()
        it("non-mirror", function()
            local l = m.MLocation({ path = '/a/file.md'})
            assert.equals(l.type, "origin")
        end)

        it("mirror", function()
            local l = m.MLocation({ path = '/a/b/type_one/file.md' })
            assert.equals(l.type, "type_one")
        end)

        it("nested mirror", function()
            local l = m.MLocation({ path = '/a/b/type_two/two/type_one/file.md'})
            assert.equals(l.type, "type_two")
        end)
    end)

    describe("get_origin", function()
        it("non-mirrored path returns self", function()
            local l = m.MLocation({ path = '/a/file.md'})
            assert.equals(l.origin.path, "/a/file.md")
        end)

        it("identifies the origin", function()
            local one = m.MLocation({ path = '/a/b/type_two/two/type_one/file.md'})
            assert.equals(one.origin.path, "/a/file.md")
        end)
    end)

    describe("get_location", function()
        it("req = same type", function()
            local l = m.MLocation()
            l.origin = "origin"
            l.type = 1
            assert.equals(l:get_location(1), "origin")
        end)

        it("non-mirrors_other_mirrors and type_mirrors_other_mirrors", function()
            local l = m.MLocation({ path = "/a/b/type_one/file.md" })
            assert.is_false(l.mirrors_other_mirrors)

            local actual = l:get_location("type_two")
            local expected = m.MLocation({ path = "/a/b/type_two/two/type_one/file.md" })
            assert.equal(actual.path, expected.path)
        end)

        it("non-mirrors_other_mirrors and non-type_mirrors_other_mirrors", function()
            local l = m.MLocation({ path = "/a/file.md" })

            assert.is_false(l.mirrors_other_mirrors)

            local actual = l:get_location("type_one")
            local expected = m.MLocation({ path = "/a/b/type_one/file.md" })
            assert.equal(actual.path, expected.path)
        end)

        it("mirrors_other_mirrors and type_mirrors_other_mirrors", function()
            local l = m.MLocation({ path = '/a/b/type_two/two/file.md'})
            local actual = l:get_location("type_three")
            local expected = m.MLocation({ path = "/a/b/type_three/file.md" })
            assert.equal(actual.path, expected.path)
        end)
    end)
end)
