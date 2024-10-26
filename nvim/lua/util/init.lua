local M = {}

function lrequire(package_name)
    return function()
        return require(package_name)
    end
end

function _G.default_args(args, defaults)
    return vim.tbl_extend("keep", {}, args or {}, defaults)
end

--------------------------------------------------------------------------------
--                                    misc                                    --
--------------------------------------------------------------------------------
function M.open_two_vertical_terminals()
    vim.cmd("silent terminal")
    vim.api.nvim_input('<esc>')
    vim.cmd("silent vsplit")
    vim.cmd("silent terminal")
    vim.api.nvim_input('<C-h>')
end

--------------------------------------------------------------------------------
--                              modify_line_end                               --
--------------------------------------------------------------------------------
-- args:
--      - a delimiter char
--
-- if the line ends with the delimiter char: removes the delimiter char
-- if the line doesn't end in a delimiter: adds the delimiter char
-- if the line ends in another delimiter: replaces it with the delimiter char
--
-- delimiters: ,;:
--------------------------------------------------------------------------------
function M.modify_line_end(char)
    return function()
        local delimiters = List({',', ';', ':'})
        local line = vim.fn.getline("."):rstrip()

        local new_line
        while #delimiters > 0 and not new_line do
            local delimiter = delimiters:pop()
            if line:endswith(delimiter) then
                local suffix = delimiter == char and "" or char
                new_line = line:removesuffix(delimiter) .. suffix
            end
        end

        vim.fn.setline(".", new_line or line .. char)
    end
end

function M.fix_quotes(lines)
    local quotes = {
        ['’'] = "'",
        ['“'] = '"',
        ['”'] = '"',
    }

    for i, line in ipairs(lines) do
        for old, new in pairs(quotes) do
            line = line:gsub(old, new)
        end

        lines[i] = line
    end

    return lines
end

vim.paste = (function(lines, phase)
    if vim.g.ft_paste_function[vim.bo.filetype] then
        lines = M[vim.g.ft_paste_function[vim.bo.filetype]](lines)
    end

    vim.api.nvim_put(lines, 'c', true, true)
end)

return M
