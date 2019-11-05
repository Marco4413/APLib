# General

Look at [Functions' Home](index.md#general) first.

These functions are **used to set library callbacks**.

## setGlobalCallback

| argument | type     | info                                                                                                                            |
| -------- | -------- | ------------------------------------------------------------------------------------------------------------------------------- |
| event    | Int      | The event that the callback should be binded to (Use [**event.global**](../read_only_variables/constants.md#event-table) Table) |
| callback | Function | The function that's going to be called when event is triggered                                                                  |

Sets a callback to some global [**events**](../read_only_variables/constants.md#event-table)
