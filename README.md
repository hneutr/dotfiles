# dotfiles
- make repeated actions easy
- be consistent
- use clear names
- don't abbreviate
- don't implement what you don't want to make into a project

# Tools:
- nvim
- zsh
- kitty

## Todos:
- nvim:
    - do:
        - make "left-operators" all inclusive
            - eg "dvb"
        - make it so that <tab> in insert mode in md files indents when in a list and there are no other characters
            - same thing for <shift-tab>
    - writing:
        - learn about 'spell'
            - how to add words
            - local to project (eg character names)
- zsh:
    - fix function loading so I can use 'settex' from within vim
    - fix `fvim` command so that it outputs last line to commandline for repetition

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
