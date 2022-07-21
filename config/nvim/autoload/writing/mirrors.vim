function s:getMirrorDefaults()
    if ! exists("s:mirrorDefaults")
        let s:mirrorDefaults = json_decode(readfile(fnameescape(g:mirrorDefaultsPath)))
    endif

    return s:mirrorDefaults
endfunction

function writing#mirrors#applyDefaultsToConfig(config)
    let config = a:config
    let defaults = s:getMirrorDefaults()

    if has_key(config, "mirrorsDirPrefix")
        let config['mirrorsDir'] = config['root'] . '/' . config['mirrorsDirPrefix']
    else
        let config['mirrorsDir'] = config['root']
    endif

    let mirrors = has_key(config, 'mirrors') ? config['mirrors'] : {}
    for [mirrorType, mirrorSettings] in items(defaults['mirrors'])
        let mirrorConfig = has_key(mirrors, mirrorType) ? mirrors[mirrorType] : {}

        for [key, value] in items(mirrorConfig)
            let mirrorSettings[key] = value
        endfor

        let mirrorSettings['dir'] = config['mirrorsDir'] . '/' . mirrorSettings['dirPrefix']

        let disable = has_key(mirrorSettings, "disable") ? mirrorSettings["disable"] : 0

        if ! disable
            let mirrors[mirrorType] = mirrorSettings
        endif
    endfor

    let config['mirrors'] = mirrors

    return config
endfunction

"=================================[ getMirror ]=================================
" gets the equivalent location of a file for a given prefix.
"
" defaults:
" - path: the current file
"
" For example, if: 
" - prefix = `scratch`
" - path = `./text/chapters/1.md` (where "." is the projectRoot)
"
" it will return `./scratch/text/chapters/1.md`
"===============================================================================
function writing#mirrors#getMirror(mirrorType, path=expand('%:p'))
    let config = writing#project#getConfig()
    return substitute(a:path, config['root'], config['mirrors'][a:mirrorType]['dir'], '')
endfunction

"=================================[ getSource ]=================================
" gets the "real" location of a file, one with a prefix. For example, the
" defaults:
" - path: the current file
"
" For example, if: 
" - prefix = `scratch`
" - path = `./scratch/text/chapters/1.md` (where "." is the projectRoot)
"
" it will return `./text/chapters/1.md`
"===============================================================================
function writing#mirrors#getSource(mirrorType, path=expand('%:p'))
    let config = writing#project#getConfig()
    return substitute(a:path, config['mirrors'][a:mirrorType]['dir'], config['root'], '')
endfunction


"=================================[ getOrigin ]=================================
" returns the path without any mirrors, even recursively
"===============================================================================
function writing#mirrors#getOrigin(path=expand('%:p'))
    let config = writing#project#getConfig()
    let mirrorDirPrefixes = []
    for mirrorSettings in values(config['mirrors'])
        call add(mirrorDirPrefixes, mirrorSettings['dirPrefix'])
    endfor

    let path = substitute(a:path, config['root'] . '/', '', '')

    while v:true
        let index = stridx(path, '/')

        if index == -1
            break
        endif

        let prefix = path[:index - 1]
        let suffix = path[index + 1:]

        if index(mirrorDirPrefixes, prefix) != -1
            let path = suffix
        else
            break
        endif
    endwhile

    return config['root'] . '/' . path
endfunction



function writing#mirrors#getMirrorType(path=expand('%:p'))
    let config = writing#project#getConfig()

    for [mirrorType, mirrorSettings] in items(config['mirrors'])
        if stridx(a:path, mirrorSettings['dir']) != -1
            return mirrorType
        endif
    endfor

    return ""
endfunction

function writing#mirrors#pathIsMirror(path=expand('%:p'))
    return len(writing#mirrors#getMirrorType(a:path)) ? v:true : v:false
endfunction

function writing#mirrors#pathHasMirrorOfType(mirrorType, path=expand('%:p'))
    let pathMirrorType = writing#mirrors#getMirrorType(a:path)

    if len(pathMirrorType)
    else
    endif
endfunction

"==================================[ getPath ]==================================
" takes a mirror type and a path.
"
" cases:
" - `path` != a mirror: return a `mirrorType` mirror of the `path`
" - `path` == a mirror:
"   - `mirrorType` == the mirror type of the `path`: return the source of the `path`
"   - `mirrorType` has `mirrorOtherMirrors` = True:
"       - `mirrorOtherMirrors` = True for the mirror type of the path:
"           - return the `mirrorType` mirror of the source of the `path`
"       - `mirrorOtherMirrors` = False for the mirror type of the path:
"           - return the `mirrorType` mirror of the `path`
"   - `mirrorType` has `mirrorOtherMirrors` = False:
"       - return the `mirrorType` mirror of the source of the `path`
"===============================================================================
function writing#mirrors#getPath(mirrorType, path=expand('%:p'))
    let pathMirrorType = writing#mirrors#getMirrorType(a:path)

    if len(pathMirrorType) == 0
        return writing#mirrors#getMirror(a:mirrorType, a:path)
    elseif pathMirrorType == a:mirrorType
        return writing#mirrors#getSource(a:mirrorType, a:path)
    else
        let config = writing#project#getConfig()

        if config['mirrors'][a:mirrorType]['mirrorOtherMirrors']
            if config['mirrors'][pathMirrorType]['mirrorOtherMirrors']
                return writing#mirrors#getMirror(a:mirrorType, writing#mirrors#getOrigin(a:path))
            else
                return writing#mirrors#getMirror(a:mirrorType, a:path)
            endif
        else
            return writing#mirrors#getMirror(a:mirrorType, writing#mirrors#getOrigin(a:path))
        endif
    endif
endfunction

function writing#mirrors#addMappings(config)
    for [mirrorType, mirrorSettings] in items(a:config['mirrors'])
        let path = writing#mirrors#getPath(mirrorType)
        let prefix = mirrorSettings['vimPrefix']
        let args = '"' . path . '"'

        call writing#map#mapPrefixedFileOpeners(prefix, "writing#project#openPath", args)
    endfor
endfunction
