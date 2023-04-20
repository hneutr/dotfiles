function! hnetxt#foldtext() abort
	  return luaeval(printf('require"lex.fold".get_fold_text(%d)', v:foldstart - 1))
endfunction

function! hnetxt#foldexpr() abort
	return luaeval(printf('require"hnetxt-nvim.document.fold".get_indic(%d)', v:lnum))
endfunction
