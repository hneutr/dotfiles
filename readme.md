# Statement:
This repository contains my dotfiles.

## Todos:
- all:
	- make it so that you can change the $SUFFIX seamlessly
- vim:
	- general:
		- add in 'find to last in line' for f/F/t/T
		- format .vimrc like andrewradev's because it's rad
		- think about the default vi bindings and what can be changed from vim
			- i.e. q has a lot of open real estate
		- learn about matchpairs
		- learn about ctrl-w
		- learn about more text-objects
		- possibly set viminfo settings?
		- autowrite/autowriteall not working? maybe because I use c-c to escape?
	- code:
	- writing:
		- set up plugin settings (goyo/pencil) 
		- set 'writing' settings
		- pencil fixes:
			- address that stupid unmapping of <cr> in insert in the middle of a paragraph
- tmux:
- bashrc:
	- add in yaml file for "this file should be sourced afterwards with this command" for conf function
- bash\_profile:
- inputrc:
	- learn more stuff
- fzf:
	- maybe set up tmux stuff for 's'/'g'?
	- maybe change 's' to 'svim' or something?
	- maybe change 'g' to 'cdf'?
- iterm2:
	- fix option/meta key problem
		- http://www.hackaddict.net/2007/07/skip-to-next-or-previous-word-in-iterm.html
		- also send +Esc

# Notes/Thoughts

## Writing in vim
desire:
- frictionless switch between code/prose
	- ideally don't want to do anything (aka approach probably involves autocmds)
- want to separate settings for writing vs for code.
	- current organization is only in a single group, will need to split that out
