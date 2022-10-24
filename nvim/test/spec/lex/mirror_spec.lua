local mock = require('luassert.mock')
local stub = require('luassert.stub')
local Path = require('util.path')
require('util')


describe("Location", function()
    local config = require('lex.config')
    local _config = {
        root = '/root',
        mirrors = {
            x = {
                mirror_other_mirrors = false,
                dir = '/root/a/x',
                kind = 'a',
            },
            y = {
                kind = 'a',
                dir = '/root/a/y',
            },
            z = {
                mirror_other_mirrors = true,
                kind = 'b',
                dir = '/root/b/z',
            },
            w = {
                mirror_other_mirrors = true,
                kind = 'c',
                dir = '/root/c/w',
            },
        },
    }

    local config_get = config.get

    before_each(function()
        Mirror = require('lex.mirror')
        config.get = function() return _config end
    end)

    after_each(function()
        config.get = config_get
    end)

    describe("init", function()
        it("infers path", function()
            assert.equal(Mirror().path, Path.current_file())
        end)
    end)
    
    describe("get_type", function()
        it("non-mirror", function()
            assert.equals(Mirror.get_type('/root/file.md', config.get()), "origin")
        end)
    
        it("mirror", function()
            assert.equals(Mirror.get_type('/root/a/x/file.md', config.get()), "x")
        end)
           
        it("nested mirror", function()
            assert.equals(Mirror.get_type('/root/a/x/y/file.md', config.get()), "x")
        end)
    end)

    describe("get_origin", function()
        it("from origin", function()
            local l = Mirror({path = '/root/file.md'})
            assert.equals(l:get_origin(), l)
        end)

        it("identifies the origin", function()
            local l = Mirror({path = '/root/a/x/y/file.md'})
            local origin = Mirror({path = '/root/file.md'})
            assert.are_same(l:get_origin(), origin)
        end)
    end)

    describe("get_location", function()
        it("req = same type", function()
            local l = Mirror()
            l.origin = "origin"
            l.type = 1
            assert.equals(l:get_location(1), "origin")
        end)
    
        it("non-mirrors_other_mirrors and type_mirrors_other_mirrors", function()
            local l = Mirror({path = "/root/a/x/file.md"})
            assert.is_not_true(l.mirrors_other_mirrors)
           
            local actual = l:get_location("z")
            local expected = Mirror({path = "/root/b/z/a/x/file.md"})
            assert.equal(actual.path, expected.path)
        end)
           
        it("non-mirrors_other_mirrors and non-type_mirrors_other_mirrors", function()
            local l = Mirror({path = "/root/a/x/file.md"})
            assert.is_not_true(l.mirrors_other_mirrors)
           
            local actual = l:get_location("y")
            local expected = Mirror({ path = "/root/a/y/file.md" })
            assert.equal(actual.path, expected.path)
        end)
           
        it("mirrors_other_mirrors and type_mirrors_other_mirrors", function()
            local l = Mirror({ path = '/root/b/z/file.md'})
            local actual = l:get_location("w")
            local expected = Mirror({path = "/root/c/w/file.md"})
            assert.equal(actual.path, expected.path)
        end)
    end)
end)
