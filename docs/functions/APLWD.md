# General

Look at [Functions' Home](index.md#general) first.<br>
These functions are **used to enable and make use of APLWD**.

Note: [**Ender Modems**](http://www.computercraft.info/wiki/Ender_Modem) although they are useful, please try to not use them if you can or you could start to get latency on all receiving computers that have a [**Wireless Modem**](http://www.computercraft.info/wiki/Wireless_Modem) or an [**Ender Modem**](http://www.computercraft.info/wiki/Ender_Modem) and that are using [**APLWD**](../read_only_variables/special.md#aplwd-table).

### APLWD.enable

| argument | type    | info                                               |
| -------- | ------- | -------------------------------------------------- |
| bool     | Boolean | Says if you want to either enable or disable APLWD |

This function will set [**APLWD**](../read_only_variables/special.md#aplwd-table).enabled to `bool`

### APLWD.broadcastOnLoopClock

This function will set [**globalLoop**](../read_only_variables/loop.md#globalloop-table).APLWDBroadcastOnClock to true

### APLWD.dontBroadcastOnLoopClock

This function will set [**globalLoop**](../read_only_variables/loop.md#globalloop-table).APLWDBroadcastOnClock to false

### APLWD.enableClearCacheOnLoopDraw

| argument | type    | info                                               |
| -------- | ------- | -------------------------------------------------- |
| bool     | Boolean | Says if you want to either enable or disable APLWD |

This function will set [**globalLoop**](../read_only_variables/loop.md#globalloop-table).APLWDClearCacheOnDraw to `bool`

### APLWD.host

| argument  | type    | info                                                                                                                                                     |
| --------- | ------- | -------------------------------------------------------------------------------------------------------------------------------------------------------- |
| modemName | String  | The name of the modem that you want to use (or the side where it's located)                                                                              |
| hostname  | String  | The name that you want to give to the host computer.<br>(default: string([**os.getComputerID()**](http://www.computercraft.info/wiki/Os.getComputerID))) |

This function will host a rednet connection with [**APLWD**](../read_only_variables/special.md#aplwd-table).protocol as the protocol and `APLWD.senderName..hostname` as the hostname.

**Notes:**

* [**APLWD**](../read_only_variables/special.md#aplwd-table).myName will be updated by the function, and it shouldn't be an empty string anymore.
* If there's another computer that is hosting with name [**APLWD**](../read_only_variables/special.md#aplwd-table).myName the command will error your app after closing the modem.<br>So it's recommended to use IDs (the default value) if you're not making anything that requires a custom name.

### APLWD.connect

| argument   | type    | info                                                                                                                                                                                     |
| ---------- | ------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| modemName  | String  | The name of the modem that you want to use (or the side where it's located)                                                                                                              |
| senderName | String  | The name that you want to give to the receiving computer when connecting to an host.<br>(default: string([**os.getComputerID()**](http://www.computercraft.info/wiki/Os.getComputerID))) |
| hostname   | String  | The name of the host that you want to connect to.                                                                                                                                        |

This function will search in [**APLWD**](../read_only_variables/special.md#aplwd-table).protocol if there's a computer with hostname `APLWD.senderName..hostname`, if there is one then it will store that computer's id into [**APLWD**](../read_only_variables/special.md#aplwd-table).senderID (else it will error your app after closing the modem) then it will host  a rednet connection with [**APLWD**](../read_only_variables/special.md#aplwd-table).protocol as the protocol and `APLWD.receiverName..hostname` as the hostname.

**Notes:**

* [**APLWD**](../read_only_variables/special.md#aplwd-table).myName will be updated by the function, and it shouldn't be an empty string anymore.
* If there's another computer that is receiving with name [**APLWD**](../read_only_variables/special.md#aplwd-table).myName the command will error your app after closing the modem.<br>So it's recommended to use IDs (the default value) if you're not making anything that requires a custom name.

### APLWD.close

This function will unhost and close any rednet connection that was opened with [**APLWD**](../read_only_variables/special.md#aplwd-table) if it gives an error it may be because it couldn't store modem's name into [**APLWD**](../read_only_variables/special.md#aplwd-table).modemName

### APLWD.broadcastCache

This function will broadcast [**APLWD**](../read_only_variables/special.md#aplwd-table).cache to all computers connected with protocol [**APLWD**](../read_only_variables/special.md#aplwd-table).protocol

### APLWD.receiveCache

| argument | type  | info                                                                               |
| -------- | ----- | ---------------------------------------------------------------------------------- |
| timeout  | Float | Timeout of [**rednet.receive**](http://www.computercraft.info/wiki/Rednet.receive) |

This function will use [**rednet.receive**](http://www.computercraft.info/wiki/Rednet.receive) to get [**APLWD**](../read_only_variables/special.md#aplwd-table).cache from protocol [**APLWD**](../read_only_variables/special.md#aplwd-table).protocol and filter the message to see if it was received from Computer with ID [**APLWD**](../read_only_variables/special.md#aplwd-table).senderID if so it will be setted to [**APLWD**](../read_only_variables/special.md#aplwd-table).cache

### APLWD.drawCache

This function will use information from [**APLWD**](../read_only_variables/special.md#aplwd-table).cache to draw on the screen.

### APLWD.clearCache

This function will clear [**APLWD**](../read_only_variables/special.md#aplwd-table).cache Table.
