# General

Look at [Functions' Home](index.md#general) first.

These functions are **used to set draw settings or draw on [globalMonitor](../read_only_variables/monitor_management.md#globalmonitor-peripheral)**.

## setRenderer

| argument | type | info                                                                                                   |
| -------- | ---- | ------------------------------------------------------------------------------------------------------ |
| type     | Int  | Should be picked from [**renderEngine**](../read_only_variables/constants.md#renderengine-table) table |

Sets the way that the library is going to draw things.

## bClear

It clears [**globalMonitor**](../read_only_variables/monitor_management.md#globalmonitor-peripheral)

## bClearMonitorGroup

It clears [**globalMonitor**](../read_only_variables/monitor_management.md#globalmonitor-peripheral) and [**globalMonitorGroup**](../read_only_variables/monitor_management.md#globalmonitorgroup-table)

## setColor

| argument | type                                                      | info                                                                                                   |
| -------- | --------------------------------------------------------- | ------------------------------------------------------------------------------------------------------ |
| color    | [**Color**](https://computercraft.info/wiki/Colors_(API)) | The color that [**globalColor**](../writeable_variables/drawing.md#globalcolor-color) should be set to |

By setting [**globalColor**](../writeable_variables/drawing.md#globalcolor-color) to `color` every shape ([**rectangles**](#rectangle), [**points**](#point), ...) that is going to be drawn after this function will use that color.

## setTextColor

| argument | type                                                      | info                                                                                                           |
| -------- | --------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------- |
| color    | [**Color**](https://computercraft.info/wiki/Colors_(API)) | The color that [**globalTextColor**](../writeable_variables/drawing.md#globaltextcolor-color) should be set to |

By setting [**globalTextColor**](../writeable_variables/drawing.md#globaltextcolor-color) to `color` every [**text**](#text) that is going to be written after this function will use that color.

## setBackgroundTextColor

| argument | type                                                      | info                                                                                                                               |
| -------- | --------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------- |
| color    | [**Color**](https://computercraft.info/wiki/Colors_(API)) | The color that [**globalBackgroundTextColor**](../writeable_variables/drawing.md#globalbackgroundtextcolor-color) should be set to |

By setting [**globalBackgroundTextColor**](../writeable_variables/drawing.md#globalbackgroundtextcolor-color) to `color` every [**text**](#text) that is going to be written after this function will have as its background that color.

## setBackground

| argument | type                                                      | info                                                                                                                                      |
| -------- | --------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------- |
| color    | [**Color**](https://computercraft.info/wiki/Colors_(API)) | The color that should be added to [**globalMonitor**](../read_only_variables/monitor_management.md#globalmonitor-peripheral)'s background |

This function sets [**globalMonitor**](../read_only_variables/monitor_management.md#globalmonitor-peripheral)'s background color to `color` and then does a [**bClear**](#bclear) on the [**globalMonitor**](../read_only_variables/monitor_management.md#globalmonitor-peripheral).

## setBackgroundMonitorGroup

| argument | type                                                      | info                                                                                                                                                                                                                                          |
| -------- | --------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| color    | [**Color**](https://computercraft.info/wiki/Colors_(API)) | The color that should be added to [**globalMonitor**](../read_only_variables/monitor_management.md#globalmonitor-peripheral) and [**globalMonitorGroup**](../read_only_variables/monitor_management.md#globalmonitorgroup-table)'s background |

The same as [**setBackground**](#setBackground) but it also does it to all monitors in [**globalMonitorGroup**](../read_only_variables/monitor_management.md#globalmonitorgroup-table).list

## setRectangleType

| argument | type                                                                          | info                                                                                                                           |
| -------- | ----------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------ |
| type     | [**RectangleType**](../read_only_variables/constants.md#rectangletypes-table) | The color that [**globalRectangleType**](../writeable_variables/drawing.md#globalrectangletype-rectangletype) should be set to |

By setting [**globalRectangleType**](../writeable_variables/drawing.md#globalrectangletype-rectangletype) to `type` every rectangle that is going to be drawn after this function will be of that type.

## text

| argument      | type    | info                                                                                                                                                                 |
| ------------- | ------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| x             | Int     | The x pos on [**globalMonitor**](../read_only_variables/monitor_management.md#globalmonitor-peripheral) where `text` should be written                               |
| y             | Int     | The y pos on [**globalMonitor**](../read_only_variables/monitor_management.md#globalmonitor-peripheral) where `text` should be written                               |
| text          | String  | The text that should be written on `x`, `y` of [**globalMonitor**](../read_only_variables/monitor_management.md#globalmonitor-peripheral)                            |
| transparentBG | Boolean | If set to true the text will have a transparent background (Works only with experimental [**renderEngine**](../read_only_variables/constants.md#renderengine-table)) |

Writes `text` at `x`, `y` on [**globalMonitor**](../read_only_variables/monitor_management.md#globalmonitor-peripheral) with text color [**globalTextColor**](../writeable_variables/drawing.md#globaltextcolor-color) and text's background color [**globalBackgroundTextColor**](../writeable_variables/drawing.md#globalbackgroundtextcolor-color).

## point

| argument | type   | info                                                                                                                                    |
| -------- | ------ | --------------------------------------------------------------------------------------------------------------------------------------- |
| x        | Int    | The x pos on [**globalMonitor**](../read_only_variables/monitor_management.md#globalmonitor-peripheral) where the point should be drawn |
| y        | Int    | The y pos on [**globalMonitor**](../read_only_variables/monitor_management.md#globalmonitor-peripheral) where the point should be drawn |

Draws a point at `x`, `y` on [**globalMonitor**](../read_only_variables/monitor_management.md#globalmonitor-peripheral) with color [**globalColor**](../writeable_variables/drawing.md#globalcolor-color).

## rectangle

| argument | type   | info                                                                                                                                                          |
| -------- | ------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| x1       | Int    | The starting x pos on [**globalMonitor**](../read_only_variables/monitor_management.md#globalmonitor-peripheral) where the rectangle should start to be drawn |
| y1       | Int    | The starting y pos on [**globalMonitor**](../read_only_variables/monitor_management.md#globalmonitor-peripheral) where the rectangle should start to be drawn |
| x2       | Int    | The ending x pos on [**globalMonitor**](../read_only_variables/monitor_management.md#globalmonitor-peripheral) where the rectangle should stop to be drawn    |
| y2       | Int    | The ending y pos on [**globalMonitor**](../read_only_variables/monitor_management.md#globalmonitor-peripheral) where the rectangle should stop to be drawn    |

Draws a rectangle with type [**globalRectangleType**](../writeable_variables/drawing.md#globalrectangletype-rectangletype) on [**globalMonitor**](../read_only_variables/monitor_management.md#globalmonitor-peripheral) from `x1`, `y1` to `x2`, `y2` with color [**globalColor**](../writeable_variables/drawing.md#globalcolor-color).
