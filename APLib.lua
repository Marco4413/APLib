
ver = '0.3'
globalMonitor = term

--DRAWING
globalColor = colors.white
globalTextColor = colors.white
globalBackgroundTextColor = colors.black
globalRectangleType = 1

--LOOPS
globalLoop = {
    enabled = false,
    drawOnlyOnTick = false,
    speed = 0.5,
    callbacks = {
        onEvent = function() end,
        onTimer = function() end
    },
    group = {}
}

--HELPERS
rectangleTypes = {filled = 1, hollow = 2}

event = {
    button = {
        onDraw = 1,
        onPress = 2
    },
    percentagebar = {
        onDraw = 1,
        onPress = 2
    },
    loop = {
        onEvent = 1,
        onTimer = 2
    }
}

function bClear()
    globalMonitor.clear()
    globalMonitor.setCursorPos(1, 1)
end

function setMonitor(_monitor)
    assert(_monitor.write, 'setMonitor: monitor must be a valid monitor')
    globalMonitor = _monitor --SET GLOBALMONITOR TO MONITOR
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
    assert(type(_type) == 'number', 'rectangleType: type must be a number, got '..type(_type))
    globalRectangleType = _type
end

function text(_x, _y, _text)
    assert(type(_x) == 'number', 'Text: x must be a number, got '..type(_x))
    assert(type(_y) == 'number', 'Text: y must be a number, got '..type(_y))
    assert((type(_text) == 'string') or (type(_text) == 'string'), 'Text: text must be either a string or a number, got '..type(_text))

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
            if self.colors.backgroundBarColor then -- CHECK IF PBBGC IS SPECIFIED
                setBackgroundTextColor(self.colors.backgroundBarColor)
            else -- IF NOT SPECIFIED
                setBackgroundTextColor(backgroundColor)
            end
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

PercentageBar.__index = PercentageBar

--//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////--

function setLoopDrawOnlyOnTick(_bool)
    assert(type(_bool) == 'boolean', 'setLoopDrawOnlyOnTick: bool must be a boolean, got '..type(_bool))
    globalLoop.drawOnlyOnTick = _bool
end

function setLoopTickSpeed(_sec)
    assert(type(_sec) == 'number', 'setLoopTickSpeed: sec must be a number, got '..type(_sec))
    globalLoop.speed = _sec
end

function setLoopCallback(_event, _callback)
    assert(type(_callback) == 'function', 'setLoopCallback: callback must be a function, got '..type(_callback))
    if _event == 1 then
        globalLoop.callbacks.onEvent = _callback
    elseif _event == 2 then
        globalLoop.callbacks.onTimer = _callback
    end
end

function stopLoop()
    globalLoop.enabled = false --STOP LOOP

    for key in pairs(globalLoop.group) do
        globalLoop.group[key].callbacks.onUpdateLoop = function() end
    end

    globalLoop.group = {} --CLEAR LOOP GROUP
end

function loop(_group)
    assert(type(_group) == 'table', 'Loop: group must be a table, got '..type(_group))
    globalLoop.enabled = true -- ACTIVATE LOOP
    globalLoop.group = _group -- SET GLOBAL LOOP GROUP

    bClear()
    for key in pairs(globalLoop.group) do -- DRAW ALL BUTTONS BEFORE STARTING LOOP
        globalLoop.group[key]:draw()
    end

    local Timer = false

    while globalLoop.enabled do

        if not Timer then
            Timer = os.startTimer(globalLoop.speed) -- START A TIMER
        end

        local event = {os.pullEvent()} -- PULL EVENTS

        if event[1] == 'monitor_touch' or event[1] == 'mouse_click' then -- CHECK IF A BUTTON WAS PRESSED
            for key in pairs(globalLoop.group) do
                globalLoop.group[key]:update(event[3], event[4], event)
            end
        end

        if (event[1] == 'timer') then
            
            if globalLoop.drawOnlyOnTick then -- TICK DRAW
                bClear()
                for key in pairs(globalLoop.group) do -- DRAW ALL BUTTONS
                    globalLoop.group[key]:draw()
                end
            end

            globalLoop.callbacks.onTimer(event) -- TIMER CALLBACK
            os.cancelTimer(Timer) -- DELETE TIMER
            Timer = false
        end

        if not globalLoop.drawOnlyOnTick then -- NON TICK DRAW
            bClear()
            for key in pairs(globalLoop.group) do -- DRAW ALL BUTTONS
                globalLoop.group[key]:draw()
            end
        end

        globalLoop.callbacks.onEvent(event) -- EVENT CALLBACK
    end
end