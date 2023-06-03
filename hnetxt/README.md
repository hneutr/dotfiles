This is where I'm going to keep information on all of the various `hnetxt` projects:
- `hnetxt-lua`: holds all code that is used by the other `hnetxt` repositories
- `hnetxt-nvim`: nvim plugin
- `hnetxt-cli`: command line interface

See `design` for details on particular components.

#-------------------------------------------------------------------------------
# [todo]()
#-------------------------------------------------------------------------------
- fix: `the-surface` config
~ maybe: allow for nested note sets/topics. use case: quotes: dir for author, dir for book: files = quotes
- support todos with priorities, fmt: ◻:1, ◻:2, ◻:...
- new note_set type: `hl.notes.set.goal`:
  - goal types:
    - yearly: `YYYY.md`
    - monthly: `YYYYMM.md`
    - weekly: `YYYYMMDD-YYYYMMDD.md`
    - daily: `YYYYMMDD.md`
    - undated: `TEXT.md`
  - behavior:
    - prompt to:
      - create a yearly/monthly/weekly/daily goal when one doesn't exist
      - close out-of-range yearly/monthly/weekly/daily goals that have `◻` elements
  - cmds:
    - list scopes:
      - in: `{a:b:c, a:b:d, x:y}`
      - out: `{a = {b = {c, d}}, x = {y}}`
    - move scopes en mass
- make new `hl.notes.note.goal`:
  - a list of `◻`/`✓`/`⨉` items
    - items will be gathered by scope, levels marked by `:` content, eg:
      - `◻ a:b:x`: {scopes = {a, b, x}, start = date, end = date, succeeded = true/false}
  - statuses:
    - open: at least one `◻`
    - closed: zero `◻`'s
- make a new `hl.notes.note.undated_goal`: same as `hl.notes.note.goal` but with date/start/stop metadata

- new note_set type: `hl.notes.set.intention`:
  - able to list ALL intentions (across all projects) at once
  - intention metadata:
    - start/end (optional)
    - scope
    - scale: `yearly`/`monthly`/`weekly`/`daily`
  - can ingest all intentions and spit out new todo file at a given scale

=-----------------------------------------------------------
= [the big clean]()
=-----------------------------------------------------------
- `text/catch-all` → ⨉
- `text/people` → notify + fold into `text/written/scraps/people`
- `text/quotes` → notify (make old → new converter)
- `text/words` → notify (make old → new converter)
- `text/years` → `text/mirror/goals`
- `text/written/ideas` → clean
- `text/written/scraps/phenomena` → `text/written/ideas/phenomena`
- `text/written/scraps/quips` → `text/written/ideas/quips`
- `text/written/reflections/on-my-life/future` → `text/written/mirror/future`
- `text/written/reflections/on-my-life/*` → `text/written/mirror/reflections`
- `text/written/reflections/thoughts` → notify → `text/written/mirror/thoughts`, as appropriate
- `text/written/meta/on-writing/goals` → split into project specific goals (make old → new converter)
- `text/written/meta/on-writing/catalysts` → clean
- `text/written/meta/on-writing/processes` → `intentions` + clean
- `text/written/meta/on-writing/logs` → notify
- `text/written/meta/on-writing/reminders` → clean + split apart by topic?

=-----------------------------------------------------------
= [cli]()
=-----------------------------------------------------------
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
- start using `Penlight` stuff
  - change things from `table.list_extend` to `List.extend`
