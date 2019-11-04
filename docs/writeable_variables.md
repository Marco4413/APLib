# General

These variables **can be changed as you like (except for tables, where you can only change values) as long as you don't change its type.**<br>Note: It's still recommended that you use functions where possible.

### globalLoop.stats [Table]

| key                | type    | value                                                        |
| ------------------ | ------- | ------------------------------------------------------------ |
| automaticPos       | Boolean | Says if stats' pos should be calculated automatically (It draws them on the bottom right of the screen) |
| automaticPosOffset | Table   | `{x=n, y=m}` Holds the numbers that are going to be added to stats' pos when calculating it automatically (As it says it's an offset to the automatic pos) |
| FPS                | Label   | Label that has as its text the number of Frames per Second of the loop |
| EPS                | Label   | Label that has as its text the number of Events per Second of the loop |

## globalColor [Color]

It holds the color that is going to be used for all shapes and for creating objects when some arguments aren't specified.

## globalTextColor [Color]

It holds the color that is going to be used for all texts.

## globalBackgroundTextColor [Color]

It holds the color that is going to be used for all texts' backgrounds.

## globalRectangleType [Int]

It holds the type of rectangle that should be drawn.
