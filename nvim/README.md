#-------------------------------------------------------------------------------
# [todo]()
#-------------------------------------------------------------------------------
- `util.list`:
  - automatically renumber numbered lists
  - autolister: only add `- ` if it doesn't already exist
  - remap `J` so that it removes the list char if both current line and joined line are list items
- `list` stuff:
  - add todo toggle mappings to non-project markdown files
    - (move this code out of `lex`)
  - `?` (question): change the text color to draw attention, rather fade
  - render italics/bold in non-standard colored list items
- have settings for terminal buffers
  - turn off `spell`
- tell `nvim-surround` to be less "smart" about quotes
  - I want them inserted even when the next char is a "surround" character
- prefix greek characters with `<M-g><char>`?
- command: load session file and then delete it
