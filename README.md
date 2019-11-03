![](./logo.png)

What does APLib mean? Well, it means "**All Purpose Library**". This is a library for [**Minecraft's Computercraft**]( https://computercraft.cc ) and that aims to make a lot of things much easier to do (like drawing on the screen or making GUIs).
I advise you to check the [**examples**](./examples) or [**the old attempt to a documentation**](./docs) while the new documentation is being made.

# Documentation INDEX

- [Documentation INDEX](#documentation-index)
- [Info [Table]](#info-table)
- [globalMonitor [Peripheral]](#globalmonitor-peripheral)
- [globalMonitorName [String]](#globalmonitorname-string)
- [globalMonitorGroup [Table]](#globalmonitorgroup-table)
- [globalMonitorWidth & globalMonitorHeight [Int]](#globalmonitorwidth--globalmonitorheight-int)
- [globalColor [Color]](#globalcolor-color)
- [globalTextColor [Color]](#globaltextcolor-color)
- [globalBackgroundTextColor [Color]](#globalbackgroundtextcolor-color)
- [globalRectangleType [Integer]](#globalrectangletype-integer)
- [globalLoop [Table]](#globalloop-table)
  - [globalLoop.stats [Table]](#globalloopstats-table)
  - [globalLoop.callbacks [Table]](#globalloopcallbacks-table)
  - [globalLoop.events [Table]](#globalloopevents-table)
  - [globalLoop.group [Table]](#globalloopgroup-table)
- [globalCallbacks [Table]](#globalcallbacks-table)
- [rectangleTypes [Table]](#rectangletypes-table)
- [event [Table]](#event-table)
- [stringSplit [Function]](#stringsplit-function)
- [tableHasKey [Function]](#tablehaskey-function)

# Info [Table]

| key     | type   | value                  |
| ------- | ------ | ---------------------- |
| ver     | String | Version of the lib     |
| author  | String | Author of the lib      |
| website | String | Github repo of the lib |

# globalMonitor [Peripheral]

It's the peripheral (monitor) that is currently used by the Library to draw things.

# globalMonitorName [String]

Holds the name of the globalMonitor.

If it's using the terminal it will be 'term', if it's using a monitor that is connected to the left it will be 'left' or if it's a monitor connected to a wired modem it will hold something like 'monitor_X' where X is a number.

# globalMonitorGroup [Table]



| key     | type    | value                                                        |
| ------- | ------- | ------------------------------------------------------------ |
| enabled | Boolean | Says if globalMonitorGroup is enabled                        |
| list    | Array   | Holds monitor names that are going to be used as globalMonitorGroup |

This table is used to hold monitor names and when its key 'enabled' is set to true, specific monitor group functions and the loop will draw or listen to events that come from them. "It's like a whitelist for monitors."

# globalMonitorWidth & globalMonitorHeight [Int]

They hold the width and the height of the current globalMonitor.

# globalColor [Color]

It holds the color that is going to be used for all shapes and for creating objects when some arguments aren't specified.

# globalTextColor [Color]

It holds the color that is going to be used for all texts.

# globalBackgroundTextColor [Color]

It holds the color that is going to be used for all texts' backgrounds.

# globalRectangleType [Integer]

It holds the type of rectangle that should be drawn.

# globalLoop [Table]

| key                   | type    | value                                                        |
| --------------------- | ------- | ------------------------------------------------------------ |
| enabled               | Boolean | Says if loop is enabled                                      |
| autoClear             | Boolean | Says to the loop if it should clear the screen before drawing |
| drawOnClock           | Boolean | Says if the loop should draw when the clock ticks or when the loop gets an event (Note: Timer is also an event) |
| clockSpeed            | Float   | How many seconds are between each clock tick                 |
| timerSpeed            | Float   | How many seconds are between each timer (Note: Timer can get out of sync if the loop gets other events, i recommend using the clock if you need to make something precise) |
| clock                 | Float   | Each time the clock ticks this gets updated to **os.clock()** |
| APLWDBroadcastOnClock | Boolean | Says if APLWD should broadcast on loop clock                 |
| APLWDClearCacheOnDraw | Boolean | Says if APLWD should clear its cache before the loop starts drawing again (Note: This should always be on or APLWD will get a lot slower when broadcasting) |
| stats                 | Table   | Table that holds info about stats counters                   |
| callbacks             | Table   | Table that holds loop callbacks                              |
| events                | Table   | Table that holds all specific events of the objects that are being looped  (For example: key event callbacks, ...) |
| wasGroupChanged       | Boolean | Says to the loop if it should update events table (The one above) |
| selectedGroup         | String  | Holds the name of the loop group that is currently being looped (Loop group is a table that holds every info needed to loop through a group of objects) |
| group                 | Table   | Table that holds loop groups                                 |

Holds all the settings that are going to be used for the loop.

## globalLoop.stats [Table]

| key                | type    | value                                                        |
| ------------------ | ------- | ------------------------------------------------------------ |
| automaticPos       | Boolean | Says if stats' pos should be calculated automatically (It draws them on the bottom right of the screen) |
| automaticPosOffset | Table   | {x=n, y=m} Holds the numbers that are going to be added to stats' pos when calculating it automatically (As it says it's an offset to the automatic pos) |
| FPS                | Label   | Label that has as its text the number of Frames per Second of the loop |
| EPS                | Label   | Label that has as its text the number of Events per Second of the loop |

## globalLoop.callbacks [Table]

| key             | type     | value                                                        |
| --------------- | -------- | ------------------------------------------------------------ |
| onInit          | Function | Called when loop function is called                          |
| onClock         | Function | Called every time the loop clock ticks                       |
| onEvent         | Function | Called every time the loop gets an event                     |
| onTimer         | Function | Called every time the loop gets a timer event                |
| onMonitorChange | Function | Called every time a function that draws on monitor group changes monitor |

## globalLoop.events [Table]

| key        | type  | value                                                        |
| ---------- | ----- | ------------------------------------------------------------ |
| tick       | Table | Holds object functions that should be called every tick (Tick being every time the loop gets an event) |
| key        | Table | Holds object functions that should be called every time the loop gets a key event |
| char       | Table | Holds object functions that should be called every time the loop gets a char event |
| mouse_drag | Table | Holds object functions that should be called every time the loop gets a mouse_drag event |

Note: All objects have an **update** function that isn't in this table... That's because i didn't think this lib would have become this large so i didn't rename it to **touch** so it's in every object because **there isn't a check if it's there or not**.

## globalLoop.group [Table]

| key        | type  | value                                                        |
| ---------- | ----- | ------------------------------------------------------------ |
| none       | Table | This group can't be changed and it's an empty one            |
| LIBPrivate | Table | This group can't be changed and it holds objects that are created by the lib (For example: FPS and EPS labels). This group is also always looped. |

This table holds every loop group that is created by the library or by the user. Loop groups also hold loop callbacks that are only used by that group.

# globalCallbacks [Table]

| key          | type     | value                                                        |
| ------------ | -------- | ------------------------------------------------------------ |
| onBClear     | Function | Function that gets called every time **bClear()** is used    |
| onSetMonitor | Function | Function that gets called every time **setMonitor()** is used |

# rectangleTypes [Table]

| key     | type    | value                                                        |
| ------- | ------- | ------------------------------------------------------------ |
| filled  | Integer | The number that [**globalRectangleType**](#globalrectangletype-integer) should be set to if you want a filled rectangle |
| hollow  | Integer | The number that [**globalRectangleType**](#globalrectangletype-integer) should be set to if you want a hollow rectangle |
| checker | Integer | The number that [**globalRectangleType**](#globalrectangletype-integer) should be set to if you want a checkerboard like rectangle |

# event [Table]

```lua
event = {
    global = {
        onBClear = 1,
        onSetMonitor = 2
    },
    clock = {
        onClock = 1
    },
    point = {
        onDraw = 1,
        onPress = 2,
        onFailedPress = 3
    },
    rectangle = {
        onDraw = 1,
        onPress = 2,
        onFailedPress = 3
    },
    header = {
        onDraw = 1,
        onPress = 2,
        onFailedPress = 3
    },
    label = {
        onDraw = 1,
        onPress = 2,
        onFailedPress = 3
    },
    button = {
        onDraw = 1,
        onPress = 2,
        onFailedPress = 3
    },
    menu = {
        onDraw = 1,
        onPress = 2,
        onFailedPress = 3,
        onButtonPress = 4,
        onFailedButtonPress = 5
    },
    percentagebar = {
        onDraw = 1,
        onPress = 2,
        onFailedPress = 3
    },
    memo = {
        onDraw = 1,
        onPress = 2,
        onFailedPress = 3,
        onEdit = 4,
        onCursorBlink = 5,
        onActivated = 6,
        onDeactivated = 7
    },
    window = {
        onDraw = 1,
        onPress = 2,
        onFailedPress = 3,
        onOBJPress = 4,
        onFailedOBJPress = 5,
        onEvent = 6
    },
    objGroup = {
        onDraw = 1,
        onOBJPress = 2,
        onFailedOBJPress = 3
    },
    loop = {
        group = {
            onClock = 1,
            onEvent = 2,
            onTimer = 3,
            onMonitorChange = 4,
            onSet = 5,
            onUnset = 6
        },
        onInit = 1,
        onClock = 2,
        onEvent = 3,
        onTimer = 4,
        onMonitorChange = 5
    }
}
```

Holds all the numbers that should be used with **set callback functions** to set the desired callback

# stringSplit [Function]

| argument  | type   | info                                  |
| --------- | ------ | ------------------------------------- |
| string    | String | The string that should be splitted    |
| separator | String | By what the string should be splitted |

Returns an Array of substrings that are splitted by the specified separator

# tableHasKey [Function]

**WIP**





















