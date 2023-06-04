This is where I'm going to keep information on all of the various `hnetxt` projects:
- `hnetxt-lua`: holds all code that is used by the other `hnetxt` repositories
- `hnetxt-nvim`: nvim plugin
- `hnetxt-cli`: command line interface

See `design` for details on particular components.

#-------------------------------------------------------------------------------
# [todo]()
#-------------------------------------------------------------------------------
~ maybe: allow for nested note sets/topics. use case: quotes: dir for author, dir for book: files = quotes
- support todos with priorities, fmt: ◻:1, ◻:2, ◻:...
- reorganize `hnetxt-cli` commands:
  - bare commands:
    - `journal` ← `journal touch`
    - `register` ← `project create` (add `-u` flag to unregister)
    - `note` ← `notes touch` (make `notes new` behavior default when no arguments)
  - groups:
    - `projects`: project cmds
    - `journals` ← `journal`
    - `notes`
    - `meta` ← `notes meta`
- cmd `goals`: `cd`: move to goals dir
- converter: `goals`
- converter: `quotes`
- converter: `words`

=-----------------------------------------------------------
= [the big clean]()
=-----------------------------------------------------------
- `text/catch-all` → ⨉
- `text/people` → notify + fold into `text/written/scraps/people`
- `text/quotes` → notify
- `text/words` → notify
- `text/years` → `text/mirror/goals`
- `text/written/ideas` → clean
- `text/written/scraps/phenomena` → `text/written/ideas/phenomena`
- `text/written/scraps/quips` → `text/written/ideas/quips`
- `text/written/reflections/on-my-life/future` → `text/written/mirror/future`
- `text/written/reflections/on-my-life/*` → `text/written/mirror/reflections`
- `text/written/reflections/thoughts` → notify → `text/written/mirror/thoughts`, as appropriate
- `text/written/meta/on-writing/goals` → migrate old goals
- `text/written/meta/on-writing/catalysts` → clean
- `text/written/meta/on-writing/processes` → `intentions` + clean
- `text/written/meta/on-writing/logs` → notify
- `text/written/meta/on-writing/reminders` → clean + split apart by topic?
- `text/written/meta/the-surface`: clean + fix config

=-----------------------------------------------------------
= [cli]()
=-----------------------------------------------------------
- cmd `goals`: list scopes
- cmd `goals`: change a scope across all goals
- cmd: `mv`: if source/destination outside the project, move normally
- cmd: `log`:
  - log things like:
    - words written
    - prose experiments
    - hours spent writing (start/stop)

----------------------------------------
> [migrations]()
----------------------------------------
- `python hnetext project set-status`
- `python hnetext project show-by-status`
- `python hnetext words unknown`
- `python hnetext catalyze`
- `python hnetext session start`

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

=-----------------------------------------------------------
= [lua]()
=-----------------------------------------------------------
- change `journal` and `goal` files to be by day (store in `yyyy/mm/dd.md`?)
  - cmd: view goals/journals by month/year/last x entries
  - involves parsing previous entries and splitting them up
- view a mark's references
- support file flags (store in a "file flags" file that lists all files in the project)
- mechanism to indicate "this mirror is only for files of type x" (eg `fragments` is only for `text`)
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
= [misc tech]()
=-----------------------------------------------------------
