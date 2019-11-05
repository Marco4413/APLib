# General

Look at [Functions' Home](index.md#general) first.

These functions are **used to make easier doing "permanent" CraftOS's settings changes**.

### OSSettings.set

| argument | type               | info                    |
| -------- | ------------------ | ----------------------- |
| entry    | String             | The key of the setting  |
| value    | Any except for nil | The value of the string |

This function will set `value` to `entry` in CraftOS's settings and saves settings to [**OSSettings**](../read_only_variables/special.md#ossettings-table).settingsPath

### OSSettings.get

It's a copy of [**settings.get()**](http://www.computercraft.info/wiki/Settings.get)

### OSSettings.getNames

It's a copy of [**settings.getNames()**](http://www.computercraft.info/wiki/Settings.getNames)

### OSSettings.unset

| argument | type               | info                    |
| -------- | ------------------ | ----------------------- |
| entry    | String             | The key of the setting  |

This function will unset `entry` in CraftOS's settings and saves settings to [**OSSettings**](../read_only_variables/special.md#ossettings-table).settingsPath
