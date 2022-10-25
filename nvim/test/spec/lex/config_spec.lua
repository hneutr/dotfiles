local stub = require('luassert.stub')
local m = require('lex.config')
require('util')

describe(".config", function()
    local constants

    before_each(function()
        m = require('lex.config')
        constants = require('lex.constants')
    end)

    describe("file", function()
        local filereadable = vim.fn.filereadable
        local set_config

        local function filereadable_stub(path)
            if path == '/1/2/.project' then
                return 1
            elseif path == '/1/2/3/.project' then
                return 1
            end

            return 0
        end

        before_each(function()
            vim.fn.filereadable = filereadable_stub
        end)

        after_each(function()
            vim.fn.expand = expand
            vim.fn.filereadable = filereadable
        end)

        describe("find", function() 
            it("doesn't find a config", function()
                assert.is_nil(m.file.find("/a/b/c/d.md"))
            end)

            it("finds the nearest config config", function()
                assert.equal(m.file.find("/1/2/3/4.md"), "/1/2/3/.project")
            end)
        end)

        describe("build:", function() 
            local original_mirror_defaults = constants.mirror_defaults
            local json_decode = vim.fn.json_decode
            local readfile = vim.fn.readfile

            local raw_config = {
                root = '/root',
                mirrors = {
                    y = {disable = true},
                },
            }

            local mirror_defaults = {
                a = {
                    dir = "a",
                    mirrors = {
                        x = {opener_prefix = 'x'},
                        y = {opener_prefix = 'y'},
                    },
                },
                b = {
                    dir = "b",
                    mirrors = {
                        z = {opener_prefix = 'z', mirror_other_mirrors = true},
                    }
                }
            }

            before_each(function()
                vim.fn.json_decode = function() return raw_config end
                vim.fn.readfile = function() return {} end
                constants.mirror_defaults = mirror_defaults
            end)

            after_each(function()
                constants.mirror_defaults = original_mirror_defaults
                vim.fn.json_decode = json_decode
                vim.fn.readfile = readfile
            end)

            it("reads a config", function()
                local expected = {
                    root = "/1/2/3",
                    mirrors = {
                        x = {
                            opener_prefix = 'x',
                            dir = "/1/2/3/a/x",
                            kind = "a",
                        },
                        z = {
                            opener_prefix = 'z',
                            mirror_other_mirrors = true,
                            dir = "/1/2/3/b/z",
                            kind = "b",
                        },
                    }
                }

                local actual = m.file.build("/1/2/3/4.md")
                assert.are.same(actual, expected)
            end)
        end)
    end)

    describe("set", function()
        local find = m.file.find
        local build = m.file.build
    
        before_each(function()
            m.file.build = function() return { test = 1 } end
            vim.g.lex_configs = nil
        end)
    
        after_each(function()
            m.file.find = find
            m.file.build = build
            vim.g.lex_configs = nil
        end)
    
        it("doesn't find a file", function()
            m.file.find = function() return end
    
            m.set()
            assert.is_nil(vim.b.lex_config_path)
            assert.is_true(vim.tbl_isempty(vim.g.lex_configs))
        end)
    
        it("finds a file without predefined config", function()
            m.file.find = function() return "test" end
    
            m.set()
            assert.equals(vim.b.lex_config_path, 'test')
            assert.equals(vim.tbl_count(vim.g.lex_configs.test), 1)
            assert.equals(vim.g.lex_configs.test.test, 1)
        end)
    
        it("finds a file with predefined config", function()
            build = stub(m.file, "build")
    
            m.file.find = function() return "test" end
            vim.g.lex_configs = { test = { test = 1 } }
    
            m.set()
            assert.equals(vim.b.lex_config_path, 'test')
            assert.equals(vim.tbl_count(vim.g.lex_configs.test), 1)
            assert.equals(vim.g.lex_configs.test.test, 1)
    
            assert.stub(build).was_not_called()
    
            build:revert()
        end)
    end)
    
    describe("get", function()
        it("checks that things are ok without anything defined", function()
            assert.is_true(vim.tbl_isempty(m.get()))
        end)
    end)
end)
