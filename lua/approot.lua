return function(dir)
    local version = _VERSION:match("%d+%.%d+")

    package.path = dir .. 'lua_modules/share/lua/' .. version ..
        '/?.lua;lua_modules/share/lua/' .. version ..
        '/?/init.lua;' .. package.path
    package.cpath = dir .. 'lua_modules/lib/lua/' .. version ..
        '/?.so;' .. package.cpath
end
