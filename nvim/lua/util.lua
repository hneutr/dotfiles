function lrequire(package_name)
    return function()
        return require(package_name)
    end
end

function open_two_vertical_terminals()
    vim.cmd("silent terminal")
    vim.api.nvim_input('<esc>')
    vim.cmd("silent vsplit")
    vim.cmd("silent terminal")
    vim.api.nvim_input('<C-h>')
end

--------------------------------------------------------------------------------
-- if the line ends with `char`, remove it
-- otherwise, remove trailing punctuation + add `char`
--------------------------------------------------------------------------------
function toggle_trailing_punctuation(char)
    return function()
        char = vim.tbl_get(vim.g.ft_punctuation_toggles[vim.bo.filetype] or {}, char) or char

        local line, found = vim.fn.getline("."):rstrip():gsub(
            "[,;:]$",
            function(c) return c == char and "" or char end
        )

        vim.fn.setline(".", found == 0 and (line .. char) or line)
    end
end

vim.paste = (function(lines)
    if vim.tbl_contains(vim.g.filetypes_to_fix_quotes_on_paste, vim.bo.filetype) then
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
    end

    vim.api.nvim_put(lines, 'c', true, true)
end)

function spaceless_abbreviation(str)
    if vim.fn.exists("*EatSpaceFromAbbreviation") == 0 then
        -- VimL function to handle trailing spaces in abbreviations.
        vim.cmd([[
            function! EatSpaceFromAbbreviation(...)
                let pat = a:0 ? a:1 : '\s'
                let chr = nr2char(getchar(0))
                return (chr =~ pat) ? '' : chr
            endfunction
        ]])
    end

    return str .. "<C-R>=EatSpaceFromAbbreviation()<CR>"
end
