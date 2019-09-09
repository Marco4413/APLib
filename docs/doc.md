# Index

[TOC]

# Basics

**doc** revision: **2**

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

![Library_Setup](assets\Chapter_1\Library_Setup.png)

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

![tableHas_example](assets\Chapter_3\tableHas_example.png)



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

![setGlobalCallback_example](assets\Chapter_3\setGlobalCallback_example.png)



### 3. getInfo ()

Very simple like the last two... It simply ***returns a table* which contains all infos that are stored in the API**.

![getInfo_example](assets\Chapter_3\getInfo_example.png)



### 4. bClear ()

bClear stands for 'Better Clear', it **clears the currently selected monitor and keeps its background color** that can be set with [setBackground](#8-setbackground-color) function.

![bClear_example#1](assets\Chapter_3\bClear_example_1.png)

![bClear_example#2](assets\Chapter_3\bClear_example_2.png)

![bClear_example#3](assets\Chapter_3\bClear_example_3.png)



### 5. setColor (color)

It *saves color to a variable* that's in the **API** so it **knows with which color it should draw shapes**.

![setColor_example](assets\Chapter_3\setColor_example.png)



### 6. setTextColor (color)

It *saves color to a variable* that's in the **API** so it **knows with which color it should write text**.

![setTextColor_example](assets\Chapter_3\setTextColor_example.png)



### 7. setBackgroundTextColor (color)

It *saves color to a variable* that's in the **API** so it **knows with which color it should draw the background of a text**.

![setBackgroundTextColor_example](assets\Chapter_3\setBackgroundTextColor_example.png)



### 8. setBackground (color)

As you saw earlier this function **changes the background color of the currently selected monitor and [bClears](#4-bclear-) it** *so that the monitor shows that color on the background*.

![setBackground_example#1](assets\Chapter_3\setBackground_example_1.png)

![setBackground_example#2](assets\Chapter_3\setBackground_example_2.png)



### 9. setRectangleType (type)

*Takes a type from [rectangleTypes](#1-rectangletypes) table and stores it in a variable that's in the API* so that the **API knows how to draw a rectangle** (the default stored type is 'filled').

```lua
-- API already loaded

APLib.setBackground(colors.green)
APLib.setColor(colors.blue)
APLib.setRectangleType(APLib.rectangleTypes.hollow)
APLib.rectangle(1, 19, 10, 9)
```

![setRectangleType_example](assets\Chapter_3\setRectangleType_example.png)



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

![text_example](assets\Chapter_3\text_example.png)



### 11. point (x, y)

Simple as always! **Draws a point on *x*, *y***.

![point_example](assets\Chapter_3\point_example.png)



### 12. rectangle (x1, y1, x2, y2)

Last but not least... the RECTANGLE function, **draws a rectangle from *x1*, *y1* to *x2*, *y2***.

![rectangle_example](assets\Chapter_3\rectangle_example.png)



## 4. Objects

If you're here it means that **you know all the things previously explained**.
*NOTE: Every code example should be located in the [assets folder for this chapter](assets/Chapter_4/examples).*
So, to start off this chapter i'm going to **make you aware of all the types of objects** that this API provides you with.

### 1. Object types

| type            | desc                                           | link             |
| --------------- | ---------------------------------------------- | ---------------- |
| *Header*        | *[Label](#6-label) but centered on the x axis* | [ref](#5-header) |
| *Label*         | *[Text](#10-text-x-y-text) as object*          | [ref](#6-label)  |
| *Button*        | *A button*                                     | [ref]()          |
| *Menu*          | *A group of buttons*                           | [ref]()          |
| *PercentageBar* | *A percentage bar*                             | [ref]()          |
| *Memo*          | *A text field*                                 | [ref]()          |

Now that you know all types of objects, I'll show you what I call **['Universal methods'](#2-universal-methods)** (*functions that are common to all objects*).

### 2. 'Universal methods'

| function      | args                    | return    | desc                                           |
| ------------- | ----------------------- | --------- | ---------------------------------------------- |
| *new*         | *depends on the object* | **table** | *Returns a new object*                         |
| *draw*        |                         | *nil*     | *Draws the object*                             |
| *update*      | **x**, **y**, **event** | **bool**  | *Checks if object was pressed*                 |
| *setCallback* | **event**, **callback** | *nil*     | *Sets a callback for the object*               |
| *hide*        | **bool**                | *nil*     | *Hides the object depending on the given bool* |

**To make an example of the use of every function I'll use the simplest object, and that's the header object**:

```lua
-- API already loaded

-- create an header with red text color and blue background text color that says 'This is an header'
-- at y = 2
local header = APLib.Header.new(2, 'This is an header', colors.red, colors.blue)

-- NOTE: header:setCallback(event, callback) is the same as
-- writing header.setCallback(header, event, callback)
header:setCallback(
	APLib.event.header.onPress,
    -- self is the object itself and event is the event that was passed through update function
    function (self, event)
        -- here we switch the color from red to white and vice-versa every time the header is pressed
        if self.colors.textColor == colors.red then
            self.colors.textColor = colors.white
        else
        	self.colors.textColor = colors.red
        end
    end
)

-- if you're scared of this part, don't worry it will get simplified drastically in the chapter
-- after the next one

while true do
    local event = {os.pullEvent()} -- here we pull an event from the computer
    -- we check if the event was a mouse_click, if it was we update the object
    if event[1] == 'mouse_click' then
        local x, y = event[3], event[4]
        header:update(x, y, event)
    -- else if a key was pressed then we hide/unhide the object
    elseif event[1] == 'key' then
        header:hide(not header.hidden)
    end
	APLib.bClear() -- clears the monitor
    -- at the end of all we draw it
    header:draw()
end

```

That code above simply **creates a Header and makes it change text color when pressed and hides/unhides it when a key is pressed**!

### 3. 'Universal events'

As you saw in the previous chapter i used the **setCallback ['Universal method'](#2-universal-methods)**, in this chapter i'll show you the **2 ['Universal events'](#3-universal-events)**:

| event     | desc                                                         |
| --------- | ------------------------------------------------------------ |
| *onDraw*  | *It's **called before the object is drawn***                 |
| *onPress* | *It's **called after the object was pressed** and gives 2 arguments:<br />1. The **object** itself.<br />2. The **event** that was passed through [Update 'Universal method'](#2-universal-methods).* |

Wasn't that easy to understand? Well, I hope so.


### 4. Making the loop easy (kind of)

Loop functions:

| function            | args                     | return | desc                                                         |
| ------------------- | ------------------------ | ------ | ------------------------------------------------------------ |
| *drawOnLoopClock*   |                          | *nil*  | *Makes the **loop draw on clock***                           |
| *drawOnLoopEvent*   |                          | *nil*  | *Makes the **loop draw on every event (laggy)***             |
| *setLoopClockSpeed* | **sec**                  | *nil*  | *Sets the **speed of the loop clock***                       |
| *setLoopTimerSpeed* | **sec**                  | *nil*  | *Sets the **speed of the loop timer**<br />(should be **set lower than the clock**)* |
| *setLoopCallback*   | **event**, **callback**  | *nil*  | *Sets a **callback for the loop**<br />(check [event](#2-event) table)* |
| *loopAutoClear*     | **bool**                 | *nil*  | *Makes the **loop clear the screen every time<br />it draws objects*** |
| *addLoopGroup*      | **groupName**, **group** | *nil*  | ***Adds group to groupName on loop groups<br />where group is an Array of objects***<br />*NOTE: the first object on the group is the one<br />on top of everything and the first one to be updated<br />so [Menu]() should be put first as an example.* |
| *setLoopGroup*      | **groupName**            | *nil*  | ***Sets currently active loop group**<br />(default: 'None')* |
| *resetLoopSettings* |                          | *nil*  | ***Deletes every custom loop group***                        |
| *stopLoop*          |                          | *nil*  | ***Stops the loop***                                         |
| *loop*              |                          | *nil*  | ***Starts the loop***                                        |

Here's **what we can change of the previous code with the stuff that we learned here**:

```lua
-- API already loaded

-- create an header with red text color and blue background text color that says 'This is an header'
-- at y = 2
local header = APLib.Header.new(2, 'This is an header', colors.red, colors.blue)

-- NOTE: header:setCallback(event, callback) is the same as
-- writing header.setCallback(header, event, callback)
header:setCallback(
	APLib.event.header.onPress,
    -- self is the object itself and event is the event that was passed through update function
    function (self, event)
        -- here we switch the color from red to white and vice-versa every time the header is pressed
        if self.colors.textColor == colors.red then
            self.colors.textColor = colors.white
            -- NEW STUFF
            -- switching between the 2 draw modes (difference shouldn't be noticeable with what
        	-- we're working with)
            APLib.drawOnLoopEvent()
        else
        	self.colors.textColor = colors.red
            -- NEW STUFF
            -- switching between the 2 draw modes (difference shouldn't be noticeable with what
        	-- we're working with)
            APLib.drawOnLoopClock()
        end
    end
)

-- NEW STUFF

-- Adding loop group 'Main' and putting the Header in it
APLib.addLoopGroup('Main', {header})
-- Setting 'Main' ad the current loop group
APLib.setLoopGroup('Main')


-- Setting loop clock speed very slow to show the difference between the two modes
APLib.setLoopClockSpeed(3)
-- Setting loop timer speed very fast to show the difference between the two modes
APLib.setLoopTimerSpeed(0.1) -- this is overkill on this app btw

-- I'm lazy so i don't want to clear the screen by myself
APLib.loopAutoClear(true)

-- Adding loop callback onInit and onEvent
APLib.setLoopCallback(
	APLib.event.loop.onInit,
    function ()
        print('Starting loop in 3 sec!')
        sleep(3)
        APLib.bClear()
    end
)

APLib.setLoopCallback(
	APLib.event.loop.onEvent,
    function (event)
        if event[1] == 'key' then
        	APLib.stopLoop()
    	end
    end
)

-- Starting the loop
APLib.loop()
-- If loop ends then reset loop groups
APLib.resetLoopSettings()
-- Clearing screen
APLib.bClear()

```



### 5. Header

It's **just a [Label](#6-label) but centered on the x axis**, its **text can be changed but the x axis gets adjusted only when drawn or updated**.

#### 1. Header Functions

It's only got ['Universal methods'](#2-universal-methods).

#### 2. Header Events

It's only got ['Universal events'](#3-universal-events).

#### 3. Header Example

Already done in [Making the loop easy (kind of)](#4-making-the-loop-easy-kind-of) and ['Universal methods'](#2-universal-methods)


### 6. Label

It's **just a [text](#10-text-x-y-text) but as an object**, so it stays in a variable and it's x and y can be changed on the fly.

#### 1. Label Functions

It's only got ['Universal methods'](#2-universal-methods).

#### 2. Label Events

It's only got ['Universal events'](#3-universal-events).

#### 3. Label Example

A **simple program that makes the label move depending on which arrow key was pressed and shows the difference between clock draw and event draw**:

```lua
-- API already loaded

-- create a label with red text color and blue background text color that says 'ClockDraw'
-- at x = 1, y = 1
local label = APLib.Label.new(1, 1, 'ClockDraw', colors.red, colors.blue)

-- creating onPress label callback
label:setCallback(
	APLib.event.label.onPress,
    function (self, event)
        -- here we switch the color from red to white and vice-versa every time the label is pressed
        if self.colors.textColor == colors.red then
            self.colors.textColor = colors.white
            -- making the user know what's the current loop draw mode
            self.text = 'EventDraw'
            -- switching between the 2 draw modes (difference should now be noticeable with what
        	-- we're working with)
            APLib.drawOnLoopEvent()
        else
        	self.colors.textColor = colors.red
            -- making the user know what's the current loop draw mode
            self.text = 'ClockDraw'
            -- switching between the 2 draw modes (difference should now be noticeable with what
        	-- we're working with)
            APLib.drawOnLoopClock()
        end
    end
)

-- Adding loop group 'Main' and putting the Label in it
APLib.addLoopGroup('Main', {label})
-- Setting 'Main' ad the current loop group
APLib.setLoopGroup('Main')


-- Setting loop clock speed very slow to show the difference between the two modes
APLib.setLoopClockSpeed(3)
-- Setting loop timer speed very fast to show the difference between the two modes
APLib.setLoopTimerSpeed(0.1)

-- I'm lazy so i don't want to clear the screen by myself
APLib.loopAutoClear(true)

-- Adding loop callback onInit and onEvent
APLib.setLoopCallback(
	APLib.event.loop.onInit,
    function ()
        print('Starting loop in 1 sec!')
        sleep(1)
        APLib.bClear()
    end
)

APLib.setLoopCallback(
	APLib.event.loop.onEvent,
    function (event)
        if event[1] == 'key' then
            -- making the label move depending on which arrow key was pressed
            if event[2] == 200 then -- UP_ARROW_KEY
                label.pos.y = label.pos.y - 1 -- making the label go up by 1 pixel
            elseif event[2] == 208 then -- DOWN_ARROW_KEY
                label.pos.y = label.pos.y + 1 -- making the label go down by 1 pixel
            elseif event[2] == 205 then -- RIGHT_ARROW_KEY
                label.pos.x = label.pos.x + 1 -- making the label go right by 1 pixel
            elseif event[2] == 203 then -- LEFT_ARROW_KEY
                label.pos.x = label.pos.x - 1 -- making the label go left by 1 pixel
            -- if another button was pressed then stop loop
            else
        		APLib.stopLoop()
            end
    	end
    end
)

-- Starting the loop
APLib.loop()
-- If loop ends then reset loop groups
APLib.resetLoopSettings()
-- Clearing screen
APLib.bClear()

```



