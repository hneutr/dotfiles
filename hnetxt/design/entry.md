An entry is a file with metadata in a yaml frontmatter, followed by content.

#-------------------------------------------------------------------------------
# [commands]()
#-------------------------------------------------------------------------------
- things should be as seamless as possible
- define as few new commands as possible
- modify behavior of existing commands whenever possible
- make browsing entries easy
- avoid super-nesting of directories
- all commands _expect to be in the project_. all paths will be resolved.

=-----------------------------------------------------------
= [commands]()
=-----------------------------------------------------------
- `rm`:
  - args:
    - `-f --field`: remove field from entries
    - `-v --value`: remove field value from entries (format: `FIELD:VALUE`)
  - notes:
    - does not modify the entries config
- `mv`:
  - args:
    - `-f --field`: rename field in entries
    - `-v --value`: rename field value in entries (format: `FIELD:VALUE`)
  - notes:
    - does not modify the entries config
- `touch`: if new, create with metadata defaults
  - `-d --date [f/t]`: if true and `PATH` is null, create a file with today's date
- `vim`: `touch` and then edit
- `ls`: list notes if in a notes dir
  - args:
    - `-s --group-by-entry-set [t/f]`: group items by entry set
    - `-f --group-by-field FIELD`: group items by `FIELD` value
    - `-v --group-by-value [f/t]`: group entries by field value.
    - `-u --group-by-unexpected-value [t/f]`: like `-v` but exclude expected field values
    - `-V --list-values [f/t]`: list field values instead of entries.
    - `-U --list-unexpected-values [f/t]`: like `-V` but exclude expected field values
    - `-m --metadata FILTER`: filter entries by their metadata
      - `FILTER` format:
        - `FIELD=VAL`: require `metadata[FIELD] == VAL`
        - `FIELD` ≈ `FIELD=true` for boolean fields
        - `-FIELD` ≈ `FIELD=false` for boolean fields
    - `-M --no-default-metadata-filters [f/t]`: remove default metadata filters
    - `--sort-by-date [t/f]`: sort entries by date
    - `-p --show-entry-path [t/f]`: show entry path.
    - `-b --show-entry-blurb [f/t]`: show entry blurb instead of path. overrides `-p`.
    - `-d --show-entry-date [f/t]`: show entry date.
  - usage:
    - `ls`: list entries
    - `ls -f topic`: list entries by topic
    - `ls -m active`: list entries with `metadata.active == true`
    - `ls -v`: list entries by field value
    - `ls -u`: list entries unexpected field value
    - `ls -V`: list field values
    - `ls -U`: list unexpected field values

#-------------------------------------------------------------------------------
# [types]()
#-------------------------------------------------------------------------------

----------------------------------------
> [Entry]()
----------------------------------------
- a list of files
- dir structure:
  - `entry_set`:
    - `*.md` : file

----------------------------------------
> [TopicEntry]()
----------------------------------------
- inherit from: `Entry`
- a set of `topics`
- dir structure:
  - `topic_set`:
    - `topic`:
      - `@.md`: statement
      - `*.md`: file
    - ...
- cmd:
  - `ls`:
    - `topic_set`: list topics
    - `topic_set/topic`: list topic files
  - `touch`:
    - `topic_set/topic/@.md`: if new, create with default `statement` metadata
    - `topic_set/topic.md`: call `touch` with `topic_set/topic/@.md`
    - `topic_set/topic/file.md`: if new, create with default `file` metadata
    - `topic_set/topic/.`: call `touch` with `topic_set/topic/X.md`, where `X` is the lowest available number
- config structure:
  - `statement`:
    - fields
    - filters
  - `file`:
    - fields
    - filters
  - `topics`: define topic-specific statement/file defaults
    - TOPIC:
          `statement`
          `file`

----------------------------------------
> [QuestionEntry]()
----------------------------------------
- inherit from: `TopicEntry`
- a set of `questions`
- defaults:
  - `statement`:
    - fields:
      - open: [t/f]
    - filters:
      - open: true
  - `file`:
    - fields:
      - pinned: [f/t]
    - filters:
      - pinned: true

#-------------------------------------------------------------------------------
# [notes]()
#-------------------------------------------------------------------------------

=-----------------------------------------------------------
= [configs to make]()
=-----------------------------------------------------------
the-surface.notes:
    fields:
        topic: [...]
    entries:
        opinions:
        questions:
            type: question
        kinds: 
            fields:
                of: [sentence]
Documents.text.notes:
    words:
        type: topic
        topics:
            cool:
            created:
            unused:
                statement:
                    fields: [author, work]
    sentences:
        type: topic
        statement:
            fields: [author, work]
        file:
            fields: [page]
    quotes:
        type: topic
        statement:
            fields: [author, work]
        file:
            fields: [page]
