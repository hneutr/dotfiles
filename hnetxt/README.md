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
> [where to start]()
----------------------------------------
- implement `lua:project.in_project`
- implement `lua:element:mark.lua`

----------------------------------------
> [misc]()
----------------------------------------
- move `nvim/lua/list/list_type.list_types` into `dotfiles/hnetxt/constants/list.yaml`
- change `journal` files to be by day
  - cmd: view journals by month/year/last x entries
- view a mark's references
- support file flags (store in a "file flags" file that lists all files in the project)
- mechanism to indicate "this mirror is only for files of type x" (eg `fragments` is only for `text`)

=-----------------------------------------------------------
= [lua]()
=-----------------------------------------------------------
+ bug: Flag.list_all doesn't work
  - avoid `vim.fn.systemlist` ([see](https://stackoverflow.com/questions/9676113/lua-os-execute-return-value))
+ support references to links within mirrors

----------------------------------------
> [migrations]()
----------------------------------------
- `lex/link.Location` → `element/location.lua`
- `lex/link.Mark` → `element/mark.lua`
- `lex/link.reference` → `element/reference.lua`
- `lex/link.flag` → `element/flag.lua`
- `lex/config` → `project/init.lua`
- `lex/mirrors.lua` → `project/mirror.lua`
- `lex/journal.lua` → `project/journal.lua`
- `lex/goals.lua` → `goals.lua`
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

=-----------------------------------------------------------
= [nvim]()
=-----------------------------------------------------------

----------------------------------------
> [migrations]()
----------------------------------------
- move `lex/statusline.lua` → `ui`
- move `lex/opener.lua` → `ui`
- move `lex/scratch.lua` → `project/scratch.lua`
- move `lex/sync.lua` → `project/sync.lua`
- move `list/init.lua:Buffer` → `doc/init.lua:Document`
- move `list/line_type.lua` → `doc/element/list.lua`
- move `list/init.lua:autolist` → `doc/element/list.lua:List.continue`
- move `snip/markdown` → `doc/element` + `ui/snippet`

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
- cmd: `rm`: move `PATH` to `.archive/PATH`
- cmd: `dir-to-file`: put content from each file in the directory in the destination file

----------------------------------------
> [migrations]()
----------------------------------------
- `lex/move.lua` → `move`
- `python hnetext project start`
- `python hnetext project print-root`
- `python hnetext project set-metadata`
- `python hnetext project set-status`
- `python hnetext project show-by-status`
- `python hnetext project flags`
- `python hnetext words unknown`
- `python hnetext catalyze`
- `python hnetext session start`
