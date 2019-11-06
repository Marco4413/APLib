# General

Look at [Functions' Home](index.md#general) first.

These functions are **utilities that help you to do normal stuff** (like table checking, ...).

## stringSplit

| argument  | type   | info                                  |
| --------- | ------ | ------------------------------------- |
| string    | String | The string that should be splitted    |
| separator | String | By what the string should be splitted |

Returns an Array of substrings that are splitted by the specified `separator`.

## tableHasKey

| argument | type             | info                                         |
| -------- | ---------------- | -------------------------------------------- |
| table    | Table            | The table where you want  to search the key  |
| key      | String or Number | The key that you want to search in the table |

Returns false if the `table` doesn't have the `key`.<br>
Returns true and the value of the key if the `table` has the `key`.

## tableHasValue

| argument | type  | info                                           |
| -------- | ----- | ---------------------------------------------- |
| table    | Table | The table where you want to search the value   |
| value    | Any   | The value that you want to search in the table |

Returns false if the `table` doesn't have the `value`.<br>
Returns true and the key of the value if the `table` has the `value`.

## checkAreaPress

| argument | type | info                                                                                                                                                            |
| -------- | ---- | --------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| x1       | Int  | The starting x pos on [**globalMonitor**](../read_only_variables/monitor_management.md#globalmonitor-peripheral) where the area that needs to be checked starts |
| y1       | Int  | The starting y pos on [**globalMonitor**](../read_only_variables/monitor_management.md#globalmonitor-peripheral) where the area that needs to be checked starts |
| x2       | Int  | The ending x pos on [**globalMonitor**](../read_only_variables/monitor_management.md#globalmonitor-peripheral) where the area that needs to be checked ends     |
| y2       | Int  | The ending y pos on [**globalMonitor**](../read_only_variables/monitor_management.md#globalmonitor-peripheral) where the area that needs to be checked ends     |
| xPressed | Int  | The x pos that was pressed on [**globalMonitor**](../read_only_variables/monitor_management.md#globalmonitor-peripheral)                                        |
| yPressed | Int  | The y pos that was pressed on [**globalMonitor**](../read_only_variables/monitor_management.md#globalmonitor-peripheral)                                        |

Returns false if `xPressed`, `yPressed` wasn't in the specified area.<br>
Returns true if `xPressed`, `yPressed` was in the specified area.
