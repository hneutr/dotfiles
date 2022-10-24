#-------------------------------------------------------------------------------
# [misc todo]()
#-------------------------------------------------------------------------------
- idea:
  - instead of having mirrors be in directories, have mirrors be in a `.` file in the same directory as the file
    - eg, file named `dir/PATH`, meta mirror at `dir/.PATH.meta.md`

----------------------------------------
> [features]()
----------------------------------------
- create some method/place to store prose fragments, eg content about wildlife, hippos, Fennessez, etc
- view a mark's references
- make `mark-insert` respect capitalization (and capitalize character filenames)
  - define "labels" for locations (maybe in `.project`)
    - e.g., define a directory as "title case" (for example, the characters dir)
- define aliases for locations (maybe in `.project`)
  - e.g., have the reference to `context/groups/na-hiasciari-manach-dall.md` be `NHMD`
  - also support aliases/hardcoded strings for location labels
- remap `d` in markdown project files to `scratch text` instead of deleting
  - (clean blank lines too)
  - maybe just use autocmd event `TextYankPost`?
- `X` list item type, indicates rejections
  - command to move all `X` items into a rejections mirror (add a rejections mirror?)
~ visual mapping open fuzzy menu to turn selected text into a reference
- specify files to be ignored by indexes in `.project`
- normal mode mapping: grab word under cursor and open a fuzzy goto for it
  - if there is only one match, go to it immediately
- have a `start date` field in `.project`
- parse `goals` to show what you've been working on
- `lex.move`: support `dir to file`
  - put the content from each file in the directory into the destination file
- make `archive` command to move `PATH` to `.archive/PATH`
- open all `notes` mirrors for a given file
  - bind to "<leader>oN", always open in new tab

----------------------------------------
> [unit testing]()
----------------------------------------
- lex project framework:
  - create project
  - make file with content
    - marker
    - reference
    - header + content
  - make directory
  - check file:
    - existence
    - content
  - check directory:
    - existence
    - files
- `lex.move`
- `lex.link.Reference`
- `lex.mirror.MLocation:find_updates`
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
- open a file's mirrors
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
