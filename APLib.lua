
ver = '0.7'
local globalMonitor = term
local globalMonitorName = 'term'
local globalMonitorWidth, globalMonitorHeight = globalMonitor.getSize()

--DRAWING
local globalColor = colors.white
local globalTextColor = colors.white
local globalBackgroundTextColor = colors.black
local globalRectangleType = 1

--LOOPS
local globalLoop = {
    enabled = false,
    autoClear = true,
    drawOnClock = true,
    speed = 0.5,
    callbacks = {
        onInit = function() end,
        onEvent = function() end,
        onClock = function() end
    },
    group = {}
}

--GLOBALCALLBACKS
local globalCallbacks = {
    onInfo = function() end,
    onBClear = function() end,
    onSetMonitor = function() end
}

--HELPERS
rectangleTypes = {filled = 1, hollow = 2}

event = {
    global = {
        onInfo = 1,
        onBClear = 2,
        onSetMonitor = 3
    },
    header = {
        onDraw = 1,
        onPress = 2
    },
    label = {
        onDraw = 1,
        onPress = 2
    },
    button = {
        onDraw = 1,
        onPress = 2
    },
    percentagebar = {
        onDraw = 1,
        onPress = 2
    },
    loop = {
        onInit = 1,
        onEvent = 2,
        onClock = 3
    }
}

function setGlobalCallback(_event, _callback)
    assert(type(_callback) == 'function', 'setGlobalCallback: callback must be a function, got '..type(_callback))
    if _event == 1 then
        globalCallbacks.onInfo = _callback
    elseif _event == 2 then
        globalCallbacks.onBClear = _callback
    elseif _event == 3 then
        globalCallbacks.onSetMonitor = _callback
    end
end

function getInfo()
    local _Lib = {
        ver = ver,
        globalMonitor = globalMonitor,
        globalMonitorName = globalMonitorName,
        globalMonitorWidth = globalMonitorWidth,
        globalMonitorHeight = globalMonitorHeight,
        globalColor = globalColor,
        globalTextColor = globalTextColor,
        globalBackgroundTextColor = globalBackgroundTextColor,
        globalRectangleType = globalRectangleType,
        globalLoop = globalLoop,
        globalCallbacks = globalCallbacks
    }
    globalCallbacks.onInfo(_Lib)
    return _Lib
end

function bClear()
    globalMonitor.clear()
    globalMonitor.setCursorPos(1, 1)
    globalCallbacks.onBClear()
end

function setMonitor(_monitorName)
    if _monitorName == 'term' then
        globalMonitor = term --SET GLOBALMONITOR TO MONITOR
        globalMonitorName = 'term'
        globalMonitorWidth, globalMonitorHeight = globalMonitor.getSize()
    else
        assert(tostring(peripheral.getType(_monitorName)) == 'monitor', 'setMonitor: monitorName must be a monitor, got '..tostring(peripheral.getType(_monitorName)))
        local _monitor = peripheral.wrap(_monitorName)
        globalMonitor = _monitor --SET GLOBALMONITOR TO MONITOR
        globalMonitorName = _monitorName
        globalMonitorWidth, globalMonitorHeight = globalMonitor.getSize()
    end
    globalCallbacks.onSetMonitor(globalMonitor, globalMonitorName, globalMonitorWidth, globalMonitorHeight)
end

function setColor(_color)
    assert(type(_color) == 'number', 'setColor: color must be a number, got '..type(_color))
    globalColor = _color --SET GLOBALCOLOR TO COLOR
end

function setTextColor(_color)
    assert(type(_color) == 'number', 'setTextColor: color must be a number, got '..type(_color))
    globalTextColor = _color --SET GLOBALTEXTCOLOR TO COLOR
end

function setBackgroundTextColor(_color)
    assert(type(_color) == 'number', 'setBackgroundTextColor: color must be a number, got '..type(_color))
    globalBackgroundTextColor = _color --SET GLOBALTEXTBG TO COLOR
end

function setBackground(_color)
    assert(type(_color) == 'number', 'setBackgroundColor: color must be a number, got '..type(_color))
    globalMonitor.setBackgroundColor(_color) --SET BG COLOR TO COLOR
    bClear() --CLEARS MONITOR
end

function setRectangleType(_type)
    assert(type(_type) == 'number', 'setRectangleType: type must be a number, got '..type(_type))
    globalRectangleType = _type
end

function text(_x, _y, _text)
    assert(type(_x) == 'number', 'Text: x must be a number, got '..type(_x))
    assert(type(_y) == 'number', 'Text: y must be a number, got '..type(_y))
    
    _text = tostring(_text)

    local oldCursorPosX, oldCursorPosY = globalMonitor.getCursorPos()
    local oldTextColor = globalMonitor.getTextColor()
    local oldBackgroundColor = globalMonitor.getBackgroundColor()

    globalMonitor.setCursorPos(_x, _y)
    globalMonitor.setTextColor(globalTextColor)
    globalMonitor.setBackgroundColor(globalBackgroundTextColor)

    globalMonitor.write(_text)

    globalMonitor.setCursorPos(oldCursorPosX, oldCursorPosY)
    globalMonitor.setTextColor(oldTextColor)
    globalMonitor.setBackgroundColor(oldBackgroundColor)
    
end

function point(_x, _y)
    assert(type(_x) == 'number', 'Point: x must be a number, got '..type(_x))
    assert(type(_y) == 'number', 'Point: y must be a number, got '..type(_y))
    local oldCursorPosX, oldCursorPosY = globalMonitor.getCursorPos() --PUTS CURSOR ON X, Y
    globalMonitor.setCursorPos(_x, _y)
    local oldBackgroundColor = globalMonitor.getBackgroundColor() --CHANGES THE COLOR OF THE POINT
    globalMonitor.setBackgroundColor(globalColor)
    globalMonitor.write(' ') --DRAWS THE POINT
    globalMonitor.setCursorPos(oldCursorPosX, oldCursorPosY) --RESTORES OLD CURSOR POS
    globalMonitor.setBackgroundColor(oldBackgroundColor) --RESTORES OLD COLOR
end

function rectangle(_x1, _y1, _x2, _y2)
    assert(type(_x1) == 'number', 'Point: x1 must be a number, got '..type(_x1))
    assert(type(_y1) == 'number', 'Point: y1 must be a number, got '..type(_y1))
    assert(type(_x2) == 'number', 'Point: x2 must be a number, got '..type(_x2))
    assert(type(_y2) == 'number', 'Point: y2 must be a number, got '..type(_y2))
    local _incrementX = 1 --FINDS THE INCREMENT FOR THE LOOPS
    local _incrementY = 1
    if _x1 > _x2 then _incrementX = -1; end
    if _y1 > _y2 then _incrementY = -1; end
    
    if globalRectangleType == 1 then --CHECKS GLOBALRECTANGLETYPE
        for x = _x1, _x2, _incrementX do --DRAWS FILLED RECTANGLE
            for y = _y1, _y2, _incrementY do
                point(x, y)
            end
        end
    elseif globalRectangleType == 2 then
        for x = _x1, _x2, _incrementX do --DRAWS HOLLOW RECTANGLE
            point(x, _y1)
            point(x, _y2)
        end
        for y = _y1, _y2, _incrementY do
            point(_x1, y)
            point(_x2, y)
        end
    end
end

function checkAreaPress(_x1, _y1, _x2, _y2, _xPressed, _yPressed)
    assert(type(_x1) == 'number', 'checkAreaPress: x1 must be a number, got '..type(_x1))
    assert(type(_y1) == 'number', 'checkAreaPress: y1 must be a number, got '..type(_y1))
    assert(type(_x2) == 'number', 'checkAreaPress: x2 must be a number, got '..type(_x2))
    assert(type(_y2) == 'number', 'checkAreaPress: y2 must be a number, got '..type(_y2))
    assert(type(_xPressed) == 'number', 'checkAreaPress: xPressed must be a number, got '..type(_xPressed))
    assert(type(_yPressed) == 'number', 'checkAreaPress: yPressed must be a number, got '..type(_yPressed))

    if _x1 < _x2 then -- CHECK X
        if not(_xPressed >= _x1 and _xPressed <= _x2) then
            return false
        end
    else
        if not(_xPressed <= _x1 and _xPressed >= _x2) then
            return false
        end
    end

    if _y1 < _y2 then -- CHECK Y
        if not(_yPressed >= _y1 and _yPressed <= _y2) then
            return false
        end
    else
        if not(_yPressed <= _y1 and _yPressed >= _y2) then
            return false
        end
    end
    return true -- RETURN IF IT WAS PRESSED

end

--//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////--

Header = {}

function Header.new(_y, _text, _textColor, _backgroundTextColor)

    assert(type(_y) == 'number', 'Header.new: y must be a number, got '..type(_y))

    --FIX THINGS
    _text = tostring(_text)
    _textColor = tonumber(_textColor)
    _backgroundTextColor = tonumber(_backgroundTextColor)

    --CHECK THINGS
    if not _textColor then
        _textColor = globalTextColor
    end

    --CREATE HEADER
    _newHeader = {
        text = _text,
        hidden = false,
        pos = {
            x = math.floor((globalMonitorWidth - string.len(_text) + 1) / 2),
            y = _y
        },
        colors = {
            textColor = _textColor,
            backgroundTextColor = _backgroundTextColor
        },
        callbacks = {
            onDraw = function() end,
            onPress = function() end
        }
    }
    setmetatable(_newHeader, Header) --SET HEADER METATABLE
    return _newHeader
end

function Header:draw()
    local oldTextColor = globalTextColor
    local oldBackgroundTextColor = globalBackgroundTextColor

    local backgroundColor = globalMonitor.getBackgroundColor()
    
    --SETTING THINGS TO HEADER SETTINGS
    setTextColor(self.colors.textColor)
    if self.colors.backgroundTextColor then
        setBackgroundTextColor(self.colors.backgroundTextColor)
    else
        setBackgroundTextColor(backgroundColor)
    end
    setTextColor(self.colors.textColor)

    --DRAWING HEADER
    self.pos.x = math.floor((globalMonitorWidth - string.len(self.text) + 1) / 2)
    text(self.pos.x, self.pos.y, self.text)

    --REVERTING ALL CHANGES MADE BEFORE
    setTextColor(oldTextColor)
    setBackgroundTextColor(oldBackgroundTextColor)

    self.callbacks.onDraw(self)
end

function Header:setCallback(_event, _callback)
    assert(type(_callback) == 'function', 'Header.setCallback: callback must be a function, got '..type(_callback))
    if _event == 1 then
        self.callbacks.onDraw = _callback
    elseif _event == 2 then
        self.callbacks.onPress = _callback
    end
end

function Header:update(_x, _y, _event)
    assert(type(_x) == 'number', 'Header.update: x must be a number, got '..type(_x))
    assert(type(_y) == 'number', 'Header.update: y must be a number, got '..type(_y))

    local _x2 = self.pos.x + string.len(self.text) - 1 -- CALCULATE X2
    if checkAreaPress(self.pos.x, self.pos.y, _x2, self.pos.y, _x, _y) then -- CHECK IF IT WAS PRESSED
        -- IF THE HEADER WAS PRESSED CALL CALLBACK
        self.callbacks.onPress(self, _event)
        return true
    else
        return false
    end
end

function Header:hide(_bool)
    assert(type(_bool) == 'boolean', 'Header.hide: bool must be a boolean, got '..type(_bool))
    self.hidden = _bool
end

Header.__index = Header

--//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////--

Label = {}

function Label.new(_x, _y, _text, _textColor, _backgroundTextColor)

    assert(type(_x) == 'number', 'Label.new: x must be a number, got '..type(_x))
    assert(type(_y) == 'number', 'Label.new: y must be a number, got '..type(_y))

    --FIX THINGS
    _text = tostring(_text)
    _textColor = tonumber(_textColor)
    _backgroundTextColor = tonumber(_backgroundTextColor)

    --CHECK THINGS
    if not _textColor then
        _textColor = globalTextColor
    end

    --CREATE LABEL
    _newLabel = {
        text = _text,
        hidden = false,
        pos = {
            x = _x,
            y = _y
        },
        colors = {
            textColor = _textColor,
            backgroundTextColor = _backgroundTextColor
        },
        callbacks = {
            onDraw = function() end,
            onPress = function() end
        }
    }
    setmetatable(_newLabel, Label) --SET LABEL METATABLE
    return _newLabel
end

function Label:draw()
    local oldTextColor = globalTextColor
    local oldBackgroundTextColor = globalBackgroundTextColor

    local backgroundColor = globalMonitor.getBackgroundColor()
    
    --SETTING THINGS TO LABEL SETTINGS
    setTextColor(self.colors.textColor)
    if self.colors.backgroundTextColor then
        setBackgroundTextColor(self.colors.backgroundTextColor)
    else
        setBackgroundTextColor(backgroundColor)
    end
    setTextColor(self.colors.textColor)

    --DRAWING LABEL
    text(self.pos.x, self.pos.y, self.text)

    --REVERTING ALL CHANGES MADE BEFORE
    setTextColor(oldTextColor)
    setBackgroundTextColor(oldBackgroundTextColor)

    self.callbacks.onDraw(self)
end

function Label:setCallback(_event, _callback)
    assert(type(_callback) == 'function', 'Label.setCallback: callback must be a function, got '..type(_callback))
    if _event == 1 then
        self.callbacks.onDraw = _callback
    elseif _event == 2 then
        self.callbacks.onPress = _callback
    end
end

function Label:update(_x, _y, _event)
    assert(type(_x) == 'number', 'Label.update: x must be a number, got '..type(_x))
    assert(type(_y) == 'number', 'Label.update: y must be a number, got '..type(_y))

    local _x2 = self.pos.x + string.len(self.text) - 1 -- CALCULATE X2
    if checkAreaPress(self.pos.x, self.pos.y, _x2, self.pos.y, _x, _y) then -- CHECK IF IT WAS PRESSED
        -- IF THE LABEL WAS PRESSED CALL CALLBACK
        self.callbacks.onPress(self, _event)
        return true
    else
        return false
    end
end

function Label:hide(_bool)
    assert(type(_bool) == 'boolean', 'Label.hide: bool must be a boolean, got '..type(_bool))
    self.hidden = _bool
end

Label.__index = Label

--//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////--

Button = {}

function Button.new(_x1, _y1, _x2, _y2, _text, _textColor, _backgroundTextColor, _pressedButtonColor, _notPressedButtonColor)
    
    assert(type(_x1) == 'number', 'Button.new: x1 must be a number, got '..type(_x1))
    assert(type(_y1) == 'number', 'Button.new: y1 must be a number, got '..type(_y1))
    assert(type(_x2) == 'number', 'Button.new: x2 must be a number, got '..type(_x2))
    assert(type(_y2) == 'number', 'Button.new: y2 must be a number, got '..type(_y2))
    
    --FIX THINGS
    _text = tostring(_text)
    _textColor = tonumber(_textColor)
    _backgroundTextColor = tonumber(_backgroundTextColor)
    _pressedButtonColor = tonumber(_pressedButtonColor)
    _notPressedButtonColor = tonumber(_notPressedButtonColor)

    --CHECK THINGS
    if not _textColor then
        _textColor = globalTextColor
    end
    if not _pressedButtonColor then
        _pressedButtonColor = globalColor
    end
    if not _notPressedButtonColor then
        _notPressedButtonColor = globalColor
    end

    --CREATE BUTTON
    _newButton = {
        text = _text,
        state = false,
        hidden = false,
        pos = {
            x1 = _x1,
            y1 = _y1,
            x2 = _x2,
            y2 = _y2
        },
        colors = {
            textColor = _textColor,
            backgroundTextColor = _backgroundTextColor,
            pressedButtonColor = _pressedButtonColor,
            notPressedButtonColor = _notPressedButtonColor
        },
        callbacks = {
            onDraw = function() end,
            onPress = function() end
        }
    }
    setmetatable(_newButton, Button) --SET BUTTON METATABLE
    return _newButton
end

function Button:draw()
    local oldRectType = globalRectangleType
    local oldColor = globalColor
    local oldTextColor = globalTextColor
    local oldBackgroundTextColor = globalBackgroundTextColor
    
    --SETTING THINGS TO BUTTON SETTINGS
    setRectangleType(rectangleTypes.filled)
    if self.state then
        setColor(self.colors.pressedButtonColor)
        if self.colors.backgroundTextColor then
            setBackgroundTextColor(self.colors.backgroundTextColor)
        else
            setBackgroundTextColor(self.colors.pressedButtonColor)
        end
    else
        setColor(self.colors.notPressedButtonColor)
        if self.colors.backgroundTextColor then
            setBackgroundTextColor(self.colors.backgroundTextColor)
        else
            setBackgroundTextColor(self.colors.notPressedButtonColor)
        end
    end
    setTextColor(self.colors.textColor)

    --DRAWING BUTTON
    rectangle(self.pos.x1, self.pos.y1, self.pos.x2, self.pos.y2)
    
    local _textX = self.pos.x1 + math.floor((self.pos.x2 - self.pos.x1 - string.len(self.text) + 1) / 2)
    local _textY = self.pos.y1 + math.floor((self.pos.y2 - self.pos.y1) / 2)
    text(_textX, _textY, self.text)

    --REVERTING ALL CHANGES MADE BEFORE
    setRectangleType(oldRectType)
    setColor(oldColor)
    setTextColor(oldTextColor)
    setBackgroundTextColor(oldBackgroundTextColor)

    self.callbacks.onDraw(self)
end

function Button:setCallback(_event, _callback)
    assert(type(_callback) == 'function', 'Button.setCallback: callback must be a function, got '..type(_callback))
    if _event == 1 then
        self.callbacks.onDraw = _callback
    elseif _event == 2 then
        self.callbacks.onPress = _callback
    end
end

function Button:update(_x, _y, _event)
    assert(type(_x) == 'number', 'Button.update: x must be a number, got '..type(_x))
    assert(type(_y) == 'number', 'Button.update: y must be a number, got '..type(_y))

    if checkAreaPress(self.pos.x1, self.pos.y1, self.pos.x2, self.pos.y2, _x, _y) then -- CHECK IF IT WAS PRESSED
        -- IF THE BUTTON WAS PRESSED CALL CALLBACK
        self.state = not self.state
        self.callbacks.onPress(self, _event)
        return true
    else
        return false
    end
end

function Button:hide(_bool)
    assert(type(_bool) == 'boolean', 'Button.hide: bool must be a boolean, got '..type(_bool))
    self.hidden = _bool
end

Button.__index = Button

--//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////--

PercentageBar = {}

function PercentageBar.new(_x1, _y1, _x2, _y2, _value, _min, _max, _drawValue, _valueColor, _backgroundValueColor, _barColor, _backgroundBarColor)
    
    assert(type(_x1) == 'number', 'PercentageBar.new: x1 must be a number, got '..type(_x1))
    assert(type(_y1) == 'number', 'PercentageBar.new: y1 must be a number, got '..type(_y1))
    assert(type(_x2) == 'number', 'PercentageBar.new: x2 must be a number, got '..type(_x2))
    assert(type(_y2) == 'number', 'PercentageBar.new: y2 must be a number, got '..type(_y2))
    assert(type(_value) == 'number', 'PercentageBar.new: value must be a number, got '..type(_value))
    assert(type(_min) == 'number', 'PercentageBar.new: min must be a number, got '..type(_min))
    assert(type(_max) == 'number', 'PercentageBar.new: max must be a number, got '..type(_max))
    
    --FIX THINGS
    _valueColor = tonumber(_valueColor)
    _backgroundValueColor = tonumber(_backgroundValueColor)
    _barColor = tonumber(_barColor)
    _backgroundBarColor = tonumber(_backgroundBarColor)
    
    --CHECK THINGS
    if not _valueColor then
        _valueColor = globalTextColor
    end
    if not _barColor then
        _barColor = globalColor
    end
    
    --CREATE PERCENTAGEBAR
    _newPercentageBar = {
        hidden = false,
        value = {
            draw = _drawValue,
            percentage = nil,
            current = nil,
            max = _max,
            min = _min
        },
        pos = {
            x1 = _x1,
            y1 = _y1,
            x2 = _x2,
            y2 = _y2
        },
        colors = {
            valueColor = _valueColor,
            backgroundValueColor = _backgroundValueColor,
            barColor = _barColor,
            backgroundBarColor = _backgroundBarColor
        },
        callbacks = {
            onDraw = function() end,
            onPress = function() end
        }
    }

    PercentageBar.setValue(_newPercentageBar, _value)
    setmetatable(_newPercentageBar, PercentageBar) --SET PERCENTAGEBAR METATABLE
    return _newPercentageBar
end

function PercentageBar:draw()
    local oldRectType = globalRectangleType
    local oldColor = globalColor
    local oldTextColor = globalTextColor
    local oldBackgroundTextColor = globalBackgroundTextColor

    local backgroundColor = globalMonitor.getBackgroundColor()
    
    --SETTING THINGS TO PERCENTAGEBAR SETTINGS
    setRectangleType(rectangleTypes.filled)

    if self.colors.backgroundBarColor then -- DRAW PERCENTAGE BAR WITH BACKGROUND
        setColor(self.colors.backgroundBarColor)
        rectangle(self.pos.x1, self.pos.y1, self.pos.x2, self.pos.y2)

        if self.value.percentage > 0 then
            setColor(self.colors.barColor)
            rectangle(self.pos.x1, self.pos.y1, self.pos.x1 + ((self.pos.x2 - self.pos.x1) * self.value.percentage / 100), self.pos.y2)
        end
    else -- DRAW PERCENTAGE BAR WITHOUT BACKGROUND
        if self.value.percentage > 0 then
            setColor(self.colors.barColor)
            rectangle(self.pos.x1, self.pos.y1, self.pos.x1 + ((self.pos.x2 - self.pos.x1) * self.value.percentage / 100), self.pos.y2)
        end
    end

    if self.value.draw then -- DRAW PB VALUE IF THE SETTING IS ENABLED
        
        -- CENTER VALUE ON PB
        local _valueX = self.pos.x1 + math.floor((self.pos.x2 - self.pos.x1 - string.len(self.value.percentage..'%') + 1) / 2)
        
        local _valueY
        if self.pos.y1 > self.pos.y2 then
            _valueY = self.pos.y1 + 1
        else
            _valueY = self.pos.y2 + 1
        end

        setTextColor(self.colors.valueColor) -- SET VALUE COLOR
        if self.colors.backgroundValueColor then -- CHECK IF THE BG COLOR IS SPECIFIED
            setBackgroundTextColor(self.colors.backgroundValueColor)
        else -- IF NOT SPECIFIED
            setBackgroundTextColor(backgroundColor)
        end
        text(_valueX, _valueY, self.value.percentage..'%')
    end

    --REVERTING ALL CHANGES MADE BEFORE
    setRectangleType(oldRectType)
    setColor(oldColor)
    setTextColor(oldTextColor)
    setBackgroundTextColor(oldBackgroundTextColor)

    self.callbacks.onDraw(self)
end

function PercentageBar:setCallback(_event, _callback)
    assert(type(_callback) == 'function', 'PercentageBar.setCallback: callback must be a function, got '..type(_callback))
    if _event == 1 then
        self.callbacks.onDraw = _callback
    elseif _event == 2 then
        self.callbacks.onPress = _callback
    end
end

function PercentageBar:setValue(_value)
    assert(type(_value) == 'number', 'PercentageBar.setValue: value must be a number, got '..type(_value))
    if _value < self.value.min then _value = self.value.min; end
    if _value > self.value.max then _value = self.value.max; end
    self.value.current = _value
    self.value.percentage = math.floor(((self.value.current - self.value.min) / (self.value.max - self.value.min)) * 100)
end

function PercentageBar:update(_x, _y, _event)
    assert(type(_x) == 'number', 'PercentageBar.update: x must be a number, got '..type(_x))
    assert(type(_y) == 'number', 'PercentageBar.update: y must be a number, got '..type(_y))

    if checkAreaPress(self.pos.x1, self.pos.y1, self.pos.x2, self.pos.y2, _x, _y) then -- CHECK IF IT WAS PRESSED
        -- IF THE PERCENTAGEBAR WAS PRESSED CALL CALLBACK
        self.callbacks.onPress(self, _event)
        return true
    else
        return false
    end
end

function PercentageBar:hide(_bool)
    assert(type(_bool) == 'boolean', 'PercentageBar.hide: bool must be a boolean, got '..type(_bool))
    self.hidden = _bool
end

PercentageBar.__index = PercentageBar

--//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////--

function drawOnLoopClock()
    globalLoop.drawOnClock = true
end

function drawOnLoopEvent()
    globalLoop.drawOnClock = false
end

function setLoopClockSpeed(_sec)
    assert(type(_sec) == 'number', 'setLoopClockSpeed: sec must be a number, got '..type(_sec))
    globalLoop.speed = _sec
end

function setLoopCallback(_event, _callback)
    assert(type(_callback) == 'function', 'setLoopCallback: callback must be a function, got '..type(_callback))
    if _event == 1 then
        globalLoop.callbacks.onInit = _callback
    elseif _event == 2 then
        globalLoop.callbacks.onEvent = _callback
    elseif _event == 3 then
        globalLoop.callbacks.onClock = _callback
    end
end

function loopAutoClear(_bool)
    assert(type(_bool) == 'boolean', 'loopAutoClear: bool must be a boolean, got '..type(_bool))
    globalLoop.autoClear = _bool
end

function stopLoop()
    globalLoop.enabled = false --STOP LOOP

    globalLoop.callbacks.onInit = function() end
    globalLoop.callbacks.onEvent = function() end -- CLEARS LOOP CALLBACKS
    globalLoop.callbacks.onClock = function() end
    
    globalLoop.group = {} --CLEAR LOOP GROUP
end

function loop(_group)
    assert(type(_group) == 'table', 'Loop: group must be a table, got '..type(_group))
    globalLoop.enabled = true -- ACTIVATE LOOP
    globalLoop.group = _group -- SET GLOBAL LOOP GROUP

    if globalLoop.autoClear then
        bClear()
    end
    globalLoop.callbacks.onInit()
    for key in pairs(globalLoop.group) do -- DRAW ALL BUTTONS BEFORE STARTING LOOP
        if not globalLoop.group[key].hidden then
            globalLoop.group[key]:draw()
        end
    end

    local Clock = os.clock()

    while globalLoop.enabled do

        local Timer = os.startTimer(globalLoop.speed / 2) -- START A TIMER

        local event = {os.pullEvent()} -- PULL EVENTS

        -- EVENT
        if event[1] == 'monitor_touch' and event[2] == globalMonitorName then -- CHECK IF A BUTTON WAS PRESSED
            for key in pairs(globalLoop.group) do
                if not globalLoop.group[key].hidden then
                    globalLoop.group[key]:update(event[3], event[4], event)
                end
            end
        elseif event[1] == 'mouse_click' and globalMonitorName == 'term' then
            for key in pairs(globalLoop.group) do
                if not globalLoop.group[key].hidden then
                    globalLoop.group[key]:update(event[3], event[4], event)
                end
            end
        end

        -- CLOCK
        if os.clock() >= Clock + globalLoop.speed then

            Clock = os.clock()

            if globalLoop.drawOnClock then -- CLOCK DRAW
                if globalLoop.autoClear then
                    bClear()
                end
                globalLoop.callbacks.onClock(event) -- TIMER CALLBACK
                for key in pairs(globalLoop.group) do -- DRAW ALL BUTTONS
                    if not globalLoop.group[key].hidden then
                        globalLoop.group[key]:draw()
                    end
                end
            else
                globalLoop.callbacks.onClock(event) -- TIMER CALLBACK
            end
        end

        --EVENT DRAW
        if not globalLoop.drawOnClock then -- NON CLOCK DRAW
            if globalLoop.autoClear then
                bClear()
            end
            globalLoop.callbacks.onEvent(event) -- EVENT CALLBACK
            for key in pairs(globalLoop.group) do -- DRAW ALL BUTTONS
                if not globalLoop.group[key].hidden then
                    globalLoop.group[key]:draw()
                end
            end
        else
            globalLoop.callbacks.onEvent(event) -- EVENT CALLBACK
        end

        os.cancelTimer(Timer) -- DELETE TIMER
    end
end