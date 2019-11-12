# General

Look at [Read Only Variables' Home](index.md#general) first.

These variables are **used to keep your app compatible with new versions of the library**.

## Info [Table]

| key     | type   | value                  |
| ------- | ------ | ---------------------- |
| ver     | String | Version of the lib     |
| author  | String | Author of the lib      |
| website | String | Github repo of the lib |

## renderEngine [Table]

| key          | type | value                                                                                                                                                        |
| ------------ | ---- | ------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| classic      | Int  | Classic render engine (no transparency and pixel manipulation with [**globalMonitorBuffer**](../read_only_variables/special.md#globalmonitorbuffer-table))   |
| experimental | Int  | Experimental render engine (transparency and pixel manipulation with [**globalMonitorBuffer**](../read_only_variables/special.md#globalmonitorbuffer-table)) |

To be used with function: [**setRenderer**](../functions/drawing.md#setrenderer)

## rectangleTypes [Table]

| key     | type | value                                                                                                                                                           |
| ------- | ---- | --------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| filled  | Int  | The number that [**globalRectangleType**](../writeable_variables/drawing.md#globalrectangletype-int) should be set to if you want a filled rectangle            |
| hollow  | Int  | The number that [**globalRectangleType**](../writeable_variables/drawing.md#globalrectangletype-int) should be set to if you want a hollow rectangle            |
| checker | Int  | The number that [**globalRectangleType**](../writeable_variables/drawing.md#globalrectangletype-int) should be set to if you want a checkerboard like rectangle |

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
        onStop = 2,
        onClock = 3,
        onEvent = 4,
        onTimer = 5,
        onMonitorChange = 6
    }
}
```

Holds all the numbers that should be used with **set callback functions** to set the desired callback
