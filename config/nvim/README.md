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
- goals.lua
- index.lua
    - calls `hnetext index --source {src} --dest {dest}` (probably shouldn't need a system command)
- journal.lua
    - calls `hnetext journal` (probably shouldn't need a system command)
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
- scratch.lua: implements scratching
- sync.lua: 
    - keeps within-buffer References up to date
    - calls `hnetext update-references` to update cross-file References

----------------------------------------
> [todo]()
----------------------------------------
- make constants into a lua file; have `hnetext` call something that converts that file into JSON and saves it
