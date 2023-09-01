The goal is to do the following:
1. support cross-project references (ie remove the project-specificity of locations)
2. simplify the move/remove behavior by assigning everything a fixed id (based on a timestamp)
3. support _dynamic_ content, eg, have a way to see all of the moons of a given planet

=-------------------------------------------------------------------------------
# [todo]()
=-------------------------------------------------------------------------------
- initialize metadata for files/marks
  - populate with:
    - id
    - date (if the directory indicates)
- extension: `.hd`
- implement folding for file/mark metadata
- flatten directory structure such that:
  - projects can be identified dynamically (remove the `registration` process)
- support fuzzy search by project/etc, populating the items list with the label of the marker/file name, not the id

# MAYBE: put metadata in an id-named file and edit it via pop-up floating window?

=-------------------------------------------------------------------------------
# [implementation: filename = location]()
=-------------------------------------------------------------------------------

=---------------------------------------
> [to improve]()
=---------------------------------------
- creating entries:
  + putting them in specific places
  - support creating subfiles (populating `of`)
  - when creating a `section`: fill in the `of` field with the containing entry
    - this involves:
      1. parsing the entries within a file (along with their "size")
      2. finding the nearest "bigger" entry
  ~ maybe: support a file that defines metadata defaults for files created in the directory

=-----------------------------------------------------------
- paths:
  - [paths]():
    - `{uuid}.md`: 1 per uuid
    - `index`: all paths
  - [references]():
    - `{uuid}.md`: 1 per uuid
  - [titles]():
    - `{uuid}.md`: 1 per uuid
  - [relations]():
    - `{uuid}.md`: 1 per uuid

=---------------------------------------
> [on file modification]()
=---------------------------------------
- regenerate search content:
  1. save `/{of}.{is a}:title` to: [paths/{uuid}.md]()
  2. cat [paths/*.md]() into [paths/index]()
  3. update the cross-project index
- regenerate note references:
  1. make a list of references: 
    - lines in the metadata of the form `field: reference`
    - `misc` references in the body of a note
  2. save to: [references/{uuid}.md]()
- save the title to: [titles/{uuid}.md]()

=---------------------------------------
> [finding a note]()
=---------------------------------------
to reference:
  from `vim`: 
    1. fuzzy find over [paths/index]() (or the cross-project index)
    2. insert a reference to the selection
to open:
  from `vim`:
    1. fuzzy find over [paths/index]() (or the cross-project index)
    2. call the command to open the selection
  from `shell`:
    1. fuzzy find over [paths/index]() (or the cross-project index)
    2. open `vim` with a call to open the selection

=---------------------------------------
> [visualizing a note's references]()
=---------------------------------------
- how:
  1. search for references in [references/*.md]() (and the cross-project index)
  2. gather them into lists by field and invert the reference (swap referrer ←→ note)
  3. save to [relations/{uuid}.md]()
  3. open in `vim`
- use `vim`'s quickfixlist?

=---------------------------------------
> [moving/removing a note]()
=---------------------------------------
nothing special, do it manually? (maybe? has consequences for `.chaff/scratch`)

=-----------------------------------------------------------
= [usage]()
=-----------------------------------------------------------
- search syntax: `~project/{of}.{is a}:title`
  - `/{of}`: the label (if a location) in the `of` field
  - `.{is a}`: the label (if a location) in the `is a` field
  - `:title`: the title
  - `~project`: list locations in other projects

=---------------------------------------
> [metadata]()
=---------------------------------------
![title](location):
  is a: string
  of: [how.to.list.this](uuid)
  ...

=---------------------------------------
> [creating a note]()
=---------------------------------------
- as a `file`:
  - from `shell`: type `new`
  - from `vim`: `<leader>n(jlo)`
- as a `section`: snippet: `M`/`Mm`/`Mb`
