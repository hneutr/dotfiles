This is where I'm going to keep information on all of the various `hnetxt` projects:
- `hnetxt-lua`: holds all code that is used by the other `hnetxt` repositories
- `hnetxt-cli`: command line interface
- `hnetxt-nvim`: nvim plugin

See `design` for details on particular components.

#-------------------------------------------------------------------------------
# [todo]()
#-------------------------------------------------------------------------------
- create some method/place for prose fragments (eg about wildlife, Fennessez, etc)
- find an alternative to hidden mirrors for important content (eg `questions`, `meta`)
- rename `on-writing` to `meta`

----------------------------------------
> [current goal]()
----------------------------------------
- finish migrations:
  - `lex.config` → `hnetxt-nvim.project`
  - remove `lex.constants`
  - `lex.move`
  - `lex.sync`
  - `hnetxt-nvim.text.location.update`: unit test
- move `hnetxt-cli` into `hnetxt-lua/src/hnetxt-cli` (put it in the same repository)
  - cmd: `list LIST_TYPE`: lists elements of the particular list type, eg `list todo`

=-----------------------------------------------------------
= [lua]()
=-----------------------------------------------------------
+ support references to links within mirrors

----------------------------------------
> [migrations]()
----------------------------------------
- `lex/config` → `project/init.lua`
- `lex/constants.lua` → `config.lua`
- `lex/move.lua` → `element/location.lua`

----------------------------------------
> [locations]()
----------------------------------------
- remove `.md` from path
- replace `FILE_DELIMITER` with some non-ascii character
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
> [migrations]()
----------------------------------------
- move `lex/sync.lua` → `project/sync.lua`

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
- cmd: list yaml files in dir by date field
- cmd: make yaml file with date field populated
- cmd: add way to have auto-dated "reflections", be able to list them, mark them as "solved"/"irrelevant"/etc
- cmd: `rm`: move `PATH` to `.archive/PATH`
- cmd: `dir-to-file`: put content from each file in the directory in the destination file

----------------------------------------
> [migrations]()
----------------------------------------
- `lex/move.lua` → `move`
- `python hnetext project set-metadata`
- `python hnetext project set-status`
- `python hnetext project show-by-status`
- `python hnetext project flags`
- `python hnetext words unknown`
- `python hnetext catalyze`
- `python hnetext session start`
