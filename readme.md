# dotfiles
Repeated actions should be easy.
Be consistent.
Name things reasonably.
Don't reimplement something you don't want to turn into a personal project.

# Tools:
- ag
- nvim
- tmux
- zsh

## Todos:
- all:
	- make it so that you can change the $SUFFIX seamlessly
	- figure out way to represent "things to do to migrate" for all things (eg iTerm2 option-->+Esc)
- conflicts:
	- would like to use <c-l>/<c-j> for panes from fzf in vim but can't because those are bound to movements
		- solutions:
			- change bindings for create new panes? use meta?
- ag:
	- set up actual ignorelist
- vim:
	- general:
		- undo useless (thought aesthetically attractive) splitting of vimrc.
			- can keep 'settings' split out, as that I only change rarely.
		- add in 'find to last in line' for f/F/t/T
		- think about the default vi bindings and what can be changed from vim
			- i.e. q has a lot of open real estate
		- learn about matchpairs
		- learn about more text-objects
		- possibly set viminfo settings?
		- autowrite/autowriteall not working? maybe because I use c-c to escape?
		- reformat conceal stuff from autocmd to ftplugin
	- plugins:
		- command/mappings to set source files based on filetypes
	- writing:
		- learn about 'spell'
			- how to add words
			- local to project (eg character names)
		- writing settings function:
			- make toggleable
- tmux:
	- use tmux plugins?
		- namely tmux-resurrect?
- bashrc:
	- add in yaml file for "this file should be sourced afterwards with this command" for conf function
- inputrc:
	- learn more stuff
- fzf:
- iterm2:
	- let <option>left/<option>right to move by word
- zsh:
	- migrate `conf` function from bashrc
	- add some tool plugins
		- git
		- pip
		- brew
		- tmux

# Notes/Thoughts

## Consistency Across The Terminal:
desire:
- tools which do similar things should behave similarly and have similar mappings

things to make consistent:
- 'commandline' interfaces:
	- "real" commandline
	- vim:
		- modes:
			- command mode
			- insert mode
		- plugins:
			- denite.vim
			- fzf.vim
- window management:
	- tmux
	- vim
	- denite.vim
	- fzf.vim

conflicts:
- c-j/c-l as pane management and directional keys
	- denite.vim
		- problem: there is a use for <c-j>/<c-k> as up/down
		- solution: use <c-n>/<c-p>?
