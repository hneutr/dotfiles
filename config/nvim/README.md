#-------------------------------------------------------------------------------
# [todo]()
#-------------------------------------------------------------------------------
- set up `lsp`?
- switch to `treesitter`?
- fzf --> telescope/fzf-lua

----------------------------------------
> [vimscript --> lua]()
----------------------------------------
- autoload/lib:
  - foldDisplayText
  - SaveAndRestoreVisualSelectionMarks
  - OpenFileSettings
  - SetNumberDisplay
  - setListenAddress
  - editWithoutNesting
  - TwoVerticalTerminals

#-------------------------------------------------------------------------------
# [lex]()
#-------------------------------------------------------------------------------

----------------------------------------
> [todo]()
----------------------------------------
- unit test:
    - high priority:
        - move
        - link.Reference
        - mirror.MLocation:find_updates
    - low priority:
        - index
- maybe: clean up mirrors
    - have some way of saying "mirror only for files of type x"
        - eg, .fragments is only for `text`
    - store mirrors in different subdirs
        - `outlines` → `story/outlines`
        - `meta`: (remove `meta` mirror)
            - `questions`
            - `ideas`
            - rename `issues` → `todo`
            - `notes`
        - `.chaff`:
            - `scratch`
            - `fragments`
- implement:
    - link.Flagset
- refactor `lex.sync` to be better with references
