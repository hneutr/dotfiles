hne's dotfiles.

## tools
- os:
  - `macOS`: locally
    - `hammerspoon`: hotkey binding
    - `dozer`: menubar prettifying (`brew install --cask dozer`)
  - `linux`: remotely
- tty:
  - `kitty`: because it's great
- shell:
  - `zsh`: when available
  - `bash`: when `zsh` is unavailable
  - `fzf`: fuzzy finding
- editor: 
  - `nvim`: text editor + terminal management
- languages:
  - `python`:
    - `ipython`: better interactive interpreter
    - `matplotlib`: plotting
    - `pyenv`: python version management
    - `pyenv-virtualenv`: python virtual environment management that works with pyenv
  - `lua`:
    - `luarocks`
    - `nlua`

---

# todo
- instead of having setup files in each directory, have a map file that maps files to their links
- link kitty setup
- link luarocks setup
- zsh:
    - fix `fvim` command so that it outputs last line to commandline for repetition
- init: (these happen through brew)
  - brew:
    - `neovim`
    - `fzf`
    - `pyenv`
    - `pyenv-virtualenv`
    - `ripgrep`
    - `pandoc`
    - `libyaml`
    - `exa`
    - `tapianator/tap/bfs`

---

# structure

- a directory for a given tool has: 
  - `setup.sh`: what to run when setting up a new machine
    - it should:
      - download anything it needs
      - set up directories
  - `rc.sh`: what to run on shell creation
  - `extra`: a dir of other tool dirs which have the same structure

---

# philosophy

1. common operations should be easy to do and hard to screw up
2. stuff shouldn't break
3. it should be easy to install (there's a lot of work to do here)
