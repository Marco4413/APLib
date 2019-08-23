
ver = '1.0.1'
local globalMonitor = term
local globalMonitorName = 'term'
local globalMonitorGroup = {
    enabled = false,
    list = {}
}
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
    clockSpeed = 0.5,
    timerSpeed = 0.1,
    callbacks = {
        onInit = function() end,
        onClock = function() end,
        onEvent = function() end,
        onTimer = function() end,
        onMonitorChange = function() end
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
    memo = {
        onDraw = 1,
        onPress = 2,
        onEdit = 3,
        onCursorBlink = 4
    },
    loop = {
        onInit = 1,
        onClock = 2,
        onEvent = 3,
        onTimer = 4,
        onMonitorChange = 5
    }
}

function tableHas(_table, _value)
    assert(type(_table) == 'table', 'tableHas: table must be a table, got '..type(_table))
    for key, value in pairs(_table) do
        if value == _value then
            return true
        end
    end
    return false
end

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
        globalMonitorGroup = globalMonitorGroup,
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

function bClearMonitorGroup()
    local oldMonitor = globalMonitorName
    for _, monitorName in pairs(globalMonitorGroup.list) do
        setMonitor(monitorName)
        bClear()
    end
    setMonitor(oldMonitor)
end

function setMonitor(_monitorName)
    globalCallbacks.onSetMonitor(globalMonitor, globalMonitorName, globalMonitorWidth, globalMonitorHeight)
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
end

function setMonitorGroup(_monitorNameList)
    assert(type(_monitorNameList) == 'table', 'setMonitorGroup: monitorNameList must be a table, got '..type(_monitorNameList))
    for key, value in pairs(_monitorNameList) do
        value = tostring(value)
        if not value == 'term' then
            assert(tostring(peripheral.getType(value)) == 'monitor', 'setMonitorGroup: '..value..' must be a monitor, got '..tostring(peripheral.getType(value)))
        end
    end
    globalMonitorGroup.list = _monitorNameList
end

function setMonitorGroupEnabled(_bool)
    assert(type(_bool) == 'boolean', 'setMonitorGroupEnabled: bool must be a boolean, got '..type(_bool))
    globalMonitorGroup.enabled = _bool
end

function resetMonitorGroup()
    globalMonitorGroup.list = {}
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
    if not self.hidden then
        self.callbacks.onDraw(self)

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
    end
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

    if not self.hidden then
        self.pos.x = math.floor((globalMonitorWidth - string.len(self.text) + 1) / 2) -- RECALC SCREEN CENTRE
        local _x2 = self.pos.x + string.len(self.text) - 1 -- CALCULATE X2
        if checkAreaPress(self.pos.x, self.pos.y, _x2, self.pos.y, _x, _y) then -- CHECK IF IT WAS PRESSED
            -- IF THE HEADER WAS PRESSED CALL CALLBACK
            self.callbacks.onPress(self, _event)
            return true
        else
            return false
        end
    end
    return false
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
    if not self.hidden then
        self.callbacks.onDraw(self)

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
    end
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

    if not self.hidden then
        local _x2 = self.pos.x + string.len(self.text) - 1 -- CALCULATE X2
        if checkAreaPress(self.pos.x, self.pos.y, _x2, self.pos.y, _x, _y) then -- CHECK IF IT WAS PRESSED
            -- IF THE LABEL WAS PRESSED CALL CALLBACK
            self.callbacks.onPress(self, _event)
            return true
        else
            return false
        end
    end
    return false
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
    if not self.hidden then
        self.callbacks.onDraw(self)

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
    end
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

    if not self.hidden then
        if checkAreaPress(self.pos.x1, self.pos.y1, self.pos.x2, self.pos.y2, _x, _y) then -- CHECK IF IT WAS PRESSED
            -- IF THE BUTTON WAS PRESSED CALL CALLBACK
            self.state = not self.state
            self.callbacks.onPress(self, _event)
            return true
        else
            return false
        end
    end
    return false
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
    if not self.hidden then
        self.callbacks.onDraw(self)

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
    end
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

    if not self.hidden then
        if checkAreaPress(self.pos.x1, self.pos.y1, self.pos.x2, self.pos.y2, _x, _y) then -- CHECK IF IT WAS PRESSED
            -- IF THE PERCENTAGEBAR WAS PRESSED CALL CALLBACK
            self.callbacks.onPress(self, _event)
            return true
        else
            return false
        end
    end
    return false
end

function PercentageBar:hide(_bool)
    assert(type(_bool) == 'boolean', 'PercentageBar.hide: bool must be a boolean, got '..type(_bool))
    self.hidden = _bool
end

PercentageBar.__index = PercentageBar

--//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////--

Memo = {}

function Memo.new(_x1, _y1, _x2, _y2, _textColor, _backgroundTextColor, _color, _cursorColor)
    
    assert(type(_x1) == 'number', 'Memo.new: x1 must be a number, got '..type(_x1))
    assert(type(_y1) == 'number', 'Memo.new: y1 must be a number, got '..type(_y1))
    assert(type(_x2) == 'number', 'Memo.new: x2 must be a number, got '..type(_x2))
    assert(type(_y2) == 'number', 'Memo.new: y2 must be a number, got '..type(_y2))
    
    --FIX THINGS
    _textColor = tonumber(_textColor)
    _backgroundTextColor = tonumber(_backgroundTextColor)
    _color = tonumber(_color)
    _cursorColor = tonumber(_cursorColor)
    
    --CHECK THINGS
    if not _textColor then
        _textColor = globalTextColor
    end
    if not _color then
        _color = globalColor
    end
    if not _backgroundTextColor then
        _backgroundTextColor = _color
    end
    if not _cursorColor then
        _cursorColor = colors.white
    end
    
    --CREATE MEMO
    _newMemo = {
        hidden = false,
        lines = {},
        pos = {
            x1 = _x1,
            y1 = _y1,
            x2 = _x2,
            y2 = _y2
        },
        cursor = {
            color = _cursorColor,
            visible = false,
            blinkSpeed = 0.5,
            pos = {
                char = 0,
                line = 0
            },
            limits = {
                enabled = true,
                char = math.abs(_x2 - _x1),
                line = math.abs(_y2 - _y1)
            }
        },
        colors = {
            textColor = _textColor,
            backgroundTextColor = _backgroundTextColor,
            color = _color
        },
        callbacks = {
            onDraw = function() end,
            onPress = function() end,
            onEdit = function() end,
            onCursorBlink = function() end
        }
    }

    setmetatable(_newMemo, Memo) --SET MEMO METATABLE
    return _newMemo
end

function Memo:draw()
    if not self.hidden then
    self.callbacks.onDraw(self)

    local oldRectType = globalRectangleType
    local oldColor = globalColor
    local oldTextColor = globalTextColor
    local oldBackgroundTextColor = globalBackgroundTextColor

    local backgroundColor = globalMonitor.getBackgroundColor()

    -- SORT Xs AND Ys
    local _memoX1, _memoX2, _memoY1, _memoY2
    if self.pos.x1 > self.pos.x2 then
        _memoX1 = self.pos.x2
        _memoX2 = self.pos.x1
    else
        _memoX1 = self.pos.x1
        _memoX2 = self.pos.x2
    end
    if self.pos.y1 > self.pos.y2 then
        _memoY1 = self.pos.y2
        _memoY2 = self.pos.y1
    else
        _memoY1 = self.pos.y1
        _memoY2 = self.pos.y2
    end
    
    -- SETTING THINGS TO MEMO SETTINGS

    setRectangleType(rectangleTypes.filled)
    setColor(self.colors.color)
    setTextColor(self.colors.textColor)
    setBackgroundTextColor(self.colors.backgroundTextColor)

    rectangle(_memoX1, _memoY1, _memoX2, _memoY2)

    -- GET WIDTH AND HEIGHT OF THE SQUARE
    local _width = _memoX2 - _memoX1
    local _height = _memoY2 - _memoY1

    -- MAKING THE CURSOR NOT GO OUT OF BOUNDS
    local _cursorScreenPos = {
        x = self.cursor.pos.char,
        y = self.cursor.pos.line
    }
    if _cursorScreenPos.x > _width then
        _cursorScreenPos.x = _width
    elseif _cursorScreenPos.x < 0 then
        _cursorScreenPos.x = 0
    end
    if _cursorScreenPos.y > _height then
        _cursorScreenPos.y = _height
    elseif _cursorScreenPos.y < 0 then
        _cursorScreenPos.y = 0
    end

    -- FOR EVERY Y IN THE SQUARE
    for i=0, math.abs(_memoY2 - _memoY1) do
        if self.cursor.pos.line <= _height then -- IF THE CURSOR IS LESS THAN THE HEIGHT OF THE SQUARE
            if self.lines[i + 1] then -- IF LINE EXISTS
                if self.cursor.pos.char <= _width then -- IF THE CURSOR IS LESS THEN THE WIDTH OF THE SQUARE
                    text(_memoX1, _memoY1 + i, string.sub(self.lines[i + 1], 1, _width + 1))
                else -- IF THE CURSOR IS MORE THEN THE WIDTH OF THE SQUARE
                    text(_memoX1, _memoY1 + i, string.sub(self.lines[i + 1], self.cursor.pos.char - _width + 1, self.cursor.pos.char + 1))
                end
            end
        else -- IF THE CURSOR IS MORE THAN THE HEIGHT OF THE SQUARE
            if self.lines[i + 1 + self.cursor.pos.line - _height] then -- IF LINE EXISTS
                if self.cursor.pos.char <= _width then -- IF THE CURSOR IS LESS THEN THE WIDTH OF THE SQUARE
                    text(_memoX1, _memoY1 + i, string.sub(self.lines[i + 1 + self.cursor.pos.line - _height], 1, _width + 1))
                else -- IF THE CURSOR IS MORE THEN THE WIDTH OF THE SQUARE
                    text(_memoX1, _memoY1 + i, string.sub(self.lines[i + 1 + self.cursor.pos.line - _height], self.cursor.pos.char - _width + 1, self.cursor.pos.char + 1))
                end
            end
        end
    end

    if self.cursor.visible then
        setColor(self.cursor.color)
        point(_memoX1 + _cursorScreenPos.x, _memoY1 + _cursorScreenPos.y) -- DRAW CURSOR
    end

    -- REVERTING ALL CHANGES MADE BEFORE
    setRectangleType(oldRectType)
    setColor(oldColor)
    setTextColor(oldTextColor)
    setBackgroundTextColor(oldBackgroundTextColor)
    end
end

function Memo:setCallback(_event, _callback)
    assert(type(_callback) == 'function', 'Memo.setCallback: callback must be a function, got '..type(_callback))
    if _event == 1 then
        self.callbacks.onDraw = _callback
    elseif _event == 2 then
        self.callbacks.onPress = _callback
    elseif _event == 3 then
        self.callbacks.onEdit = _callback
    elseif _event == 4 then
        self.callbacks.onCursorBlink = _callback
    end
end

function Memo:setCursorLimits(_char, _line)
    assert(type(_char) == 'number', 'Memo.setCursorLimits: char must be a number, got '..type(_char))
    assert(type(_line) == 'number', 'Memo.setCursorLimits: line must be a number, got '..type(_line))
    self.cursor.limits.char = _char
    self.cursor.limits.line = _line
end

function Memo:setCursorPos(_char, _line)
    assert(type(_char) == 'number', 'Memo.setCursorPos: char must be a number, got '..type(_char))
    assert(type(_line) == 'number', 'Memo.setCursorPos: line must be a number, got '..type(_line))

    if _char < 0 then -- IF CHAR POS IS LESS THAN 0 SET IT TO 0
        _char = 0
    end
    if _line < 0 then -- IF LINE POS IS LESS THAN 0 SET IT TO 0
        _line = 0
    end
    
    if self.cursor.limits.enabled then -- IF CURSOR LIMITS ARE ON
        if _char > self.cursor.limits.char then -- IF CHAR IS MORE THAN THE LIMIT SET IT TO IT
            _char = self.cursor.limits.char
        end
        if _line > self.cursor.limits.line then -- IF LINE IS MORE THAN THE LIMIT SET IT TO IT
            _line = self.cursor.limits.line
        end
    end

    if not self.lines[_line + 1] then -- IF SELECTED LINE DOESN'T EXISTS
        for i=#self.lines + 1, _line + 1 do -- CREATE EMPTY LINES UNTILL LINE POS
            self.lines[i] = ''
        end
    end
    if _char > #self.lines[_line + 1] then -- IF CHAR POS IS MORE THAN THE LINE LENGTH THEN SET CHAR TO IT
        _char = #self.lines[_line + 1]
    end
    self.cursor.pos.char = _char -- SET CHAR AND LINE POS TO MEMO CURSOR
    self.cursor.pos.line = _line

end

function Memo:edit(_loop, _event, _drawLoopGroup, _drawMonitorGroup)

    assert(type(_loop) == 'boolean', 'Memo.edit: loop must be a boolean, got '..type(_loop))

    if not _loop then -- IF LOOP ISN'T ENABLED THEN EVENT MUST BE SPECIFIED
        assert(type(_event) == 'table', 'Memo.edit: event must be a table, got '..type(_event))
    end

    if not self.hidden then -- IF MEMO ISN'T HIDDEN
        if not self.lines[1] then self:setCursorPos(0, 0); end -- IF FIRST LINE IS NULL THEN MAKE IT AN EMPTY STRING AND SELECT IT
        local function edit(self, event)
            self.callbacks.onEdit(self, event) -- CALL ON EDIT EVENT

            if self.cursor.limits.enabled then -- IF LIMITS ARE ACTIVE THEN
                if #self.lines > self.cursor.limits.line then -- IF LINES ARE MORE THAN THE ONES AVAILABLE THEN DELETE THEM
                    for i=self.cursor.limits.line + 1, #self.lines + 1 do
                        table.remove(self.lines, self.cursor.limits.line + 2)
                    end
                end
                for key, value in pairs(self.lines) do -- IF A LINE CONTAINS MORE CHARS THAN ALLOWED THEN DELETE THE EXTRA ONES
                    if #value > self.cursor.limits.char + 1 then
                        self.lines[key] = value:sub(1, self.cursor.limits.char + 1)
                    end
                end
            end

            if event[1] == 'monitor_touch' and (event[2] == globalMonitorName or (globalMonitorGroup.enabled and tableHas(globalMonitorGroup.list, event[2]))) then -- CHECK IF A BUTTON WAS PRESSED
                if checkAreaPress(self.pos.x1, self.pos.y1, self.pos.x2, self.pos.y2, event[3], event[4]) then
                    return true -- IF PRESS OUTSIDE MEMO THEN RETURN TRUE, ELSE FALSE
                else
                    return false
                end
            elseif event[1] == 'mouse_click' and (globalMonitorName == 'term' or (globalMonitorGroup.enabled and tableHas(globalMonitorGroup.list, 'term'))) then
                if checkAreaPress(self.pos.x1, self.pos.y1, self.pos.x2, self.pos.y2, event[3], event[4]) then
                    return true -- IF PRESS OUTSIDE MEMO THEN RETURN TRUE, ELSE FALSE
                else
                    return false
                end
            elseif event[1] == 'char' then
                local cursorLine = self.lines[self.cursor.pos.line + 1] -- GET LINE WHERE THE CURSOR IS LOCATED

                if self.cursor.limits.enabled then -- IF CURSOR LIMITS ARE ENABLED THEN
                    if self.cursor.pos.char - 1 < self.cursor.limits.char then -- IF CURSOR IS IN THE LIMITS THEN
                        self.lines[self.cursor.pos.line + 1] = cursorLine:sub( -- ADD CHAR TO THE LINE
                            0,
                            self.cursor.pos.char
                        )..event[2]..cursorLine:sub(
                            self.cursor.pos.char + 1,
                            #cursorLine
                        )

                        self.cursor.pos.char = self.cursor.pos.char + 1 -- MOVE CURSOR BY ONE ON THE X AXIS
                    end
                else -- IF CURSOR LIMITS ARE DISABLED THEN
                    self.lines[self.cursor.pos.line + 1] = cursorLine:sub( -- ADD CHAR TO THE LINE
                        0,
                        self.cursor.pos.char
                    )..event[2]..cursorLine:sub(
                        self.cursor.pos.char + 1,
                        #cursorLine
                    )

                    self.cursor.pos.char = self.cursor.pos.char + 1 -- MOVE CURSOR BY ONE ON THE X AXIS
                end

            elseif event[1] == 'key' then
                local cursorLine = self.lines[self.cursor.pos.line + 1] -- GET LINE WHERE THE CURSOR IS LOCATED

                if event[2] == 28 then -- ENTER KEY
                    if self.cursor.limits.enabled then -- IF LIMITS ARE ENABLED THEN
                        if #self.lines <= self.cursor.limits.line then -- IF THE NEXT LINE IS ALLOWED THEN
                            table.insert(self.lines, self.cursor.pos.line + 2, '') -- CREATE A NEW LINE

                            self.lines[self.cursor.pos.line + 1] = cursorLine:sub( -- KEEP THE TEXT BEFORE THE CURSOR ON THE OLD LINE
                                0,
                                self.cursor.pos.char
                            )
                            self.lines[self.cursor.pos.line + 2] = cursorLine:sub( -- PUT THE TEXT AFTER THE CURSOR ON THE NEW LINE
                                self.cursor.pos.char + 1,
                                #cursorLine
                            )..self.lines[self.cursor.pos.line + 2]
                            
                            self.cursor.pos.line = self.cursor.pos.line + 1 -- SET CURSOR POS LINE TO NEW LINE
                            self.cursor.pos.char = 0 -- SET CURSOR POS CHAR TO 0
                        end
                    else -- IF LIMITS AREN'T ENABLED THEN
                        table.insert(self.lines, self.cursor.pos.line + 2, '') -- CREATE A NEW LINE

                        self.lines[self.cursor.pos.line + 1] = cursorLine:sub( -- KEEP THE TEXT BEFORE THE CURSOR ON THE OLD LINE
                            0,
                            self.cursor.pos.char
                        )
                        self.lines[self.cursor.pos.line + 2] = cursorLine:sub( -- PUT THE TEXT AFTER THE CURSOR ON THE NEW LINE
                            self.cursor.pos.char + 1,
                            #cursorLine
                        )..self.lines[self.cursor.pos.line + 2]
                        
                        self.cursor.pos.line = self.cursor.pos.line + 1 -- SET CURSOR POS LINE TO NEW LINE
                        self.cursor.pos.char = 0 -- SET CURSOR POS CHAR TO 0
                    end
                elseif event[2] == 14 then -- BACKSPACE KEY
                    if self.cursor.pos.char > 0 then -- IF THE CURSOR ISN'T AT THE BEGINNING IF THE LINE THEN
                        self.lines[self.cursor.pos.line + 1] = cursorLine:sub( -- DELETE CHAR BEFORE CURSOR
                            0,
                            self.cursor.pos.char - 1
                        )..cursorLine:sub(
                            self.cursor.pos.char + 1,
                            #cursorLine
                        )
                        self.cursor.pos.char = self.cursor.pos.char - 1 -- SET CURSOR TO THE CHAR BEFORE THE ONE DELETED
                    elseif self.cursor.pos.line > 0 then -- IF CURSOR POS IS AT THE BEGINNING OF THE LINE AND NOT ON THE FIRST ONE THEN
                        local _endOfPreviousLine = #self.lines[self.cursor.pos.line] -- GET THE LINE BEFORE THE ONE WHERE THE CURSOR IS
                        if self.cursor.limits.enabled then -- IF CURSOR LIMITS ARE ENABLED THEN
                            if _endOfPreviousLine + #cursorLine <= self.cursor.limits.char + 1 then -- IF PREV LINE + CURR LINE IS LESS THAN CURSOR LIMITS THEN
                                self.lines[self.cursor.pos.line] = self.lines[self.cursor.pos.line]..cursorLine:sub( -- SET PREV LINE TO PREVLINE + CURRLINE
                                    self.cursor.pos.char + 1,
                                    #cursorLine
                                )
                                table.remove(self.lines, self.cursor.pos.line + 1) -- REMOVE CURRLINE
                                self.cursor.pos.line = self.cursor.pos.line - 1 -- SELECT PREV LINE
                                self.cursor.pos.char = _endOfPreviousLine -- SELECT END OF THE PREV LINE
                            end
                        else-- IF CURSOR LIMITS AREN'T ENABLED THEN
                            self.lines[self.cursor.pos.line] = self.lines[self.cursor.pos.line]..cursorLine:sub(-- SET PREV LINE TO PREVLINE + CURRLINE
                                self.cursor.pos.char + 1,
                                #cursorLine
                            )
                            table.remove(self.lines, self.cursor.pos.line + 1) -- REMOVE CURRLINE
                            self.cursor.pos.line = self.cursor.pos.line - 1 -- SELECT PREV LINE
                            self.cursor.pos.char = _endOfPreviousLine -- SELECT END OF THE PREV LINE
                        end
                    end

                elseif event[2] == 211 then -- CANC KEY
                    if self.cursor.pos.char > #cursorLine - 1 then -- IF CURSOR IS AT THE END OF THE LINE THEN
                        if self.lines[self.cursor.pos.line + 2] then -- IF THERE'S A NEXT LINE THEN
                            if self.cursor.limits.enabled then -- IF CURSOR LIMITS ARE ENABLED THEN
                                if #self.lines[self.cursor.pos.line + 2] + #cursorLine <= self.cursor.limits.char + 1 then -- IF CURR LINE + NEXT LINE ISN'T GREATER THAN CURSOR LIMITS THEN
                                    self.lines[self.cursor.pos.line + 1] = cursorLine..self.lines[self.cursor.pos.line + 2] -- SET CURR LINE TO CURRLINE + NEXTLINE
                                    table.remove(self.lines, self.cursor.pos.line + 2) -- REMOVE NEXT LINE
                                end
                            else -- IF CURSOR LIMITS AREN'T ENABLED THEN
                                self.lines[self.cursor.pos.line + 1] = cursorLine..self.lines[self.cursor.pos.line + 2] -- SET CURR LINE TO CURRLINE + NEXTLINE
                                table.remove(self.lines, self.cursor.pos.line + 2) -- REMOVE NEXT LINE
                            end
                        end

                    else -- IF CURSOR ISN'T AT THE END OF THE LINE THEN
                        self.lines[self.cursor.pos.line + 1] = cursorLine:sub( -- REMOVE CHAR ON THE CURSOR
                            0,
                            self.cursor.pos.char
                        )..cursorLine:sub(
                            self.cursor.pos.char + 2,
                            #cursorLine
                        )
                    end

                elseif event[2] == 203 then -- ARROW KEY LEFT
                    if self.cursor.pos.char > 0 then -- IF CURSOR POS IS GREATER THAN 0 THEN
                        self.cursor.pos.char = self.cursor.pos.char - 1 -- SET CURSOR POS CHAR TO PREV CHAR
                    else
                        if self.cursor.pos.line > 0 then -- IF IT ISN'T ON THE FIRST LINE THEN
                            self.cursor.pos.line = self.cursor.pos.line - 1 -- SET IT TO THE PREVIOUS ONE
                            self.cursor.pos.char = #self.lines[self.cursor.pos.line + 1]
                        end
                    end


                elseif event[2] == 205 then -- ARROW KEY RIGHT
                    if self.cursor.pos.char < #cursorLine then -- IF CURSOR ISN'T AT THE END OF TEXT IN THE LINE THEN
                        if self.cursor.limits.enabled then -- IF CURSOR LIMITS ARE ENABLED THEN
                            if self.cursor.pos.char < self.cursor.limits.char + 1 then -- IF THE CURSOR DOESN'T GO OUT OF THE LIMITS IF MOVED TO THE RIGHT THEN DO IT
                                self.cursor.pos.char = self.cursor.pos.char + 1
                            end
                        else
                            self.cursor.pos.char = self.cursor.pos.char + 1 -- MOVE CURSOR TO THE RIGHT
                        end
                    else
                        if self.lines[self.cursor.pos.line + 2] then -- IF A NEXT LINE EXISTS THEN
                            if self.cursor.limits.enabled then -- IF CURSOR LIMITS ARE ENABLED THEN
                                if self.cursor.pos.line < self.cursor.limits.line then -- IF NEXT LINE IS WITHIN THE LIMITS THEN
                                    self.cursor.pos.line = self.cursor.pos.line + 1 -- SET CURSOR TO IT
                                    self.cursor.pos.char = 0
                                end
                            else -- IF CURSOR LIMITS AREN'T ENABLED THEN
                                self.cursor.pos.line = self.cursor.pos.line + 1 -- SET CURSOR TO NEXT LINE
                                self.cursor.pos.char = 0
                            end
                        end
                    end


                elseif event[2] == 200 then -- ARROW KEY UP
                    if self.cursor.pos.line > 0 then -- IF IT ISN'T ON THE FIRST LINE THEN
                        self.cursor.pos.line = self.cursor.pos.line - 1 -- SET IT TO THE PREVIOUS ONE
                        if self.cursor.pos.char > #self.lines[self.cursor.pos.line + 1] then -- IF CURSOR POS CHAR IS GREATER THEN THE END OF THE TEXT ON PREV LINE THEN SET IT TO THE END OF IT
                            self.cursor.pos.char = #self.lines[self.cursor.pos.line + 1]
                        end
                    end


                elseif event[2] == 208 then -- ARROW KEY DOWN
                    if self.lines[self.cursor.pos.line + 2] then -- IF A NEXT LINE EXISTS THEN
                        if self.cursor.limits.enabled then -- IF CURSOR LIMITS ARE ENABLED THEN
                            if self.cursor.pos.line < self.cursor.limits.line then -- IF NEXT LINE IS WITHIN THE LIMITS THEN
                                self.cursor.pos.line = self.cursor.pos.line + 1 -- SET CURSOR TO IT
                                if self.cursor.pos.char > #self.lines[self.cursor.pos.line + 1] then -- IF CURSOR POS CHAR IS GREATER THEN THE END OF THE TEXT ON NEXT LINE THEN SET IT TO THE END OF IT
                                    self.cursor.pos.char = #self.lines[self.cursor.pos.line + 1]
                                end
                            end
                        else -- IF CURSOR LIMITS AREN'T ENABLED THEN
                            self.cursor.pos.line = self.cursor.pos.line + 1 -- SET CURSOR TO NEXT LINE
                            if self.cursor.pos.char > #self.lines[self.cursor.pos.line + 1] then -- IF CURSOR POS CHAR IS GREATER THEN THE END OF THE TEXT ON NEXT LINE THEN SET IT TO THE END OF IT
                                self.cursor.pos.char = #self.lines[self.cursor.pos.line + 1]
                            end
                        end
                    end
                end
            
            end
            self:draw()
            return true -- IF EDIT SUCCESFUL RETURN TRUE
        end

        self:draw()

        local cursorVisibility
        local Clock
        local blinkClock
        if _loop then
            cursorVisibility = self.cursor.visible -- BACKUP CURSOR VISIBILITY STATE AND SETUP CLOCKS
            Clock = os.clock()
            blinkClock = os.clock()
        end

        while _loop do -- IF LOOP IS ACTIVE THEN

            local Timer = os.startTimer(globalLoop.timerSpeed) -- START A TIMER

            _event = {os.pullEvent()} -- GET EVENTS

            if not edit(self, _event) then -- IF THE SCREEN WAS PRESSED OUTSIDE THE MEMO THEN BREAK LOOP
                break
            end

            if os.clock() >= blinkClock + self.cursor.blinkSpeed then -- BLINK :)

                blinkClock = os.clock() -- UPDATE BLINKCLOCK
                self.callbacks.onCursorBlink(self, _event) -- CALL ONCURSORBLINK CALLBACK
                self.cursor.visible = not self.cursor.visible -- INVERT CURSOR VISIBILITY
            end

            if _event[1] == 'timer' then -- IF TIMER GAVE AN EVENT THEN
                if _drawLoopGroup then -- IF DRAWLOOPGROUP THEN DO IT
                    if _drawMonitorGroup and globalMonitorGroup.enabled then -- IF MONITOR GROUP WAS DECIDED TO BE DRAWN THEN DO IT
                        globalLoop.callbacks.onMonitorChange(monitorName, _event)
                        for _, obj in pairs(globalLoop.group) do -- DRAW ALL BUTTONS
                            obj:draw()
                        end
                        local oldMonitor = globalMonitorName
                        for _, monitorName in pairs(globalMonitorGroup.list) do
                            setMonitor(monitorName)
                            globalLoop.callbacks.onMonitorChange(monitorName, _event)
                            for _, obj in pairs(globalLoop.group) do -- DRAW ALL BUTTONS
                                obj:draw()
                            end
                        end
                        setMonitor(oldMonitor)
                    else -- DON'T DRAW MONITOR GROUP, DRAW ONLY ON GLOBALMONITOR
                        for _, obj in pairs(globalLoop.group) do -- DRAW ALL BUTTONS
                            obj:draw()
                        end
                    end
                end
            end

            os.cancelTimer(Timer) -- CANCEL TIMER
        end

        if not _loop then
            edit(self, _event)
        end

        if _loop then self.cursor.visible = cursorVisibility; end

    end
end


function Memo:update(_x, _y, _event)
    assert(type(_x) == 'number', 'Memo.update: x must be a number, got '..type(_x))
    assert(type(_y) == 'number', 'Memo.update: y must be a number, got '..type(_y))

    if not self.hidden then
        if checkAreaPress(self.pos.x1, self.pos.y1, self.pos.x2, self.pos.y2, _x, _y) then -- CHECK IF IT WAS PRESSED
            -- IF THE MEMO WAS PRESSED CALL CALLBACK
            self.callbacks.onPress(self, _event)
            return true
        else
            return false
        end
    end
    return false
end

function Memo:limits(_bool)
    assert(type(_bool) == 'boolean', 'Memo.limits: bool must be a boolean, got '..type(_bool))
    self.cursor.limits.enabled = _bool
end

function Memo:hideCursor(_bool)
    assert(type(_bool) == 'boolean', 'Memo.hideCursor: bool must be a boolean, got '..type(_bool))
    self.cursor.visible = not _bool
end

function Memo:hide(_bool)
    assert(type(_bool) == 'boolean', 'Memo.hide: bool must be a boolean, got '..type(_bool))
    self.hidden = _bool
end

Memo.__index = Memo

--//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////--

function drawOnLoopClock()
    globalLoop.drawOnClock = true
end

function drawOnLoopEvent()
    globalLoop.drawOnClock = false
end

function setLoopClockSpeed(_sec)
    assert(type(_sec) == 'number', 'setLoopClockSpeed: sec must be a number, got '..type(_sec))
    globalLoop.clockSpeed = _sec
end

function setLoopTimerSpeed(_sec)
    assert(type(_sec) == 'number', 'setLoopTimerSpeed: sec must be a number, got '..type(_sec))
    globalLoop.timerSpeed = _sec
end

function setLoopCallback(_event, _callback)
    assert(type(_callback) == 'function', 'setLoopCallback: callback must be a function, got '..type(_callback))
    if _event == 1 then
        globalLoop.callbacks.onInit = _callback
    elseif _event == 2 then
        globalLoop.callbacks.onClock = _callback
    elseif _event == 3 then
        globalLoop.callbacks.onEvent = _callback
    elseif _event == 4 then
        globalLoop.callbacks.onTimer = _callback
    elseif _event == 5 then
        globalLoop.callbacks.onMonitorChange = _callback
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
    if globalMonitorGroup.enabled then
        globalLoop.callbacks.onMonitorChange(monitorName)
        for _, obj in pairs(globalLoop.group) do -- DRAW ALL BUTTONS
            obj:draw()
        end
        local oldMonitor = globalMonitorName
        for _, monitorName in pairs(globalMonitorGroup.list) do
            setMonitor(monitorName)
            globalLoop.callbacks.onMonitorChange(monitorName)
            for _, obj in pairs(globalLoop.group) do -- DRAW ALL BUTTONS
                obj:draw()
            end
        end
        setMonitor(oldMonitor)
    else
        for _, obj in pairs(globalLoop.group) do -- DRAW ALL BUTTONS
            obj:draw()
        end
    end

    local Clock = os.clock()

    while globalLoop.enabled do

        local Timer = os.startTimer(globalLoop.timerSpeed) -- START A TIMER

        local event = {os.pullEvent()} -- PULL EVENTS

        -- EVENT
        if event[1] == 'monitor_touch' and (event[2] == globalMonitorName or (globalMonitorGroup.enabled and tableHas(globalMonitorGroup.list, event[2]))) then -- CHECK IF A BUTTON WAS PRESSED
            for _, obj in pairs(globalLoop.group) do
                obj:update(event[3], event[4], event)
            end
        elseif event[1] == 'mouse_click' and (globalMonitorName == 'term' or (globalMonitorGroup.enabled and tableHas(globalMonitorGroup.list, 'term'))) then
            for _, obj in pairs(globalLoop.group) do
                obj:update(event[3], event[4], event)
            end
        elseif event[1] == 'timer' then
            globalLoop.callbacks.onTimer(event)
        end

        -- CLOCK
        if os.clock() >= Clock + globalLoop.clockSpeed then

            Clock = os.clock()

            if globalLoop.drawOnClock then -- CLOCK DRAW
                if globalLoop.autoClear then
                    bClear()
                end
                globalLoop.callbacks.onClock(event) -- TIMER CALLBACK
                if globalMonitorGroup.enabled then
                    globalLoop.callbacks.onMonitorChange(monitorName, event)
                    for _, obj in pairs(globalLoop.group) do -- DRAW ALL BUTTONS
                        obj:draw()
                    end
                    local oldMonitor = globalMonitorName
                    for _, monitorName in pairs(globalMonitorGroup.list) do
                        setMonitor(monitorName)
                        globalLoop.callbacks.onMonitorChange(monitorName, event)
                        for _, obj in pairs(globalLoop.group) do -- DRAW ALL BUTTONS
                            obj:draw()
                        end
                    end
                    setMonitor(oldMonitor)
                else
                    for _, obj in pairs(globalLoop.group) do -- DRAW ALL BUTTONS
                        obj:draw()
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
            if globalMonitorGroup.enabled then
                globalLoop.callbacks.onMonitorChange(monitorName, event)
                for _, obj in pairs(globalLoop.group) do -- DRAW ALL BUTTONS
                    obj:draw()
                end
                local oldMonitor = globalMonitorName
                for _, monitorName in pairs(globalMonitorGroup.list) do
                    setMonitor(monitorName)
                    globalLoop.callbacks.onMonitorChange(monitorName, event)
                    for _, obj in pairs(globalLoop.group) do -- DRAW ALL BUTTONS
                        obj:draw()
                    end
                end
                setMonitor(oldMonitor)
            else
                for _, obj in pairs(globalLoop.group) do -- DRAW ALL BUTTONS
                    obj:draw()
                end
            end
        else
            globalLoop.callbacks.onEvent(event) -- EVENT CALLBACK
        end

        os.cancelTimer(Timer) -- DELETE TIMER
    end
end