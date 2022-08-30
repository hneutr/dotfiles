#-------------------------------------------------------------------------------
# [todo]()
#-------------------------------------------------------------------------------
- remap `d` in markdown project files to perform `scratch text`, rather than deleting it
  - (clean blank lines too)
   maybe just use autocmd event `TextYankPost`?
- `util.list`:
  - automatically renumber numbered lists
  - autolister: only add `- ` if it doesn't already exist
  - remap `J` so that it removes the list char if both current line and joined line are list items

----------------------------------------
> [todo]()
----------------------------------------
- unit test:
    - high priority:
        - `lex.move`
        - `lex.link.Reference`
        - `lex.mirror.MLocation:find_updates`
    - low priority:
        - `lex.index`
- implement `lex.link.Flagset`
- refactor `lex.sync` to be better with references
