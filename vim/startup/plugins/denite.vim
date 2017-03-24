"==========[ settings ]==========
call denite#custom#var('file_rec', 'command',
	\['ag', '--depth', '10', '--follow', '--nocolor', '--nogroup', '-g', ''])

call denite#custom#var('grep', 'command', ['ag'])
call denite#custom#var('grep', 'default_opts', ['-i', '--vimgrep'])
call denite#custom#var('grep', 'recursive_opts', [])
call denite#custom#var('grep', 'pattern_opt', [])
call denite#custom#var('grep', 'separator', ['--'])
call denite#custom#var('grep', 'final_opts', [])

" truth be told I have no idea what the differences between 'matcher_fuzzy' and
" 'matcher_cpsm' are
call denite#custom#source('file_rec', 'matchers', ['matcher_cpsm'])

"==========[ menus ]==========
let s:menus = {}
let s:menus.dotfiles = { 'description' : 'edit dotfiles' }
let s:menus.dotfiles.file_candidates = [
		\['vimrc', '~/.vimrc'],
		\['tmux', '~/.tmux.conf'],
		\['bash_profile', '~/.bash_profile'],
		\['bashrc', '~/.bashrc'],
		\['inputrc', '~/.inputrc'],
		\['readme', '~/dotfiles/readme.md'],
	\]

let s:menus.vim = { 'description' : 'edit vim configuration' }
let s:menus.vim.file_candidates = [
		\['vimrc', '~/.vimrc'],
		\['plugins', '~/.vim/startup/plugins.vim']
	\]

call denite#custom#var('menu', 'menus', s:menus)

"==========[ mappings ]==========
" denite commandline navigation
call denite#custom#map('insert', '<C-a>', '<denite:move_caret_to_head>', 'noremap')
call denite#custom#map('insert', '<C-n>', '<denite:move_to_next_line>', 'noremap')
call denite#custom#map('insert', '<C-p>', '<denite:move_to_previous_line>', 'noremap')

" denite splits
call denite#custom#map('insert', '<C-j>', '<denite:do_action:split>', 'noremap')
call denite#custom#map('insert', '<C-l>', '<denite:do_action:vsplit>', 'noremap')

" denite aliases
call denite#custom#alias('source', 'fr', 'file_rec')

call denite#custom#option('default', 'prompt', '>')
call denite#custom#option('default', 'auto_resize', 1)
call denite#custom#option('default', 'statusline', 0)

