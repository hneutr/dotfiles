#-------------------------------------------------------------------------------
# [high priority]()
#-------------------------------------------------------------------------------
- `bug`: references to links within mirrors
- `feature`: flags
- `feature`: view all questions
- `feature`: hidden in-line/file content (eg questions); use vim folds
- `feature`: create some method/place for prose fragments (eg about wildlife, Fennessez, etc)
- `feature`: `dir-to-file`: put content from each file in the directory in the destination file
- `improvement`: remove `.md` from location paths

#-------------------------------------------------------------------------------
# [misc todo]()
#-------------------------------------------------------------------------------
- make `rm` command to move `PATH` to `.archive/PATH`
- view a mark's references

----------------------------------------
> [fuzzy]()
----------------------------------------
- support opening particular mirrors when fuzzy finding
  - eg by binding `<c-PREFIX>` to open up the PREFIX mirror of a given file
    - eg, `<c->` = open up the questions file
    - ideally support opening it up in edit/split/vsplit/tab

----------------------------------------
> [locations]()
----------------------------------------
- remove `.md` from paths
- replace spaces with some non-ascii character
- replace `FILE_DELIMITER` with some non-ascii character
- make paths relative
  - implementation:
    - if in same dir or child, start with: `./`
    - if above, specify full project path, don't start path with `./`
  ~ would make updating links harder (could just solve by "un-relativizing" them when after running rg/etc)

----------------------------------------
> [projects]()
----------------------------------------
~ define aliases/labels for locations (maybe in `.project`)
  ~ eg, have the reference to `context/groups/na-hiasciari-manach-dall.md` be `NHMD`
  ~ also support aliases/hardcoded strings for location labels
~ specify files to be ignored by indexes in `.project`

=-----------------------------------------------------------
= [implementation tasks]()
=-----------------------------------------------------------

----------------------------------------
> [unit test]()
----------------------------------------
- `lex.move`
- `lex.link.Reference`
- `lex.mirror:find_updates`
~ `lex.index`

----------------------------------------
> [refactor]()
----------------------------------------
- `lex.sync`:
  - make it work better with references
  - implement a better mechanism for turning it on/off than lex.g.lex_sync_ignore

#-------------------------------------------------------------------------------
# [flags]()
#-------------------------------------------------------------------------------
- mark/reference: `[mark]()[](flags)`, flagset = `[](flags)`
- file: `[name](path): flags` (stored in a "file flags" file that lists all files in the project)

----------------------------------------
> [things to support]()
----------------------------------------
- view things with a given flag
- view questions associated with a mark
- mechanism to associate a question with a mark
  - implementations:
    1. have questions file and have each question reference a mark
    2. put questions in some file, give them a mark with a non-ascii key, add that key to the mark's flagset

----------------------------------------
> [flag ideas]()
----------------------------------------
- `!` = important
- `*` = in progress (display visually in indexes)
- `?` = question (maybe)
  - `mq` snippet: inserts a `?` list item with a date flag (`[](d=TODAY)`)
- `+` = include in-file markers in the outline (when used within an outline)
- `d=YYYYMMDD` = date flag

#-------------------------------------------------------------------------------
# [mirrors]()
#-------------------------------------------------------------------------------

----------------------------------------
> [things to support]()
----------------------------------------
- view a file's mirrors (in a quickfixlist with `<c-j>/<c-l>` bound to open the item on the cursor's line)
- mechanism to indicate "this mirror is only for files of type x" (eg `fragments` is only for `text`)
- gather all content in `issues` and output list of todos

----------------------------------------
> [ideas]()
----------------------------------------
- instead of having mirrors be in directories, have mirrors be in a `.` file in the same directory as the file
  - eg, file named `dir/PATH`, meta mirror at `dir/.PATH.meta.md`

#-------------------------------------------------------------------------------
# [plans]()
#-------------------------------------------------------------------------------
- a plan is a file that contains only references
- types:
  - `sequence`: a list of references without a hierarchy
  - `tree`: a hierarchical set of references

----------------------------------------
> [tool: text-from-sequence]()
> type: commandline
----------------------------------------
- takes an outline
- stitches together the text in the references
- outputs a text file or pdf

----------------------------------------
> [tool: gather-trees]()
> type: commandline
----------------------------------------
1. gather `tree` files that reference each other into a single file
2. gather `tree` files of a given name into a single file
  - `tree` file name might be variable, eg:
      - `taxonomy.md` files in `the surface`
      - `sequence.md` files codifying an order of events (i.e. book- or chronological-order)
