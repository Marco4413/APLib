# General

Look at [Functions' Home](index.md#general) first.

These functions are **used to manage monitors**.

## setMonitor

| argument    | type   | info                                                                                                                                                                                                                                          |
| ----------- | ------ | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| monitorName | String | The name of the monitor that you want to set [**globalMonitor**](../read_only_variables/monitor_management.md#globalmonitor-peripheral) and [**globalMonitorName**](../read_only_variables/monitor_management.md#globalmonitorname-string) to |

It Updates [**globalMonitor**](../read_only_variables/monitor_management.md#globalmonitor-peripheral), [**globalMonitorName**](../read_only_variables/monitor_management.md#globalmonitorname-string) and [**globalMonitorWidth & globalMonitorHeight**](../read_only_variables/monitor_management.md#globalmonitorwidth-globalmonitorheight-int) to the monitor you selected.

## getMonitorSize

Returns [**globalMonitorWidth, globalMonitorHeight**](../read_only_variables/monitor_management.md#globalmonitorwidth-globalmonitorheight-int)

## setMonitorGroup

| argument        | type  | info                                                                              |
| --------------- | ----- | --------------------------------------------------------------------------------- |
| monitorNameList | Array | It's an Array of monitor names that are going to be used to manage monitor groups |

Sets [**globalMonitorGroup**](../read_only_variables/monitor_management.md#globalmonitorgroup-table).list to `monitorNameList` and checks if monitor names are valid

## setMonitorGroupEnabled

| argument | type    | info                                                                                                                    |
| -------- | ------- | ----------------------------------------------------------------------------------------------------------------------- |
| bool     | Boolean | It sets to bool [**globalMonitorGroup**](../read_only_variables/monitor_management.md#globalmonitorgroup-table).enabled |

## resetMonitorGroup

Clears [**globalMonitorGroup**](../read_only_variables/monitor_management.md#globalmonitorgroup-table).list Table
