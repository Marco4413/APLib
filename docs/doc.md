# Index

[TOC]

# Basics

**doc** revision: **1

## 1. Importing the Library

The **library must be loaded before doing anything with it**, obviously...
There are **2 ways** to do so.

### 1. The Simple way

There's a very **simple way** to import the API but it comes with a drawback:

```lua
os.loadAPI('path to the API') -- load API with CraftOS's built-in feature
```

The **drawback that this method has is that the Library must be in a specific path to be able to be loaded**, we could do something like this to make sure that the user knows what's the issue:

```lua
local APIPath = 'path to the API' -- create a variable which contains the path to the API
assert(
    fs.exists(APIPath),
    'APLib must be in this path: '..APIPath..'\nto be able to run this program'
) -- check if the API is in that path, if not return with an error
os.loadAPI(APIPath) -- load API with CraftOS's built-in feature
```

But it **still isn't fixed**.


### 2. The Advanced way

It's **not really advanced but it uses a feature that the API has, and that's the Library Setup!** **The user can setup the library by launching it with setup arg** (it still has a **drawback but it's less painful for the developer**):

![Library_Setup](assets\Chapter 1\Library_Setup.png)

**What the setup does** is making a **new entry on CraftOS Settings that's called 'APLibPath'** which **contains the path to the library** (**drawback**: when the **API is moved, setup must be redone**).
Here's the **code to open the library by using this cool feature**:

```lua
assert(  -- check if setup was done before, if not return with an error
    type(settings.get('APLibPath')) == 'string',
    "Couldn't open APLib through path: "..tostring(
        settings.get('APLibPath')
    )..";\n probably you haven't completed Lib setup\n via 'LIBFILE setup' or the setup failed"
)

assert( -- check if API is still there, if not return with an error
	fs.exists(settings.get('APLibPath')),
    "Couldn't open APLib through path: "..tostring(
    	settings.get('APLibPath')
    )..";\n remember that if you move the API's folder\n you must set it up again via 'LIBFILE setup'"
)
 
os.loadAPI(settings.get('APLibPath')) -- load API with CraftOS's built-in feature

```



## 2. Tables

**This API tries to help you keep your app working after API updates by giving you some tables** that are useful to use with some functions.

| table            | link                     |
| ---------------- | ------------------------ |
| *rectangleTypes* | [ref](#1-rectangletypes) |
| *event*          | [ref](#2-event)          |

A **useful table that you have to keep in mind is also the** [CraftOS's colors table](http://www.computercraft.info/wiki/Colors_(API))

### 1. rectangleTypes

**This table contains all types of rectangles that are available in the API** (to be used with setRectangleType function)

- *filled*
- *hollow*

### 2. event

**This table contains all events that are triggered by the API** (to be used with setCallback functions)

| type            | event                                                        |
| --------------- | ------------------------------------------------------------ |
| *global*        | **onInfo<br />onBClear<br />onSetMonitor**                   |
| *header*        | **onDraw<br />onPress**                                      |
| *label*         | **onDraw<br />onPress**                                      |
| *button*        | **onDraw<br />onPress**                                      |
| *menu*          | **onDraw<br />onPress<br />onButtonPress**                   |
| *percentagebar* | **onDraw<br />onPress**                                      |
| *memo*          | **onDraw<br />onPress<br />onEdit<br />onCursorBlink<br />onActivated<br />onDeactivated** |
| *loop*          | **onInit<br />onClock<br />onEvent<br />onTimer<br />onMonitorChange** |



## 3. Basic functions

Here i'll teach you **how to use basic functions** (nothing related to objects) that this API provides you with.

| function                 | args                           | return      | link                                       |
| ------------------------ | ------------------------------ | ----------- | ------------------------------------------ |
| *tableHas*               | **table**, **value**           | **boolean** | [ref](#1-tablehas-table-value)             |
| *setGlobalCallback*      | **event**, **callback**        | *nil*       | [ref](#2-setglobalcallback-event-callback) |
| *getInfo*                |                                | **table**   | [ref](#3-getinfo-)                         |
| *bClear*                 |                                | *nil*       | [ref](#4-bclear-)                          |
| *setColor*               | **color**                      | *nil*       | [ref](#5-setcolor-color)                   |
| *setTextColor*           | **color**                      | *nil*       | [ref](#6-settextcolor-color)               |
| *setBackgroundTextColor* | **color**                      | *nil*       | [ref](#7-setbackgroundtextcolor-color)     |
| *setBackground*          | **color**                      | *nil*       | [ref](#8-setbackground-color)              |
| *setRectangleType*       | **type**                       | *nil*       | [ref](#9-setrectangletype-type)            |
| *text*                   | **x**, **y**, **text**         | *nil*       | [ref](#10-text-x-y-text)                   |
| *point*                  | **x**, **y**                   | *nil*       | [ref](#11-point-x-y)                       |
| *rectangle*              | **x1**, **y1**, **x2**, **y2** | *nil*       | [ref](#12-rectangle-x1-y1-x2-y2)           |

### 1. tableHas (table, value)

This function explains itself very easily, it **searches in table if value exists and it return either true or false**.

![tableHas_example](assets\Chapter 3\tableHas_example.png)



### 2. setGlobalCallback (event, callback)

Very simple like the last one... **Takes an event from [*event.global*](#2-event) table and then calls *callback* when event was triggered**.
example:

```lua
-- API already loaded

APLib.setGlobalCallback(
    APLib.event.global.onInfo,
	function (info)
    	print('Infos were taken! '..tostring(info))
    end
)

APLib.getInfo()
```

![setGlobalCallback_example](assets\Chapter 3\setGlobalCallback_example.png)



### 3. getInfo ()

Very simple like the last two... It simply ***returns a table* which contains all infos that are stored in the API**.

![getInfo_example](assets\Chapter 3\getInfo_example.png)



### 4. bClear ()

bClear stands for 'Better Clear', it **clears the currently selected monitor and keeps its background color** that can be set with [setBackground](#8-setbackground-color) function.

![bClear_example#1](assets\Chapter 3\bClear_example_1.png)

![bClear_example#2](assets\Chapter 3\bClear_example_2.png)

![bClear_example#3](assets\Chapter 3\bClear_example_3.png)



### 5. setColor (color)

It *saves color to a variable* that's in the **API** so it **knows with which color it should draw shapes**.

![setColor_example](assets\Chapter 3\setColor_example.png)



### 6. setTextColor (color)

It *saves color to a variable* that's in the **API** so it **knows with which color it should write text**.

![setTextColor_example](assets\Chapter 3\setTextColor_example.png)



### 7. setBackgroundTextColor (color)

It *saves color to a variable* that's in the **API** so it **knows with which color it should draw the background of a text**.

![setBackgroundTextColor_example](assets\Chapter 3\setBackgroundTextColor_example.png)



### 8. setBackground (color)

As you saw earlier this function **changes the background color of the currently selected monitor and [bClears](#4-bclear-) it** *so that the monitor shows that color on the background*.

![setBackground_example#1](assets\Chapter 3\setBackground_example_1.png)

![setBackground_example#2](assets\Chapter 3\setBackground_example_2.png)



### 9. setRectangleType (type)

*Takes a type from [rectangleTypes](#1-rectangletypes) table and stores it in a variable that's in the API* so that the **API knows how to draw a rectangle** (the default stored type is 'filled').

```lua
-- API already loaded

APLib.setBackground(colors.green)
APLib.setColor(colors.blue)
APLib.setRectangleType(APLib.rectangleTypes.hollow)
APLib.rectangle(1, 19, 10, 9)
```

![setRectangleType_example](assets\Chapter 3\setRectangleType_example.png)



### 10. text (x, y, text)

Really simple... **writes text at *x*, *y***.

```lua
-- API already loaded

APLib.setBackground(colors.green)
APLib.setColor(colors.blue)
APLib.setRectangleType(APLib.rectangleTypes.hollow)
APLib.rectangle(1, 19, 10, 9)
APLib.setTextColor(colors.black)
APLib.setBackgroundTextColor(colors.blue)
APLib.text(1, 19, 'Hello World!')
```

![text_example](assets\Chapter 3\text_example.png)



### 11. point (x, y)

Simple as always! **Draws a point on *x*, *y***.

![point_example](assets\Chapter 3\point_example.png)



### 12. rectangle (x1, y1, x2, y2)

Last but not least... the RECTANGLE function, **draws a rectangle from *x1*, *y1* to *x2*, *y2***.

![rectangle_example](assets\Chapter 3\rectangle_example.png)



## 4. Creating your first object

If you're here it means that you know all the things previously explained.

### 1. Object types


