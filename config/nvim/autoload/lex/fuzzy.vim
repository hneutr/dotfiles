function lex#fuzzy#start(fn)
    let wrap = fzf#wrap({'source': luaeval("require'lex.marker'.location.list()")})
    let wrap['sink*'] = function(a:fn)
    let wrap['_action'] = {'ctrl-v': 'vsplit', 'ctrl-x': 'split', 'ctrl-t': 'tab split'}
    let wrap['options'] = ' +m -x --ansi --prompt "References: " --expect=ctrl-v,ctrl-x,ctrl-t'
    return fzf#run(wrap)
endfunction

function lex#fuzzy#goto(lines)
    call luaeval("require'lex.marker'.fuzzy.sink.goto(_A)", a:lines)
endfunction

function lex#fuzzy#put(lines)
    call luaeval("require'lex.marker'.fuzzy.sink.put(_A)", a:lines)
endfunction

function lex#fuzzy#insert_put(lines)
    call luaeval("require'lex.marker'.fuzzy.sink.insert_put(_A)", a:lines)
endfunction

