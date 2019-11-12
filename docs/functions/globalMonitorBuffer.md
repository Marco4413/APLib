# General

Look at [Functions' Home](index.md#general) first.<br>
These functions are **used to enable and make use of** [**globalMonitorBuffer**](../read_only_variables/special.md#globalmonitorbuffer-table).

### globalMonitorBuffer.clear

Clears [**globalMonitorBuffer.frames**](../read_only_variables/special.md#globalmonitorbufferframes-table).newFrame

### globalMonitorBuffer.write

| argument      | type                                                      | info                                                                                                                                                        |
| ------------- | --------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------- |
| x             | Int                                                       | The x pos on [**globalMonitorBuffer.frames**](../read_only_variables/special.md#globalmonitorbufferframes-table).newFrame where `text` should be written    |
| y             | Int                                                       | The y pos on [**globalMonitorBuffer.frames**](../read_only_variables/special.md#globalmonitorbufferframes-table).newFrame where `text` should be written    |
| text          | String                                                    | The text that should be written on `x`, `y` of [**globalMonitorBuffer.frames**](../read_only_variables/special.md#globalmonitorbufferframes-table).newFrame |
| fg            | [**Color**](https://computercraft.info/wiki/Colors_(API)) | The color of the text                                                                                                                                       |
| bg            | [**Color**](https://computercraft.info/wiki/Colors_(API)) | The background of the text (can be set to nil if `transparentBG` is set to true)                                                                            |
| transparentBG | Boolean                                                   | If the text should have transparent background                                                                                                              |

Writes `text` at `x`, `y` with color `fg` and background color `bg` or `transparentBG` on [**globalMonitorBuffer.frames**](../read_only_variables/special.md#globalmonitorbufferframes-table).newFrame.

### globalMonitorBuffer.draw

Draws [**globalMonitorBuffer.frames**](../read_only_variables/special.md#globalmonitorbufferframes-table).newFrame on [**globalMonitor**](../read_only_variables/monitor_management.md#globalmonitor-peripheral)
