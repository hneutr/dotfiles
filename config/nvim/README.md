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
> [Design]()
----------------------------------------
- config.lua
    - finds project file
    - builds config
- goals.lua: opens a journal file
- index.lua: generates an index
- journal.lua: opens a journal file
- link.lua
    - path: shorten/expand
    - Link
    - Location
    - Mark
    - Reference
    - fuzzy finding
- list.lua: implements list-item toggling
- mirror.lua: 
    - MLocation
- opener.lua: maps file-open stuff
- scratch.lua: implements text-scratching
- sync.lua: 
    - keeps within-buffer References up to date
    - calls `hnetext update-references` to update cross-file References

----------------------------------------
> [how to implement pure-lua pmv/etc]()
----------------------------------------
- alias `mv` to `nvim --headless MOVE_COMMAND`
- finding mirrors:
    - make:
        - `OldLoc`: old location
        - `NewLoc`: new location
    - for each `mirror_type`:
        - make:
            - `OldMirror` = `OldLoc.get_location(mirror_type)`
            - `NewMirror` = `NewLoc.get_location(mirror_type)`
        - if `OldMirror` exists, add an update `{ old = OldMirror, new = NewMirror }`
    - repeat the above process for each `OldMirror` found, so that you are sure to get all of them
- move command:
    - moves mirrors/mirrors of mirrors
- update_references:
    - rg and find all references (use `lex.link.Reference.list`)
        - store as dict: { file = { line_number = str_with_reference } }
    - for each file with references:
        - for each line with a reference:
            - run gsub on the line for every reference to update
            - if the string changes, write it

----------------------------------------
> [todo]()
----------------------------------------
- make constants into a lua file; have `hnetext` call something that converts that file into JSON and saves it
