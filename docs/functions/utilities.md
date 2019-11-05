# General

Look at [Functions' Home](index.md#general) first.

These functions are **utilities that help you to do normal stuff** (like table checking, ...).

## stringSplit

| argument  | type   | info                                  |
| --------- | ------ | ------------------------------------- |
| string    | String | The string that should be splitted    |
| separator | String | By what the string should be splitted |

Returns an Array of substrings that are splitted by the specified `separator`

## tableHasKey

| argument | type             | info                                         |
| -------- | ---------------- | -------------------------------------------- |
| table    | Table            | The table where you want  to search the key  |
| key      | String or Number | The key that you want to search in the table |

Returns false if the `table` doesn't have the `key`
Returns true and the value of the key if the `table` has the `key`

## tableHasValue

| argument | type  | info                                           |
| -------- | ----- | ---------------------------------------------- |
| table    | Table | The table where you want to search the value   |
| value    | Any   | The value that you want to search in the table |

Returns false if the `table` doesn't have the `value`
Returns true and the key of the value if the `table` has the `value`
