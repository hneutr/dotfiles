local Projector = require('lextest.projector')

describe("move:", function()
    before_each(function()
        Path = require('util.path')
        m = require('lex.move')

        config = require("lex.config")
        Projector.create()
        root = config.get().root
        _path = function(path) return Path.join(root, path) end

        pwd = vim.env.PWD
        vim.cmd("cd " .. Projector.dir)
        vim.env.PWD = Projector.dir
    end)

    after_each(function()
        Projector.delete()
        vim.env.PWD = pwd
        vim.cmd("cd " .. pwd)
    end)

    describe("move file to file", function()
        it("works", function()
            content = {'x', 'y', 'y'}
            Projector.make_paths({"a.md"})
            Projector.set_content({["a.md"] = content})
            
            m.move("a.md", "b.md")
            
            assert.is_false(Path.is_file(_path('a.md')))
            assert.is_true(Path.is_file(_path('b.md')))
            assert.are_same(content, Path.read(_path('b.md')))
        end)

        it("updates refs", function()
            Projector.make_paths({"a.md", "z.md"})
            Projector.set_content({["z.md"] = {"[test](a.md)"}})
            
            m.move("a.md", "b.md")
            
            assert.are_same({"[test](b.md)"}, Path.read(_path('z.md')))
        end)
    end)
end)
