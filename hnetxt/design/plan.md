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
