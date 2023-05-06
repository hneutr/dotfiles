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
- shell:
  - move `zsh` and `bash` into `shell`
- init:
  - `fzf`
  - `pyenv`
    - `pyenv-virtualenv`
- zsh:
    - fix `fvim` command so that it outputs last line to commandline for repetition

----------------------------------------

notes on setting up a new computer:
- must fix zsh plugins
- copy over `~/.ssh/config`
- instead of having setup files in each directory, have a map file that maps files to their links
- restructure `nvim` so that plugin content isn't in `plugins` and we can actually bootstrap Packer on a new machine
