This is where I'm going to keep information on all of the various `hnetxt` projects:
- `hnetxt-lua`: holds all code that is used by the other `hnetxt` repositories
- `hnetxt-nvim`: nvim plugin
- `hnetxt-cli`: command line interface

See `design` for details on particular components.

#-------------------------------------------------------------------------------
# [todo]()
#-------------------------------------------------------------------------------

=-----------------------------------------------------------
= [writing]()
=-----------------------------------------------------------
- create some method/place for prose fragments (eg about wildlife, Fennessez, etc)
- find an alternative to hidden mirrors for important content (eg `questions`, `meta`)
- create/add `structure` dir:
  - have notes on scenes in a yaml format
  - parse it & show things like character appearences, etc
  - mimic format I will be using in `TBOTNS` (make into a snippet):
    - locations
    - characters
    - information conveyed
    - events
    - background
    - explanations
    - todo
  - use this to annotate things in the scene to engage with at a later date:
    - "unsolved problem"
    - "detail to add"
    - "expound upon this"
    - "move this elsewhere"
- maybe have a place to put raw descriptions of things in a scene
  - associate it/navigate to it from `structure`?

----------------------------------------
> [current goal]()
----------------------------------------
- implement `entries`:
  - config:
    - EntryField
    - EntryValue
    - Entry
    - PromptEntry
    - ResponseEntry
    - ListEntry
  - commands:
    - `field`: rename, remove
    - `value`: rename, remove
    - `entry`: new, mv, rm, path, edit, set, flip
      - `prompt`: close, open, respond, response
      - `list`: path
      - `response`: path, paths, select, deselect
    - `list`: entries, fields

#-------------------------------------------------------------------------------
# [tech]()
#-------------------------------------------------------------------------------
- start using `Penlight` stuff
  - change things from `table.list_extend` to `List.extend`

=-----------------------------------------------------------
= [lua]()
=-----------------------------------------------------------
- idea: `facets` or `parallels` in addition to mirrors
  - eg:
    - `text/amnesis/ch1.md`
    - `meta/amnesis/ch1.md`
    - `story/outlines/amnesis/ch1.md`
    - `story/structure/amnesis/ch1.md`

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
- change `journal` and `goal` files to be by day (store in `yyyy/mm/dd.md`?)
  - cmd: view goals/journals by month/year/last x entries
  - involves parsing previous entries and splitting them up
- view a mark's references
- support file flags (store in a "file flags" file that lists all files in the project)
- mechanism to indicate "this mirror is only for files of type x" (eg `fragments` is only for `text`)

=-----------------------------------------------------------
= [cli]()
=-----------------------------------------------------------
- cmd: add way to have auto-dated "reflections", be able to list them, mark them as "solved"/"irrelevant"/etc
- cmd: `rm`: move `PATH` to `.archive/PATH`

----------------------------------------
> [yaml]()
----------------------------------------
- cmd: update a field/field value for all yaml files
- cmd: update a field/field value for a file

----------------------------------------
> [migrations]()
----------------------------------------
- `python hnetext project set-metadata`
- `python hnetext project set-status`
- `python hnetext project show-by-status`
- `python hnetext words unknown`
- `python hnetext catalyze`
- `python hnetext session start`

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
