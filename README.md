# dotfiles

These are my dotfiles. The goal is to make the execution of frequently-repeated actions as low.

These are my dotfiles. I try and set things up so that:

1. common operations are simple and easy to execute and hard to screw up
2. things rarely break
3. maintenence is rarely required
4. installation on a new computer is easy (there's a lot of work to do here)

In the code, I try to:

- be consistent
- use clear names
- don't abbreviate _within_ an implementation (abbreviations are good for shell interfaces)
- reinvent as few wheels as possible

I mostly use:

- nvim
- zsh
- kitty


## Todos:
- nvim:
    - make it so that <tab> in insert mode in md files indents when in a list and there are no other characters
        - same thing for <shift-tab>
- writing in nvim:
    - learn about 'spell'
        - how to add words
        - local projects (eg character names)
    - etymonline querying without leaving vim:
        1. query etymonline
        2. put results in floating window
    - make your own colorscheme
- zsh:
    - fix function loading so I can use 'settex' from within vim
    - fix `fvim` command so that it outputs last line to commandline for repetition
