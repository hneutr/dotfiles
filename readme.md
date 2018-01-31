# dotfiles
Repeated actions should be easy.
Be consistent.
Name things reasonably.
Don't reimplement something you don't want to turn into a personal project.

# Tools:
- nvim
- zsh
- kitty

## Todos:
- nvim:
    - do:
        - add in 'find to last in line' for f/F/t/T
    - learn:
        - matchpairs
        - text-objects
        - viminfo settings?
    - writing:
        - learn about 'spell'
            - how to add words
            - local to project (eg character names)
    - noodle on:
        - default vi bindings
            - and what can be changed from vim
            - i.e. q has a lot of open real estate
- zsh:
    - fix function loading so I can use 'settex' from within vim
    - fix `fvim` command so that it outputs last line to commandline for repetition
- meta:
    - make 'bootstrap.zsh' or something and get rid of dotbot because it's overkill

### terminal problems exploration
a running list of things that are annoying about not using tmux:
- inconsistent 'scrollback' behavior
    - problem:
        - __in vim__: "<esc>"/etc then movement keys.
        - __outside__: use the mouse
    - solution:
        - bind some keys in zsh to fix this?
- inconsistent "return to terminal" behavior
    - problem:
        - "<c-o>"
            - __in vim__: if a file was opened from a vim terminal, "<c-o>" will return you to the terminal
            - __outside__: "<c-o>" will do nothing
        - ":q"
            - __in vim__: if a file was opened from a vim terminal, ":q" will close the pane
            - __outside__: return you to the terminal
    - solution:
        - bind a key that will behave intelligently and stop using "<c-o>", which is not really intended for this purpose
            - i.e., on binding, perhaps "<c-q>":
                - vim:
                    - if there is only one pane/split/tab:
                        - quit
                    - otherwise:
                        - _maybe_:
                            - look through jump history
                            - if it contains a terminal buffer, pop out to the terminal buffer
                        - _maybe_:
                            - pop out to the terminal buffer
- context-aware $CWD
    - problem:
        - I'd usually like a new split/etc to open from the same directory as I'm currently in.
    - solution:
        - modify nvimux pane commands?
