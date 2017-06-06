# Statement:
This repository contains my dotfiles.

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
		- switch:
			- instead of vim --> nvim, nvim --> vim
	- plugins:
		- command/mappings to set source files based on filetypes
	- code:
		- fork 'jeffkreeftmeijer/vim-numbertoggle' and use its commands to work with writing
			- i.e. make it's autocommands into groups
	- writing:
		- learn about 'spell'
		- set 'writing' settings
		- make plugin for switching between code/prose+verse
		- turn off fold for md/txt
- tmux:
	- use tmux plugins?
		- namely tmux-resurrect?
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

# Notes/Thoughts

## Writing in vim
desire:
- frictionless switch between code/prose
	- ideally don't want to do anything (aka approach probably involves autocmds)
- want to separate settings for writing vs for code.
	- current organization is only in a single group, will need to split that out

idea:
- make something to effectively split vimrc in two for code/prose+verse:
	1. structured text
	2. unstructured text
- you can choose to either whitelist things or blacklist them?
	- choose a default of (1) or (2)
	- default has blacklist
	- non-default has whitelist

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
