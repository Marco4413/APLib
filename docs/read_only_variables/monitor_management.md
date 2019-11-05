# General

Look at [Read Only Variables' Home](index.md#general) first.

These variables say to the library **how monitors should be managed**.

## globalMonitor [Peripheral]

It's the peripheral (monitor) that is currently used by the Library to draw things.

## globalMonitorName [String]

Holds the name of the globalMonitor.

If it's using the terminal it will be 'term', if it's using a monitor that is connected to the left it will be 'left' or if it's a monitor connected to a wired modem it will hold something like 'monitor_X' where X is a number.

## globalMonitorGroup [Table]

| key     | type    | value                                                               |
| ------- | ------- | ------------------------------------------------------------------- |
| enabled | Boolean | Says if globalMonitorGroup is enabled                               |
| list    | Array   | Holds monitor names that are going to be used as globalMonitorGroup |

This table is used to hold monitor names and when its key 'enabled' is set to true, [**specific monitor group functions**](../functions/drawing.md#bclearmonitorgroup) and the loop will draw or listen to events that come from them. "It's like a whitelist for monitors."

## globalMonitorWidth & globalMonitorHeight [Int]

They hold the width and the height of the current globalMonitor.