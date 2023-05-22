A note is a file with yaml frontmatter and content.

#-------------------------------------------------------------------------------
# [types]()
#-------------------------------------------------------------------------------
- possible entry types:
  - `Journal`
  - `Goals`
  - `Log`

----------------------------------------
> [TopicSet]()
----------------------------------------
- dir structure:
  - `topic_set`:
    - `topic`:
      - `@.md`: statement
      - `*.md`: file
    - ...
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
> [PromptSet]()
----------------------------------------
- defaults:
  - `statement`:
    - fields:
      - open: [t/f]
    - filters:
      - open: true
  - `file`:
    - fields:
      - pinned: [f/t]

#-------------------------------------------------------------------------------
# [notes]()
#-------------------------------------------------------------------------------

=-----------------------------------------------------------
= [configs to make]()
=-----------------------------------------------------------
the-surface.notes:
    fields:
        topic: [...]
    notes:
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
            unknown:
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
