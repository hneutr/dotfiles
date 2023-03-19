local Path = require("util.path")

local constants_dir = "/Users/hne/dotfiles/lex/constants"
local initialize_with = 'init'

function load()
    local constants = {}
    for _, file in ipairs(Path.list_paths(constants_dir)) do
        local name = Path.stem(file)

        if Path.suffix(file) == 'json' then
            local subconstants = vim.fn.json_decode(Path.read(file))

            if name == initialize_with then
                constants = vim.tbl_extend("keep", subconstants, constants)
            else
                constants[name] = subconstants
            end
        end
    end

    return constants
end

return load()
