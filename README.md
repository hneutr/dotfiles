These are my dotfiles. Things are set up so that:

1. common operations are simple and easy to execute and hard to screw up
2. things rarely break
3. maintenence is rarely required
4. installation on a new computer is easy (there's a lot of work to do here)

## tools I use
- os:
  - `macOS`: locally
  - `linux`: remotely
- tty:
  - `kitty`: it's awesome
- shell:
  - `zsh`: when available
  - `bash`: when `zsh` is unavailable
- editor: 
  - `nvim`: text editor + terminal management

### other tools/etc
- os:
  - `macOS`:
    - `hammerspoon`: hotkey binding
    - `dozer`: menubar prettifying (`brew install --cask dozer`)
- shell:
  - `fzf`: fuzzy finding
- languages:
  - `python`:
    - `ipython`: better interactive interpreter
    - `matplotlib`: plotting
    - `pyenv`: python version management

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

# todo
- instead of having setup files in each directory, have a map file that maps files to their links
- nvim:
  - move plugin content out of `plugins` so that we can actually bootstrap Packer on a new machine
- shell:
  - move `zsh` and `bash` into `shell`
- zsh:
    - fix `fvim` command so that it outputs last line to commandline for repetition
- lua:
  - link `approot.lua` into `/opt/homebrew/share/lua/5.1/approot.lua`
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

----------------------------------------

notes on setting up a new computer:
- fix zsh plugins (maybe; maybe I don't actually want/need completion, it's nice having things so fast...)
- copy over `~/.ssh/config`
