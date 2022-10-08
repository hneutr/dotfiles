local Object = require("util.object")
local line_utils = require("util.lines")


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
    for key, val in pairs(_G.default_args(args, self.defaults)) do
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
}
ListLine.sigil = '-'

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
    local indent, text = str:match(ListLineClass.get_sigil_pattern(ListLineClass.sigil))
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


--------------------------------------------------------------------------------
--                            get_sigil_line_class                            --
--------------------------------------------------------------------------------
function get_sigil_line_class(sigil)
    local SigilClass = ListLine:extend()
    SigilClass.sigil = sigil

    SigilClass.get_if_str_is_a = function(str, line_number)
        return ListLine._get_if_str_is_a(str, line_number, SigilClass)
    end

    return SigilClass
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

return {
    Line = Line,
    ListLine = ListLine,
    NumberedListLine = NumberedListLine,
    get_sigil_line_class = get_sigil_line_class,
}
