# General

Nothing to say... They're just functions that help you in some ways.

## stringSplit

| argument  | type   | info                                  |
| --------- | ------ | ------------------------------------- |
| string    | String | The string that should be splitted    |
| separator | String | By what the string should be splitted |

Returns an Array of substrings that are splitted by the specified separator

## tableHasKey

| argument | type             | info                                         |
| -------- | ---------------- | -------------------------------------------- |
| table    | Table            | The table where you want  to search the key  |
| key      | String or Number | The key that you want to search in the table |

Returns false if the table doesn't have the key
Returns true and the value of the key if the table has the key

## tableHasValue

| argument | type  | info                                           |
| -------- | ----- | ---------------------------------------------- |
| table    | Table | The table where you want to search the value   |
| value    | Any   | The value that you want to search in the table |

Returns false if the table doesn't have the value
Returns true and the key of the value if the table has the value

## setGlobalCallback

| argument | type     | info                                                         |
| -------- | -------- | ------------------------------------------------------------ |
| event    | Int      | The event that the callback should be binded to (Use [**event.global**](#event-table) Table) |
| callback | Function | The function that's going to be called when event is triggered |

Sets a callback to some global [**events**](read_only_variables.md#event-table)

## bClear

It clears [**globalMonitor**](read_only_variables.md#globalmonitor-peripheral)

## bClearMonitorGroup

It clears [**globalMonitor**](read_only_variables.md#globalmonitor-peripheral) and [**globalMonitorGroup**](read_only_variables.md#globalmonitorgroup-table)

## setMonitor

| argument    | type   | info                                                         |
| ----------- | ------ | ------------------------------------------------------------ |
| monitorName | String | The name of the monitor that you want to set [**globalMonitor**](read_only_variables.md#globalmonitor-peripheral) and [**globalMonitorName**](read_only_variables.md#globalmonitorname-string) to |

It Updates [**globalMonitor**](read_only_variables.md#globalmonitor-peripheral), [**globalMonitorName**](read_only_variables.md#globalmonitorname-string) and [**globalMonitorWidth & globalMonitorHeight**](read_only_variables.md#globalmonitorwidth-globalmonitorheight-int) to the monitor you selected.

## getMonitorSize

Returns [**globalMonitorWidth, globalMonitorHeight**](read_only_variables.md#globalmonitorwidth-globalmonitorheight-int)

## setMonitorGroup

| argument        | type  | info                                                         |
| --------------- | ----- | ------------------------------------------------------------ |
| monitorNameList | Array | It's an Array of monitor names that are going to be used to manage monitor groups |

Sets [**globalMonitorGroup**](read_only_variables.md#globalmonitorgroup-table).list to monitorNameList and checks if monitor names are valid

## setMonitorGroupEnabled

| argument | type    | info                                                         |
| -------- | ------- | ------------------------------------------------------------ |
| bool     | Boolean | It sets to bool [**globalMonitorGroup**](read_only_variables.md#globalmonitorgroup-table).enabled |

## resetMonitorGroup

Clears [**globalMonitorGroup**](read_only_variables.md#globalmonitorgroup-table).list Table

### APLWD.enable

WIP

### APLWD.broadcastOnLoopClock

WIP

### APLWD.dontBroadcastOnLoopClock

WIP

### APLWD.enableClearCacheOnLoopDraw

WIP

### APLWD.host

WIP

### APLWD.connect

WIP

### APLWD.close

WIP

### APLWD.broadcastCache

WIP

### APLWD.receiveCache

WIP

### APLWD.drawCache

WIP

### APLWD.clearCache

WIP
