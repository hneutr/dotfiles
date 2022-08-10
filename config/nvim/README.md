#-------------------------------------------------------------------------------
# [todo]()
#-------------------------------------------------------------------------------
- set up `lsp`?
- switch to `treesitter`?

----------------------------------------
> [vimscript --> lua]()
----------------------------------------
- fzf --> telescope/fzf-lua
- autoload/lib:
  - modifyLineEndDelimiter
  - foldDisplayText
  - showHelp
  - SaveAndRestoreVisualSelectionMarks
  - OpenFileSettings
  - setNumberDisplay
  - AddPluginMapping
  - setListenAddress
  - editWithoutNesting
  - TwoVerticalTerminals
  - KillBufferAndGoToNext
  - findNearestInstanceOfString
  - getTextInsideNearestParenthesis

#-------------------------------------------------------------------------------
# [unit testing]()
#-------------------------------------------------------------------------------
- util.lua
- lines.lua
- tbl.lua
- settings.lua (?)
- lex:
  - scratch.lua
  - map.lua
  - link.lua: reference, fuzzy
  - mirror.lua

#-------------------------------------------------------------------------------
# [lex]()
#-------------------------------------------------------------------------------

----------------------------------------
> [todo]()
----------------------------------------
- remove fluff:
    - normal-to-insert-mode-create-markers
    - `<leader>mf`/`<leader>mr` — fuzzy find is better
- improve loading of markdown files
- get rid of cursor blink when switching buffers
- trigger markdown autocmds appropriately
    - set up infrastructure to track "ran in buffer"
- move `lua/lines` into `lua/util/lines`
    - add `line` accessor (like `cursor`)
- convert `lib#getTextInsideNearestParenthesis` to lua
    - have it find nearest mark and return that mark's location
- implement:
    - link.Flagset
- refactor `lex.sync` so that it does references better
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
