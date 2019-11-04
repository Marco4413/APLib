# General

These variables **can only be changed through lib functions** or at least it's recommended to do that with lib functions. But one thing that you can do is reading them without any problem.

## Info [Table]

| key     | type   | value                  |
| ------- | ------ | ---------------------- |
| ver     | String | Version of the lib     |
| author  | String | Author of the lib      |
| website | String | Github repo of the lib |

## globalMonitor [Peripheral]

It's the peripheral (monitor) that is currently used by the Library to draw things.

## globalMonitorName [String]

Holds the name of the globalMonitor.

If it's using the terminal it will be 'term', if it's using a monitor that is connected to the left it will be 'left' or if it's a monitor connected to a wired modem it will hold something like 'monitor_X' where X is a number.

## globalMonitorGroup [Table]

| key     | type    | value                                                        |
| ------- | ------- | ------------------------------------------------------------ |
| enabled | Boolean | Says if globalMonitorGroup is enabled                        |
| list    | Array   | Holds monitor names that are going to be used as globalMonitorGroup |

This table is used to hold monitor names and when its key 'enabled' is set to true, [**specific monitor group functions**](functions.md#bclearmonitorgroup) and the loop will draw or listen to events that come from them. "It's like a whitelist for monitors."

## globalMonitorWidth & globalMonitorHeight [Int]

They hold the width and the height of the current globalMonitor.

## globalLoop [Table]

| key                   | type    | value                                                        |
| --------------------- | ------- | ------------------------------------------------------------ |
| enabled               | Boolean | Says if loop is enabled                                      |
| autoClear             | Boolean | Says to the loop if it should clear the screen before drawing |
| drawOnClock           | Boolean | Says if the loop should draw when the clock ticks or when the loop gets an event (Note: Timer is also an event) |
| clockSpeed            | Float   | How many seconds are between each clock tick                 |
| timerSpeed            | Float   | How many seconds are between each timer (Note: Timer can get out of sync if the loop gets other events, i recommend using the clock if you need to make something precise) |
| clock                 | Float   | Each time the clock ticks this gets updated to [**os.clock()**](http://www.computercraft.info/wiki/Os.clock) |
| APLWDBroadcastOnClock | Boolean | Says if APLWD should broadcast on loop clock                 |
| APLWDClearCacheOnDraw | Boolean | Says if APLWD should clear its cache before the loop starts drawing again (Note: This should always be on or APLWD will get a lot slower when broadcasting) |
| stats                 | Table   | Table that holds info about stats counters                   |
| callbacks             | Table   | Table that holds loop callbacks                              |
| events                | Table   | Table that holds all specific events of the objects that are being looped  (For example: key event callbacks, ...) |
| wasGroupChanged       | Boolean | Says to the loop if it should update events table (The one above) |
| selectedGroup         | String  | Holds the name of the loop group that is currently being looped (Loop group is a table that holds every info needed to loop through a group of objects) |
| group                 | Table   | Table that holds loop groups                                 |

Holds all the settings that are going to be used for the loop.

### globalLoop.callbacks [Table]

| key             | type     | value                                                        |
| --------------- | -------- | ------------------------------------------------------------ |
| onInit          | Function | Called when loop function is called                          |
| onClock         | Function | Called every time the loop clock ticks                       |
| onEvent         | Function | Called every time the loop gets an event                     |
| onTimer         | Function | Called every time the loop gets a timer event                |
| onMonitorChange | Function | Called every time a function that draws on monitor group changes monitor |

### globalLoop.events [Table]

| key        | type  | value                                                        |
| ---------- | ----- | ------------------------------------------------------------ |
| tick       | Table | Holds object functions that should be called every tick (Tick being every time the loop gets an event) |
| key        | Table | Holds object functions that should be called every time the loop gets a key event |
| char       | Table | Holds object functions that should be called every time the loop gets a char event |
| mouse_drag | Table | Holds object functions that should be called every time the loop gets a mouse_drag event |

Note: All objects have an **update** function that isn't in this table... That's because i didn't think this lib would have become this large so i didn't rename it to **touch** so it's in every object because **there isn't a check if it's there or not**.

### globalLoop.group [Table]

| key        | type  | value                                                        |
| ---------- | ----- | ------------------------------------------------------------ |
| none       | Table | This group can't be changed and it's an empty one            |
| LIBPrivate | Table | This group can't be changed and it holds objects that are created by the lib (For example: FPS and EPS labels). This group is also always looped. |

This table holds every loop group that is created by the library or by the user. Loop groups also hold loop callbacks that are only used by that group when it's the active one.

## globalCallbacks [Table]

| key          | type     | value                                                        |
| ------------ | -------- | ------------------------------------------------------------ |
| [**onBClear**](functions.md#bclear)     | Function | Function that gets called every time **bClear()** is used    |
| [**onSetMonitor**](functions.md#setmonitor) | Function | Function that gets called every time **setMonitor()** is used |

## rectangleTypes [Table]

| key     | type | value                                                        |
| ------- | ---- | ------------------------------------------------------------ |
| filled  | Int  | The number that [**globalRectangleType**](writeable_variables.md#globalrectangletype-int) should be set to if you want a filled rectangle |
| hollow  | Int  | The number that [**globalRectangleType**](writeable_variables.md#globalrectangletype-int) should be set to if you want a hollow rectangle |
| checker | Int  | The number that [**globalRectangleType**](writeable_variables.md#globalrectangletype-int) should be set to if you want a checkerboard like rectangle |

## event [Table]

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

## OSSettings [Table]

| key          | type     | value                                                        |
| ------------ | -------- | ------------------------------------------------------------ |
| settingsPath | String   | Says where the settings need to be saved to keep them on reboot (Default: "/.settings") |
| set          | Function | Does [**settings.set()**](http://www.computercraft.info/wiki/Settings.set) and also [**settings.save()**](http://www.computercraft.info/wiki/Settings.save) with path OSSettings.settingsPath |
| get          | Function | [**settings.get()**](http://www.computercraft.info/wiki/Settings.get) |
| getNames     | Function | [**settings.getNames()**](http://www.computercraft.info/wiki/Settings.getNames) |
| unset        | Function | Does [**settings.unset()**](http://www.computercraft.info/wiki/Settings.unset) and also [**settings.save()**](http://www.computercraft.info/wiki/Settings.save) with path OSSettings.settingsPath |

So I was tired of having to do [**settings.set**](http://www.computercraft.info/wiki/Settings.set) or [**settings.unset**](http://www.computercraft.info/wiki/Settings.unset) and [**settings.save**](http://www.computercraft.info/wiki/Settings.save) to make settings changes "permanent", so i've put them together in one function that has the same name but it's in this table

## APLWD [Table]

APLWD means "**All Purpose Lib Wireless Drawing**" Its a protocol that sends data via rednet.
It sends a table that contains every shape, **text**, [**bClear**](functions.md#bclear) or **background** that was drawn on the host computer to every receiver computer that is connected to it.

| key                        | type     | value                                                        |
| -------------------------- | -------- | ------------------------------------------------------------ |
| enabled                    | Boolean  | If set to true APLWD gets enabled                            |
| cacheWritable              | Boolean  | If set to true APLWD will start to store data in its cache   |
| clearOnDraw                | Boolean  | When using [**APLWD.drawCache()**](functions.md#aplwddrawcache) if set to true it will clear the screen before drawing cache |
| protocol                   | String   | The name of the protocol used to host a rednet connection (Do not change) |
| senderName                 | String   | The prefix of a sender (Do not change)                       |
| receiverName               | String   | The prefix of a receiver (Do not change)                     |
| isReceiver                 | Boolean  | If set to true then the computer is a receiver               |
| myName                     | String   | The name of the computer in the rednet network               |
| senderID                   | String   | The computer ID of the sender                                |
| modemName                  | String   | The name of the modem that is being used                     |
| cache                      | Table    | It holds everything that should be sended to the receivers to make them draw properly |
| enable                     | Function | Sets APLWD.enabled                                           |
| broadcastOnLoopClock       | Function | Sets [**globalLoop**](#globalLoop-Table).APLWDBroadcastOnClock to true |
| dontBroadcastOnLoopClock   | Function | Sets [**globalLoop**](#globalLoop-Table).APLWDBroadcastOnClock to false |
| enableClearCacheOnLoopDraw | Function | Sets APLWD.clearOnDraw                                       |
| host                       | Function | Creates a server where receivers can connect to receive data |
| connect                    | Function | Connects to an host to receive data                          |
| close                      | Function | Closes server or closes connection to server and turns of the modem |
| broadcastCache             | Function | Broadcasts its cache to all connected computers              |
| receiveCache               | Function | Waits until it receives data from host or times out if specified |
| drawCache                  | Function | Draws APLWD.cache                                            |
| clearCache                 | Function | Clears APLWD.cache                                           |
