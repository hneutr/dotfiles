An entry is a file with metadata in a yaml frontmatter, followed by content.

#-------------------------------------------------------------------------------
# [implementation]()
#-------------------------------------------------------------------------------
- config:
  - EntryField
  - EntryValue
  - Entry
  - PromptEntry
  - ListEntry
  - ResponseEntry

#-------------------------------------------------------------------------------
# [commands]()
#-------------------------------------------------------------------------------
- common params:
  * `-t --type`: entry type. inferred from the current dir if missing
  * `-f --field`: field to set a value for (repeatable: `-f FIELD1 -v VALUE1 -f FIELD2 -v VALUE2`)
  * `-v --value`: value of the field
- `field`:
    1. field
    * `-t`
  - `rename`: change a field's name
    2. new name
  - `remove`: remove a field
- `value`:
    1. field
    2. value
    * `-t`
  - `rename`: change a field's value
    3. new value
  - `remove`: remove a particular field value
- `entry`:
    1. entry name
    * `-t`
    * `-d --date`: date. default: today
    * `-r --response`: operate on a response. default: false
    * `-i --index`: index of the entry to operate on. default: 1
  ----------------------------------------
  - `new`: create + set field values
    * `-f`
    * `-v`
  - `mv`
  - `rm`
  - `path`: print the entry's path
  - `edit`: edit the entry
  - `set`: set field values
    * `-f`
    * `-v`
  - `flip`: flip a boolean field's value
    * `-f`
  ----------------------------------------
  for prompt entries:
  - `close`: close the prompt
  - `reopen`: open the prompt
  - `respond`: create and edit a new response
  - `response`: show the response(s) to the entry
    * `-a --all`: show all responses. default: false
    - if `-a` or there is no selected response: show all responses
    - else: show the selected response
  ----------------------------------------
  for response entries:
  - `select`: select the response
  - `unselect`: unselect the response
  - `paths`: print response paths
  ----------------------------------------
  for list entries:
  - `paths`: print list entry paths
- `list`: list elements
  1. element_type: what to list (`entries` or `fields`). default: `entries`
  * `-t`
  * `-f`: require a particular field
  * `-v`: require a particular field value
  * `--sort-by-date`: sort by date. default: true
  * `--by-field`: group by a field

----------------------------------------
> [prompt]()
----------------------------------------
- fields:
  - open: whether the prompt is open or not
    - values: [false, true]
    - default: true

----------------------------------------
> [response]()
----------------------------------------
- fields:
  - date:
  - selected: whether this is "the" response to the question. Only 1 response can be selected at a time.
    - values: [false, true]
      - true: this is the "response" to the question
    - default: false
- the path for a response is based on the date

----------------------------------------
> [list]()
----------------------------------------
- an list is a type of entry that may not have a unique path

#-------------------------------------------------------------------------------
# [config]()
#-------------------------------------------------------------------------------
- entry configs are stored in `.project`

=-----------------------------------------------------------
= [configs to make]()
=-----------------------------------------------------------
on-writing.entries:
    fields:
        active: true
        topic: [goals, meta, middle, outlining, prose, starting, work]
    entries:
        processes: (holds things currently in `things-to-do`)
            fields:
                task: [ideate, journal, log, plan]
                duration:
        catalysts:
        reminders:
        reflections:
            fields:
                topic: (remove the topic field)
            entries:
                prompts:
                    type: prompt
                    response_key: ".."
        techniques:
            fields: [source]
the-surface.entries:
    fields:
        topic: [...]
    entries:
        opinions:
        questions:
            type: prompt
            response_key: answers
        kinds: 
            fields:
                of: [sentence]
Documents.text.entries:
    entries:
        words:
            entries:
                cool:
                created:
                unknown:
                    type: list
                    fields: [author, work]
        sentences: 
            type: list
            fields: [author, work, page]
        quotes:
            type: list
            fields: [author, work, page]
