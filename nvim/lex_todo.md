#-------------------------------------------------------------------------------
# [misc todo]()
#-------------------------------------------------------------------------------
- imp: visual mapping open fuzzy menu to turn selected text into a reference
- imp: specify files to be ignored by indexes in `.project`
- imp: view a mark's references
- imp: `X` list item type, indicates rejections
  - imp: command to move all `X` items into a rejections mirror
- imp: make `mark-insert` respect capitalization (and capitalize character filenames)
- imp: some method/place to store prose fragments, eg content about wildlife, hippos, Fennessez, etc
- BUG: render italics/bold in toggled list items
- BUG: fix `goals`: if file month-file doesn't exist, create one with the monthly/weekly/daily headers

----------------------------------------
> [locations]()
----------------------------------------
- switch `FILE_DELIMITER` to some untypable non-ascii character
- remove `.md` from paths in a location (to shorten them)
~ replace spaces with some invisible character?
~ make links paths relative?
  - implementation:
    - if in same dir or child, start with: `./`
    - if above, specify full project path, don't start path with `./`

----------------------------------------
> [questions]()
----------------------------------------
- change the list item style text color so that it emphasizes questions, rather than mutes them
- make `mq` snippet: inserts a `?` list item with a date flag (`[](d=TODAY)`)
- implement way to view all questions by date/status (open/closed)

#-------------------------------------------------------------------------------
# [mirrors]()
#-------------------------------------------------------------------------------
- clean up mirrors
  - `.chaff` (only for `text` files; could even put in `text/.chaff`)
      - `scratch`
      - `fragments`
  - `outlines` → `story/outlines`
    - `story/outlines/text.md` mirrors `text/text.md`
  - `meta`: (remove `meta` mirror)
    - structure 1:
      - `issues` with sections for:
        - `questions`
        - `todos`
      - `notes`
        - `style`
        - `ideas`
      - have `gotos` to each of these sections, and treat them as _marks_
    - structure 2:
      - `questions`
      - `todos`
      - `notes`

----------------------------------------
> [things to support]()
----------------------------------------
- view a file's mirrors (in a quickfixlist with `<c-j>/<c-l>` bound to open the item on the cursor's line)
- open a file's mirrors
- mechanism to indicate "this mirror is only for files of type x" (eg `fragments` is only for `text`)
- gather all content in `issues` and output list of todos

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
