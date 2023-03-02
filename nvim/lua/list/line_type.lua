local Object = require("util.object")
require('util.tbl')

local color = require('color')
local line_utils = require("util.lines")


local list_types = {
    bullet = {
        sigil = '-',
        highlights = {set = false},
    },
    dot = {
        sigil = '*',
        toggle = {mapping = {lhs = 'o'}},
        sigil_regex = [[\*]],
    },
    item = {
        sigil = '◻',
        toggle = {mapping = {lhs = 'i'}},
    },
    done = {
        sigil = '✓',
        toggle = {mapping = {lhs = 'd'}},
        highlights = {sigil = {fg = 'gray'}, text = {fg = 'gray', strikethrough = true}},
    },
    reject = {
        sigil = '⨉',
        toggle = {mapping = {lhs = 'x'}},
        highlights = {sigil = {fg = 'red'}, text = {fg = 'gray'}},
    },
    maybe = {
        sigil = '~',
        toggle = {mapping = {lhs = 'm'}},
        sigil_regex = [[\~]],
        highlights = {sigil = {fg = 'gray'}, text = {fg = 'gray'}},
    },
    question = {
        sigil = '?',
        toggle = {mapping = {lhs = 'q'}},
        highlights = {sigil = {fg = 'magenta'}, text = {italic = true, underline = true, sp = 'gray'}},
    },
    tag = {
        sigil = '@',
        toggle = {mapping = {lhs = 'a'}},
        highlights = {sigil = {fg = 'red'}, text = {underline = true, bold = true}},
    },
    -- prolly doesn't work
    number = {ListClass = NumberedListLine, toggle = {mapping = {lhs = 'n'}}, sigil_regex = [[(\d+)\.]]},
}


--------------------------------------------------------------------------------
--                                                                            --
--                                    Line                                    --
--                                                                            --
--------------------------------------------------------------------------------
Line = Object:extend()
Line.defaults = {
    text = '',
    line_number = 0,
}

function Line:new(args)
    for key, val in pairs(table.default(args, self.defaults)) do
        self[key] = val
    end
end

function Line:write()
    line_utils.set({start_line = self.line_number, replacement = {tostring(self)}})
end

function Line:__tostring() return self.text end

function Line:merge(other)
    self.text = _G.rstrip(self.text) .. " " .. _G.lstrip(other.text)
end

function Line.get_if_str_is_a(str, line_number)
    return Line({text = str, line_number = line_number})
end

--------------------------------------------------------------------------------
--                                  ListLine                                  --
--------------------------------------------------------------------------------
ListLine = Line:extend()
ListLine.defaults = {
    text = '',
    indent = '',
    line_number = 0,
    sigil = '-',
    name = 'bullet',
    highlights = {
        set = true,
        sigil = {
            fg = "blue",
            pattern = [[^\s*STR\s]],
            cmd = [[syn match KEY /PATTERN/ contained]],
            key = nil,
        },
        text = {
            pattern = [[start="SIGIL_PATTERN\+" end="$"]],
            cmd = [[syn region KEY PATTERN containedin=ALL contains=SIGIL_KEY,mkdLink]],
            key = nil,
        },
    },
    toggle = {
        mapping = {
            lhs = nil,
            rhs = [[:lua require('list').Buffer():toggle('MODE', 'NAME')<cr>]],
        },
        to = 'bullet',
    },
    -- continue_list_with
}


function ListLine:new(args)
    ListLine.super.new(self, args)

    -- self.set_highlighting()
end

function ListLine:__tostring()
    return self.indent .. self.sigil .. " " .. self.text
end

function ListLine.get_sigil_pattern(sigil)
    return "^(%s*)" .. _G.escape(sigil) .. "%s(.*)$"
end

function ListLine.get_if_str_is_a(str, line_number)
    return ListLine._get_if_str_is_a(str, line_number, ListLine)
end

function ListLine._get_if_str_is_a(str, line_number, ListLineClass)
    local indent, text = str:match(ListLineClass.get_sigil_pattern(ListLineClass.defaults.sigil))
    if indent and text then
        return ListLineClass({text = text, indent = indent, line_number = line_number})
    end
end

function ListLine.get_sigil_class(sigil)
    local SigilClass = ListLine:extend()
    SigilClass.sigil = sigil

    SigilClass.get_if_str_is_a = function(str, line_number)
        return ListLine._get_if_str_is_a(str, line_number, SigilClass)
    end

    return SigilClass
end

function ListLine:set_highlights()
    if not self.highlights.set then return end

    -- sigils
    sigil_key = (self.highlights.sigil.key or self.name) .. "ListLineSigil"
    sigil_pattern = self.highlights.sigil.pattern:gsub("STR", self.sigil_regex or self.sigil)
    sigil_cmd = self.highlights.sigil.cmd:gsub("KEY", sigil_key)
    sigil_cmd = sigil_cmd:gsub("PATTERN", sigil_pattern)

    vim.cmd(sigil_cmd)
    color.set_highlight({name = sigil_key, val = self.highlights.sigil})

    -- text
    text_key = (self.highlights.text.key or self.name) .. "ListLineText"

    text_pattern = self.highlights.text.pattern:gsub("SIGIL_PATTERN", sigil_pattern)
    text_cmd = self.highlights.text.cmd:gsub("SIGIL_KEY", sigil_key)
    text_cmd = text_cmd:gsub("PATTERN", text_pattern)
    text_cmd = text_cmd:gsub("KEY", text_key)

    vim.cmd(text_cmd)
    color.set_highlight({name = text_key, val = self.highlights.text})
end

function ListLine:map_toggle(lhs_prefix)
    if not self.toggle.mapping.lhs then return end

    lhs = (lhs_prefix or '') .. self.toggle.mapping.lhs

    for _, mode in ipairs({'n', 'v'}) do
        vim.keymap.set(
            mode,
            lhs,
            self.toggle.mapping.rhs:gsub("MODE", mode):gsub("NAME", self.name),
            {silent = true, buffer = true}
        )
    end
end


function ListLine.get_class(name)
    local settings = list_types[name]
    settings.name = name

    if settings.ListClass == NumberedListLine then
        return NumberedListLine
    end

    local ListClass = ListLine:extend()

    ListClass.defaults = table.default(settings, ListClass.defaults)

    ListClass.get_if_str_is_a = function(str, line_number)
        return ListLine._get_if_str_is_a(str, line_number, ListClass)
    end

    return ListClass
end

--------------------------------------------------------------------------------
--                              NumberedListLine                              --
--------------------------------------------------------------------------------
NumberedListLine = Line:extend()
NumberedListLine.defaults = {
    text = '',
    indent = '',
    line_number = 0,
    number = 1,
}
NumberedListLine.pattern = "^(%s*)(%d+)%.%s(.*)$"

function NumberedListLine:__tostring()
    return self.indent .. self.number .. '. ' .. self.text
end

function NumberedListLine.get_if_str_is_a(str, line_number)
    local indent, number, text = str:match(NumberedListLine.pattern)
    if indent and number and text then
        return NumberedListLine({
            number = tonumber(number),
            text = text,
            indent = indent,
            line_number = line_number,
        })
    end
end

--------------------------------------------------------------------------------
--                            get_sigil_line_class                            --
--------------------------------------------------------------------------------
function get_sigil_line_class(sigil)
    local SigilClass = ListLine:extend()
    SigilClass.defaults = table.default({sigil = sigil}, SigilClass.defaults)

    SigilClass.get_if_str_is_a = function(str, line_number)
        return ListLine._get_if_str_is_a(str, line_number, SigilClass)
    end

    return SigilClass
end


return {
    list_types = list_types,
    Line = Line,
    ListLine = ListLine,
    NumberedListLine = NumberedListLine,
    get_sigil_line_class = get_sigil_line_class,
}
