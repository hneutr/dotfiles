local fnamemodify = vim.fn.fnamemodify

local M = {}

-- dir/file.suffix → suffix
function M.suffix(path)
    return fnamemodify(path, ':e')
end

function M.suffixes_match(one, two)
    return M.suffix(one) == M.suffix(two)
end

-- dir/file.suffix → file.suffix
function M.name(path)
    return fnamemodify(path, ":t")
end

-- dir/file.suffix → file
function M.stem(path)
    return fnamemodify(M.name(path), ":r")
end

function M.is_file(path)
    return vim.fn.filereadable(path) == 1
end

function M.is_dir(path)
    return vim.fn.isdirectory(path) == 1
end

function M.join(left, right)
    return left:gsub("/$", "", 1) .. '/' .. right:gsub("^/", "", 1)
end

function M.resolve(path)
    if path == '.' then
        path = vim.env.PWD
    else
        path = M.join(vim.env.PWD, path)
    end

    return path
end

return M
