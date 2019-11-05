# General

Look at [Read Only Variables' Home](index.md#general) first.

These variables say to the library **how loop should behave**.

## globalLoop [Table]

| key                   | type    | value                                                                                                                                                                      |
| --------------------- | ------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| enabled               | Boolean | Says if loop is enabled                                                                                                                                                    |
| autoClear             | Boolean | Says to the loop if it should clear the screen before drawing                                                                                                              |
| drawOnClock           | Boolean | Says if the loop should draw when the clock ticks or when the loop gets an event (Note: Timer is also an event)                                                            |
| clockSpeed            | Float   | How many seconds are between each clock tick                                                                                                                               |
| timerSpeed            | Float   | How many seconds are between each timer (Note: Timer can get out of sync if the loop gets other events, i recommend using the clock if you need to make something precise) |
| clock                 | Float   | Each time the clock ticks this gets updated to [**os.clock()**](http://www.computercraft.info/wiki/Os.clock)                                                               |
| APLWDBroadcastOnClock | Boolean | Says if APLWD should broadcast on loop clock                                                                                                                               |
| APLWDClearCacheOnDraw | Boolean | Says if APLWD should clear its cache before the loop starts drawing again (Note: This should always be on or APLWD will get a lot slower when broadcasting)                |
| stats                 | Table   | Table that holds info about stats counters                                                                                                                                 |
| callbacks             | Table   | Table that holds loop callbacks                                                                                                                                            |
| events                | Table   | Table that holds all specific events of the objects that are being looped  (For example: key event callbacks, ...)                                                         |
| wasGroupChanged       | Boolean | Says to the loop if it should update events table (The one above)                                                                                                          |
| selectedGroup         | String  | Holds the name of the loop group that is currently being looped (Loop group is a table that holds every info needed to loop through a group of objects)                    |
| group                 | Table   | Table that holds loop groups                                                                                                                                               |

Holds all the settings that are going to be used for the loop.

### globalLoop.callbacks [Table]

| key             | type     | value                                                                    |
| --------------- | -------- | ------------------------------------------------------------------------ |
| onInit          | Function | Called when loop function is called                                      |
| onClock         | Function | Called every time the loop clock ticks                                   |
| onEvent         | Function | Called every time the loop gets an event                                 |
| onTimer         | Function | Called every time the loop gets a timer event                            |
| onMonitorChange | Function | Called every time a function that draws on monitor group changes monitor |

### globalLoop.events [Table]

| key        | type  | value                                                                                                  |
| ---------- | ----- | ------------------------------------------------------------------------------------------------------ |
| tick       | Table | Holds object functions that should be called every tick (Tick being every time the loop gets an event) |
| key        | Table | Holds object functions that should be called every time the loop gets a key event                      |
| char       | Table | Holds object functions that should be called every time the loop gets a char event                     |
| mouse_drag | Table | Holds object functions that should be called every time the loop gets a mouse_drag event               |

Note: All objects have an **update** function that isn't in this table... That's because i didn't think this lib would have become this large so i didn't rename it to **touch** so it's in every object because **there isn't a check if it's there or not**.

### globalLoop.group [Table]

| key        | type  | value                                                                                                                                             |
| ---------- | ----- | ------------------------------------------------------------------------------------------------------------------------------------------------- |
| none       | Table | This group can't be changed and it's an empty one                                                                                                 |
| LIBPrivate | Table | This group can't be changed and it holds objects that are created by the lib (For example: FPS and EPS labels). This group is also always looped. |

This table holds every loop group that is created by the library or by the user. Loop groups also hold loop callbacks that are only used by that group when it's the active one.
