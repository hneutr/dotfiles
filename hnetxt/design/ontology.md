... or simplify things wildly and just say on each "leaf":
- `some kind of descriptor`: `reference`

and then collect all references to a thing and group them by `some kind of descriptor`

eg, on `Andemne`, have metadata:
  ```
  is a: moon
  orbit: [Nebdul]()
  ```

this would produce on `Nebdul`:
```
  orbit:
    moon:
      - Andemne
```

or for subtypes of a species, on `agemite`:

```
  morph: [meron]()
```

this would produce on `meron`:
```
  morph:
    - agemite
```

#-------------------------------------------------------------------------------

- thing: an entity
- property: a characteristic of an thing
- relation: a connection between things
  - things(s)
  - a property
- state: a way things are
- event: an occurrence
  - components:
    - things(s)
    - a property
    - a temporal interval (a start and end)


----------------------------------------
> [examples]()
----------------------------------------
✓ locations:
✓ things:
✓ concepts:
✓ technologies:
✓ universals:

- phenomenon:

✓ species:
✓ groups:
✓ beings:

- events:

- states: 


#-------------------------------------------------------------------------------
# [phenomenon]()
#-------------------------------------------------------------------------------
`name`:
  subjects: `[thing, ...]`
  conditions: `[relation, ...]`
  results: `[relation, ...]`

#-------------------------------------------------------------------------------
# [event]()
#-------------------------------------------------------------------------------
`name`:
  things: `[thing, ...]`
  properties: `[property, ...]`
  start: `time`
  end: `time`

#-------------------------------------------------------------------------------
# [state]()
#-------------------------------------------------------------------------------
`time`:
  events: `[event, ...]`

#-------------------------------------------------------------------------------
# [concept]()
#-------------------------------------------------------------------------------
`name`:
  relations: `[relation, ...]`
  properties: `[property, ...]`
  subtypes:
    `technology`:
    `universal`:
    `phenomenon`:

#-------------------------------------------------------------------------------
# [thing]()
#-------------------------------------------------------------------------------
`name`:
  is a: `[concept, ...]`
  part of: `[group, ...]`
  relations: `[relation, ...]`
  properties: `[property, ...]`
  subtypes:
    `being`:
      is a: species?
    `location`:
      subtypes:
        `planet`:
          relations:
            orbit:
        `satellite`: 
          relations:
            orbit:
              anchor: planet?
          subtypes:
            `moon`:
            `orbital station`:
              properties:
                - constructed

#-------------------------------------------------------------------------------
# [group]()
#-------------------------------------------------------------------------------
`name`:
  singular: `how to refer to 1 element` (default: `member`)
  plural: `how to refer to >1 elements` (default: `members`)
  subgroup of: group? (optional)
  subtypes:
    `species`:
      properties:
      - biology:
      - life cycle:

#-------------------------------------------------------------------------------
# [relation]()
#-------------------------------------------------------------------------------
`name`:
  singular: `how to refer to 1 of the elements being annotated`
  plural: `how to refer to >1 the elements being annotated`
  some other thing: type of thing
  ...

=-----------------------------------------------------------

`orbit`:
  singular: `satellite`
  plural: `satellites`
  anchor: location?

#-------------------------------------------------------------------------------
# [property]()
#-------------------------------------------------------------------------------
`name`:

#-------------------------------------------------------------------------------

`meron`:
  singular: meron
  plural: merons
  is a: group.species

`agemite`:
  singular: agemite
  plural: agema
  is a: group
  subgroup of: meron

`monitor`:

`apolon`:

`interagent`:

`vegetang`:

`accretant`:
