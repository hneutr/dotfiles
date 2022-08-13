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


#----------------------------------[ todos ]----------------------------------->
- zsh:
    - fix function loading so I can use 'settex' from within vim
    - fix `fvim` command so that it outputs last line to commandline for repetition
