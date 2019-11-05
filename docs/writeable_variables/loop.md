# General

Look at [Writeable Variables' Home](index.md#general) first.
These variable say to the library **how loop should behave**.

### globalLoop.stats [Table]

| key                | type    | value                                                                                                                                                      |
| ------------------ | ------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------- |
| automaticPos       | Boolean | Says if stats' pos should be calculated automatically (It draws them on the bottom right of the screen)                                                    |
| automaticPosOffset | Table   | `{x=n, y=m}` Holds the numbers that are going to be added to stats' pos when calculating it automatically (As it says it's an offset to the automatic pos) |
| FPS                | Label   | Label that has as its text the number of Frames per Second of the loop                                                                                     |
| EPS                | Label   | Label that has as its text the number of Events per Second of the loop                                                                                     |
