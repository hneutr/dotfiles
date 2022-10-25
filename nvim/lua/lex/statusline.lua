local Path = require('util.path')
local config = require('lex.config')

function get_path()
    local p = Path.current_file()
    p = Path.remove_from_start(p, config.get().root)
    return p
end

function get_column_number() return "%c" end

function get_statusline()
    return table.concat({
        get_path(),
        "%=",
        get_column_number(),
    })
end

return get_statusline
