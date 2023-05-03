This is where I'm going to keep information on all of the various `hnetxt` projects:
- `hnetxt-lua`: holds all code that is used by the other `hnetxt` repositories
- `hnetxt-nvim`: nvim plugin
- `hnetxt-cli`: command line interface

See `design` for details on particular components.

#-------------------------------------------------------------------------------
# [todo]()
#-------------------------------------------------------------------------------
- create some method/place for prose fragments (eg about wildlife, Fennessez, etc)
- find an alternative to hidden mirrors for important content (eg `questions`, `meta`)

----------------------------------------
> [current goal]()
----------------------------------------
+ test: make sure `Reference` finds references in hidden files
- implement `wr` in `hnetxt-cli`

=-----------------------------------------------------------
= [lua]()
=-----------------------------------------------------------
+ support references to links within mirrors/hidden files

----------------------------------------
> [locations]()
----------------------------------------
- remove `.md` from path
- make paths relative
  - implementation:
    - if in same dir or child, start with: `./`
    - if above, specify full project path, don't start path with `./`

----------------------------------------
> [misc]()
----------------------------------------
- change `journal` files to be by day
  - cmd: view journals by month/year/last x entries
- view a mark's references
- support file flags (store in a "file flags" file that lists all files in the project)
- mechanism to indicate "this mirror is only for files of type x" (eg `fragments` is only for `text`)

=-----------------------------------------------------------
= [nvim]()
=-----------------------------------------------------------

----------------------------------------
> [flags]()
----------------------------------------
- ui: toggle flags mappings eg `<leader>fq` toggles a question flag on the line

----------------------------------------
> [mirrors]()
----------------------------------------
- ui: view a file's mirrors (in a quickfixlist with `<c-j>/<c-l>` bound to open the item on the cursor's line)
- ui: support opening particular mirrors when fuzzy finding
  - eg by binding `<c-PREFIX>` to open up the PREFIX mirror of a given file
    - eg, `<c->` = open up the questions file
    - ideally support opening it up in edit/split/vsplit/tab

=-----------------------------------------------------------
= [cli]()
=-----------------------------------------------------------
+ fix `wr` snippet, it currently calls `lex.mirror`
- move `hnetxt-cli` into `hnetxt-lua/src/hnetxt-cli` (put it in the same repository)
- cmd: `list LIST_TYPE`: lists elements of the particular list type, eg `list todo`
- cmd: list yaml files in dir by date field
- cmd: make yaml file with date field populated
- cmd: add way to have auto-dated "reflections", be able to list them, mark them as "solved"/"irrelevant"/etc
- cmd: `rm`: move `PATH` to `.archive/PATH`

----------------------------------------
> [migrations]()
----------------------------------------
- `python hnetext project set-metadata`
- `python hnetext project set-status`
- `python hnetext project show-by-status`
- `python hnetext project flags`
- `python hnetext words unknown`
- `python hnetext catalyze`
- `python hnetext session start`
