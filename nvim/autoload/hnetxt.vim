function! hnetxt#foldtext() abort
	  return luaeval(printf('require"lex.fold".get_fold_text(%d)', v:foldstart - 1))
endfunction
