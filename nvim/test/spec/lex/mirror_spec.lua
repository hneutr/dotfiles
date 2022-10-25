local mock = require('luassert.mock')
local stub = require('luassert.stub')
local Path = require('util.path')
local Projector = require('lextest.projector')


describe("Mirror", function()
    local config = require('lex.config')

    before_each(function()
        Mirror = require('lex.mirror')
        Projector.create()
        root = config.get().root
        _path = function(path) return Path.join(root, path) end
    end)
    
    after_each(function()
        Projector.delete()
    end)

    describe("init", function()
        it("infers path", function()
            assert.equal(Mirror().path, Path.current_file())
        end)
    end)
    
    describe("get_type", function()
        it("non-mirror", function()
            Projector.set_mirrors({x = {kind='a'}})
            assert.equals(Mirror.get_type(_path('file.md'), config.get()), "origin")
        end)
    
        it("mirror", function()
            Projector.set_mirrors({x = {kind='a'}})
            assert.equals(Mirror.get_type(_path('a/x/file.md'), config.get()), "x")
        end)

        it("nested mirror", function()
            Projector.set_mirrors({x = {kind='a'}, y = {kind='a'}})
            assert.equals(Mirror.get_type(_path('a/x/y/file.md'), config.get()), "x")
        end)
    end)

    describe("get_origin", function()
        it("from origin", function()
            local l = Mirror({path = _path('file.md')})
            assert.equals(l:get_origin(), l)
        end)
    
        it("identifies the origin", function()
            Projector.set_mirrors({x = {kind='a'}, y = {kind='a'}})
            local l = Mirror({path = _path('a/x/y/file.md')})
            local origin = Mirror({path = _path('file.md')})
            assert.are_same(l:get_origin(), origin)
        end)
    end)

    describe("get_location", function()
        it("req = same type", function()
            local expected = Mirror({path = _path("file.md")})
            local actual = expected:get_location("origin")
            assert.equals(expected, actual)
        end)
    
        it("non-mirrors_other_mirrors and type_mirrors_other_mirrors", function()
            Projector.set_mirrors({x = {kind='a'}, y = {kind = 'b', mirror_other_mirrors = true}})
            local actual = Mirror({path = _path("a/x/file.md")}):get_location("y")
            local expected = Mirror({path = _path("b/y/a/x/file.md")})
            assert.are_same(expected, actual)
        end)

        it("non-mirrors_other_mirrors and non-type_mirrors_other_mirrors", function()
            Projector.set_mirrors({x = {kind='a'}, y = {kind='a'}})
            local actual = Mirror({path = _path("a/x/file.md")}):get_location("y")
            local expected = Mirror({ path = _path("a/y/file.md")})
            assert.are_same(expected, actual)
        end)
          
        it("mirrors_other_mirrors and type_mirrors_other_mirrors", function()
            Projector.set_mirrors({
                x = {kind='a', mirror_other_mirrors = true},
                y = {kind='b', mirror_other_mirrors = true},
            })

            local actual = Mirror({path = _path('a/x/file.md')}):get_location('y')
            local expected = Mirror({path = _path("b/y/file.md")})
            assert.are_same(expected, actual)
        end)
    end)
end)
