function table.removekey(tbl, key)
    local element = tbl[key]
    tbl[key] = nil
    return element
end

table.vim = {}

function table.vim.check_scope(scope)
    local scopes = { 'g', 'b', 'w', 't' }
    return vim.tbl_contains(scopes, scope)
end

function table.vim._get(scope, name)
    local val 
    if table.vim.check_scope(scope) then
        val = vim.tbl_get(vim[scope], name) or {}
    end

    return val
end

function table.vim._set(scope, name, val)
    if table.vim.check_scope(scope) then
        vim[scope][name] = val
    end
end

function table.vim.get(scope, name, key)
    local tbl = table.vim._get(scope, name)

    local val
    if tbl then
        val = vim.tbl_get(key)
    end

    return val
end

function table.vim.set(scope, name, key, val)
    local tbl = table.vim._get(scope, name)

    if tbl then
        tbl[key] = val
        table.vim._set(scope, name, tbl)
    end
end

function table.vim.insert(scope, name, val)
    local tbl = table.vim._get(scope, name)

    if tbl then
        table.insert(tbl, val)
        table.vim._set(scope, name, tbl)
    end
end

function table.vim.remove(scope, name, val)
    local tbl = table.vim._get(scope, name)

    local val
    if tbl then
        val = table.remove(tbl, val)
        table.vim._set(scope, name, tbl)
    end

    return val
end

function table.vim.removekey(scope, name, key)
    local tbl = table.vim._get(scope, name)

    local val
    if tbl then
        val = table.removekey(tbl, key)
        table.vim._set(scope, name, tbl)
    end

    return val
end
