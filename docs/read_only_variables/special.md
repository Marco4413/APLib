# General

Look at [Read Only Variables' Home](index.md#general) first.

These variables are **Tables that contain a lot of functions and that can be considered as different libraries for what they do**.

## globalCallbacks [Table]

| key                         | type     | value                                                                                                          |
| --------------------------- | -------- | -------------------------------------------------------------------------------------------------------------- |
| onBClear                    | Function | Function that gets called every time [**bClear()**](../functions/drawing.md#bclear) is used                    |
| onSetMonitor                | Function | Function that gets called every time [**setMonitor()**](../functions/monitor_management.md#setmonitor) is used |

## OSSettings [Table]

| key                                                           | type     | value                                                                                                                                                                                             |
| ------------------------------------------------------------- | -------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| settingsPath                                                  | String   | Says where the settings need to be saved to keep them on reboot (Default: "/.settings")                                                                                                           |
| [**set**](../functions/OSSettings.md#ossettingsset)           | Function | Does [**settings.set()**](http://www.computercraft.info/wiki/Settings.set) and also [**settings.save()**](http://www.computercraft.info/wiki/Settings.save) with path OSSettings.settingsPath     |
| [**get**](../functions/OSSettings.md#ossettingsget)           | Function | [**settings.get()**](http://www.computercraft.info/wiki/Settings.get)                                                                                                                             |
| [**getNames**](../functions/OSSettings.md#ossettingsgetnames) | Function | [**settings.getNames()**](http://www.computercraft.info/wiki/Settings.getNames)                                                                                                                   |
| [**unset**](../functions/OSSettings.md#ossettingsunset)       | Function | Does [**settings.unset()**](http://www.computercraft.info/wiki/Settings.unset) and also [**settings.save()**](http://www.computercraft.info/wiki/Settings.save) with path OSSettings.settingsPath |

So I was tired of having to do [**settings.set**](http://www.computercraft.info/wiki/Settings.set) or [**settings.unset**](http://www.computercraft.info/wiki/Settings.unset) and [**settings.save**](http://www.computercraft.info/wiki/Settings.save) to make settings changes "permanent", so i've put them together in one function that has the same name but it's in this table

## APLWD [Table]

APLWD means "**All Purpose Lib Wireless Drawing**" Its a protocol that sends data via rednet.
It sends a table that contains every shape, **text**, [**bClear**](../functions/drawing.md#bclear) or **background** that was drawn on the host computer to every receiver computer that is connected to it.

| key                                                                                     | type     | value                                                                                                                            |
| --------------------------------------------------------------------------------------- | -------- | -------------------------------------------------------------------------------------------------------------------------------- |
| enabled                                                                                 | Boolean  | If set to true APLWD gets enabled                                                                                                |
| cacheWritable                                                                           | Boolean  | If set to true APLWD will start to store data in its cache                                                                       |
| clearOnDraw                                                                             | Boolean  | When using [**APLWD.drawCache()**](../functions/APLWD.md#aplwddrawcache) if set to true it will clear the screen before drawing cache |
| protocol                                                                                | String   | The name of the protocol used to host a rednet connection (Do not change)                                                        |
| senderName                                                                              | String   | The prefix of a sender (Do not change)                                                                                           |
| receiverName                                                                            | String   | The prefix of a receiver (Do not change)                                                                                         |
| isReceiver                                                                              | Boolean  | If set to true then the computer is a receiver                                                                                   |
| myName                                                                                  | String   | The name of the computer in the rednet network                                                                                   |
| senderID                                                                                | String   | The computer ID of the sender                                                                                                    |
| modemName                                                                               | String   | The name of the modem that is being used                                                                                         |
| cache                                                                                   | Table    | It holds everything that should be sended to the receivers to make them draw properly                                            |
| [**enable**](../functions/APLWD.md#aplwdenable)                                         | Function | Sets APLWD.enabled                                                                                                               |
| [**broadcastOnLoopClock**](../functions/APLWD.md#aplwdbroadcastonloopclock)             | Function | Sets [**globalLoop**](../read_only_variables/loop.md#globalloop-table).APLWDBroadcastOnClock to true                             |
| [**dontBroadcastOnLoopClock**](../functions/APLWD.md#aplwddontbroadcastonloopclock)     | Function | Sets [**globalLoop**](../read_only_variables/loop.md#globalloop-table).APLWDBroadcastOnClock to false                            |
| [**enableClearCacheOnLoopDraw**](../functions/APLWD.md#aplwdenableclearcacheonloopdraw) | Function | Sets APLWD.clearOnDraw                                                                                                           |
| [**host**](../functions/APLWD.md#aplwdhost)                                             | Function | Creates a server where receivers can connect to receive data                                                                     |
| [**connect**](../functions/APLWD.md#aplwdconnect)                                       | Function | Connects to an host to receive data                                                                                              |
| [**close**](../functions/APLWD.md#aplwdclose)                                           | Function | Closes server or closes connection to server and turns of the modem                                                              |
| [**broadcastCache**](../functions/APLWD.md#aplwdbroadcastcache)                         | Function | Broadcasts its cache to all connected computers                                                                                  |
| [**receiveCache**](../functions/APLWD.md#aplwdreceivecache)                             | Function | Waits until it receives data from host or times out if specified                                                                 |
| [**drawCache**](../functions/APLWD.md#aplwddrawcache)                                   | Function | Draws APLWD.cache                                                                                                                |
| [**clearCache**](../functions/APLWD.md#aplwdclearcache)                                 | Function | Clears APLWD.cache                                                                                                               |
