----------------------------------------
> [questions]()
----------------------------------------
- how do I go to a within file mark?

#-------------------------------------------------------------------------------
# [notes on usage]()
#-------------------------------------------------------------------------------
- some things I want in a different file (eg outlines)
- somethings I want inline, but hidden (eg ideas/questions/todos)

----------------------------------------
> [needs]()
----------------------------------------
- support for inline content of particular types (ideas/questions/todos)
- create some method/place to store prose fragments, eg content about wildlife, hippos, Fennessez, etc

#-------------------------------------------------------------------------------
# [misc todo]()
#-------------------------------------------------------------------------------
- idea:
  - instead of having mirrors be in directories, have mirrors be in a `.` file in the same directory as the file
    - eg, file named `dir/PATH`, meta mirror at `dir/.PATH.meta.md`
  - assume filetype is `md` for all files in a project and drop the extension `.md`
  - instead of question/todo mirrors, make more use of vim's `fold` feature

----------------------------------------
> [features]()
----------------------------------------
- view a mark's references
- make `mark-insert` respect capitalization (and capitalize character filenames)
- remap `d` in markdown project files to `scratch text` instead of deleting (clean blank lines too)
  ~ just use autocmd event `TextYankPost`?
- parse `goals` to show what you've been working on
- `lex.move`: support `dir to file`
  - put the content from each file in the directory into the destination file
- make `rm` command to move `PATH` to `.archive/PATH`

----------------------------------------
> [fuzzy]()
----------------------------------------
- normal mode mapping: grab word under cursor and open a fuzzy goto for it
  - if there is only one match, go to it immediately
- when fuzzy finding, have some way to open a particular mirror
  - eg by binding `<c-PREFIX>` to open up the PREFIX mirror of a given file
    - eg, `<c->` = open up the questions file
    - ideally support opening it up in edit/split/vsplit/tab

----------------------------------------
> [unit testing]()
----------------------------------------
- `lex.move`
- `lex.link.Reference`
- `lex.mirror:find_updates`
~ `lex.index`

----------------------------------------
> [refactors]()
----------------------------------------
- `lex.sync`:
  - make it work better with references
  - implement a better mechanism for turning it on/off than lex.g.lex_sync_ignore

----------------------------------------
> [questions]()
----------------------------------------
- make `mq` snippet: inserts a `?` list item with a date flag (`[](d=TODAY)`)
- implement way to view all questions by date/status (open/closed)

----------------------------------------
> [locations]()
----------------------------------------
- remove `.md` from paths in a location (to shorten them)
~ make links paths relative?
  - implementation:
    - if in same dir or child, start with: `./`
    - if above, specify full project path, don't start path with `./`
  ~ would make updating links harder (could just solve by "un-relativizing" them when after running rg/etc)
~ switch `FILE_DELIMITER` to some untypable non-ascii character
~ replace spaces with some invisible character?

----------------------------------------
> [projects]()
----------------------------------------
- define aliases/labels for locations (maybe in `.project`)
  - eg, have the reference to `context/groups/na-hiasciari-manach-dall.md` be `NHMD`
  - eg, define a directory as "title case" (for example, the characters dir)
  - also support aliases/hardcoded strings for location labels
- specify files to be ignored by indexes in `.project`
- have a `start date` field in `.project`

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
