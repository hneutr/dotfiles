- should probably use [this plugin](https://github.com/Konfekt/FastFold) to make things faster

----------------------------------------
> [current behavior]()
----------------------------------------
- content between `{{{` and `}}}` is folded
- pros:
    - simple to implement
- cons:
    - adds extra lines
    - doesn't support everything I want it to

=-----------------------------------------------------------
= [ideal behavior]()
=-----------------------------------------------------------
- content is folded based on characteristics of the preceding lines
    - previous line is header
    - previous line is list item of a type: `?, ◻, ⋊`
    - previous line ends with `>`
- two fold types:
    - header based:
        - start: header A of size H
        - fold: lines between A and B
        - end: header B of size H
    - indent (triggered by list sigil/terminal):
        - start: line L is a `fold` type list item or ends in `>`
        - fold: lines X between L and M where `indent(X) > indent(L)`
        - end: line M where `indent(M) <= indent(L)`
- fold levels:
    - header:
        - big: 1
        - medium: 2
        - small: 3
    - indent based: start at 4, nested folds have parent + 1

=-----------------------------------------------------------
= [design]()
=-----------------------------------------------------------
- parse each line in the file:
    - check if the current_fold ends before the line (current_fold.end_before(line))
    - if current_fold.ends_before(line):
        - current_fold = current_fold.parent
    - line.fold_level = current_fold.level
    - if current_fold.fold_begins_after(line):
        - new_fold.parent = current_fold
        - current_fold = new_fold
- create a Fold object:
    - attributes:
        - fold_level: number
        - parent: fold that contains this fold
    - functions:
        - ends_before(line): returns true if the line is outside the current fold
        - fold_begins_after(line): returns true if the line starts a new fold
    - subclasses:
        - `OuterFold`: fold for the document itself
        - `HeaderFold`: fold for headers
            - subclasses:
                - BigHeader
                - MediumHeader
                - SmallHeader
        - `ListFold`: fold for list items

----------------------------------------

This involves an understanding of headers and lists in the document.
The logic required for this is in multiple places:
- lists:
    - lua/list/init.lua
    - lua/list/line_type.lua
- headers and dividers:
    - lua/snips/markdown.lua
