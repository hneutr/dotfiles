"==========[ options ]==========
call denite#custom#option('default', 'prompt', '>')
call denite#custom#option('default', 'auto_resize', 1)
call denite#custom#option('default', 'statusline', 0)

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
		\['readme', '~/dotfiles/readme.md'],
		\['tmux', '~/.tmux.conf'],
		\['bash_profile', '~/.bash_profile'],
		\['bashrc', '~/.bashrc'],
		\['vimrc', '~/.vimrc'],
		\['inputrc', '~/.inputrc'],
	\]

call denite#custom#var('menu', 'menus', s:menus)

"==========[ mappings ]==========
" commandline navigation
call denite#custom#map('insert', '<c-d>', '<denite:delete_char_before_caret>', 'noremap')
call denite#custom#map('insert', '<c-a>', '<denite:move_caret_to_head>', 'noremap')
call denite#custom#map('insert', '<c-n>', '<denite:move_to_next_line>', 'noremap')
call denite#custom#map('insert', '<c-p>', '<denite:move_to_previous_line>', 'noremap')
call denite#custom#map('insert', '<c-f>', '<denite:scroll_page_forwards>', 'noremap')
call denite#custom#map('insert', '<c-b>', '<denite:scroll_page_backwards>', 'noremap')

" splits
call denite#custom#map('insert', '<c-j>', '<denite:do_action:split>', 'noremap')
call denite#custom#map('insert', '<c-l>', '<denite:do_action:vsplit>', 'noremap')

" aliases
call denite#custom#alias('source', 'fr', 'file_rec')

"==========[ mappings ]==========
nnoremap <leader>sdf :Denite file_rec<cr>
nnoremap <leader>sdm :Denite menu<cr>
nnoremap <leader>sdb :Denite buffer<cr>
