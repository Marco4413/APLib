
ver = '1.12.3'
globalMonitor = term
globalMonitorName = 'term'
globalMonitorGroup = {
    enabled = false,
    list = {}
}
globalMonitorWidth, globalMonitorHeight = globalMonitor.getSize()

--DRAWING
globalColor = colors.white
globalTextColor = colors.white
globalBackgroundTextColor = colors.black
globalRectangleType = 1

--LOOPS
globalLoop = {
    enabled = false,
    autoClear = true,
    drawOnClock = true,
    clockSpeed = 0.5,
    timerSpeed = 0.1,
    clock = 0,
    APLWDBroadcastOnClock = false,
    APLWDClearCacheOnDraw = true,
    FPS = {
        value = 0,
        counter = {
            enabled = false,
            offsets = {
                x = 0,
                y = 0
            },
            colors = {
                textColor = globalTextColor,
                backgroundTextColor = nil
            }
        }
    },
    callbacks = {
        onInit = function() end,
        onClock = function() end,
        onEvent = function() end,
        onTimer = function() end,
        onMonitorChange = function() end
    },
    events = {
        tick = {},
        key = {},
        char = {}
    },
    wasGroupChanged = false,
    selectedGroup = 'none',
    group = {
        none = {},
        LIBPrivate = {}
    }
}

--GLOBALCALLBACKS
globalCallbacks = {
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
    clock = {
        onClock = 1
    },
    header = {
        onDraw = 1,
        onPress = 2,
        onFailedPress = 3
    },
    label = {
        onDraw = 1,
        onPress = 2,
        onFailedPress = 3
    },
    button = {
        onDraw = 1,
        onPress = 2,
        onFailedPress = 3
    },
    menu = {
        onDraw = 1,
        onPress = 2,
        onFailedPress = 3,
        onButtonPress = 4,
        onFailedButtonPress = 5
    },
    percentagebar = {
        onDraw = 1,
        onPress = 2,
        onFailedPress = 3
    },
    memo = {
        onDraw = 1,
        onPress = 2,
        onFailedPress = 3,
        onEdit = 4,
        onCursorBlink = 5,
        onActivated = 6,
        onDeactivated = 7
    },
    loop = {
        onInit = 1,
        onClock = 2,
        onEvent = 3,
        onTimer = 4,
        onMonitorChange = 5
    }
}

function stringSplit(_string, _separator)
    _string = tostring(_string)
    _separator = tostring(_separator)

    local _words = {} -- CREATE THE RETURN TABLE
    while true do -- LOOP
        local pos = _string:find(_separator)
        if pos then -- IF SEPARATOR IS IN STRING THEN
            table.insert(_words, _string:sub(1, pos - 1)) -- PUT THE SEPARATED STRING INTO WORDS
            _string = _string:sub(pos + 1) -- REMOVE THE STRING THAT WAS PUT INTO WORDS FROM STRING
        else
            table.insert(_words, _string)
            break
        end
    end

    return _words
end

function tableHas(_table, _value)
    assert(type(_table) == 'table', 'tableHas: table must be a table, got '..type(_table))
    for key, value in pairs(_table) do
        if value == _value then
            return true
        end
    end
    return false
end

OSSettings = {
    settingsPath = '/.settings', -- PUT SETTINGS PATH IN OSSETTINGS

    set = function (_entry, _value)
        assert(type(_value) ~= 'nil', "OSSettings.set: value can't be nil, got "..type(_value))
        settings.set(tostring(_entry), _value) -- SET SETTINGS VALUE
        return settings.save(OSSettings.settingsPath) -- SAVE SETTINGS
    end,

    get = function (_entry) -- COPY SETTING'S get FUNCTION
        return settings.get(tostring(_entry))
    end,

    getNames = function () -- COPY SETTING'S getNames FUNCTION
        return settings.getNames()
    end,

    unset = function (_entry)
        settings.unset(tostring(_entry)) -- UNSET SETTINGS VALUE
        return settings.save(OSSettings.settingsPath) -- SAVE SETTINGS
    end
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
    _monitorName = tostring(_monitorName)
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

APLWD = {
    enabled = false,
    protocol = 'APLWD-'..ver,
    senderName = 'SendeR',
    receiverName = 'ReceiveR',
    isReceiver = true,
    myName = '',
    senderID = '',
    modemName = '',
    cache = {}
}

APLWD.enable = function (_bool)
    assert(type(_bool) == 'boolean', 'APLWD.enable: bool must be a boolean, got '..type(_bool))
    APLWD.enabled = _bool
end

APLWD.enableBroadcastOnLoopClock = function (_bool)
    assert(type(_bool) == 'boolean', 'APLWD.enableBroadcastOnLoopClock: bool must be a boolean, got '..type(_bool))
    globalLoop.APLWDBroadcastOnClock = _bool
end

APLWD.enableClearCacheOnLoopDraw = function (_bool)
    assert(type(_bool) == 'boolean', 'APLWD.enableClearCacheOnLoopDraw: bool must be a boolean, got '..type(_bool))
    globalLoop.APLWDClearCacheOnDraw = _bool
end

APLWD.host = function (_modemName, _hostname)
    if APLWD.enabled then
        _modemName = tostring(_modemName)

        if _hostname then -- IF HOSTNAME ISN'T SPECIFIED SET IT TO COMPUTER'S ID
            _hostname = tostring(_hostname)
        else
            _hostname = tostring(os.getComputerID())
        end
        
        -- MAKE SURE THAT MODEMNAME IS A MODEM
        assert(tostring(peripheral.getType(_modemName)) == 'modem', 'APLWD.host: modemName must be a modem, got '..tostring(peripheral.getType(_modemName)))

        rednet.open(_modemName) -- OPEN REDNET CONNECTION
        if rednet.lookup(APLWD.protocol, APLWD.senderName.._hostname) then -- IF HOSTNAME WAS ALREADY TAKEN THEN ERROR
            rednet.close(_modemName)
            error("APLWD.host: There's already someone connected with hostname: ".._hostname)
        end
        rednet.host(APLWD.protocol, APLWD.senderName.._hostname) -- HOST APLWD ON HOSTNAME

        APLWD.isReceiver = false
        APLWD.myName = APLWD.senderName.._hostname
        APLWD.modemName = _modemName
    end
end

APLWD.connect = function (_modemName, _senderName, _hostname)
    if APLWD.enabled then
        _modemName = tostring(_modemName)

        if _hostname then -- IF HOSTNAME ISN'T SPECIFIED SET IT TO COMPUTER'S ID
            _hostname = tostring(_hostname)
        else
            _hostname = tostring(os.getComputerID())
        end

        _senderName = tostring(_senderName)

        -- MAKE SURE THAT MODEMNAME IS A MODEM
        assert(tostring(peripheral.getType(_modemName)) == 'modem', 'APLWD.connect: modemName must be a modem, got '..tostring(peripheral.getType(_modemName)))

        rednet.open(_modemName) -- OPEN REDNET CONNECTION
        if rednet.lookup(APLWD.protocol, APLWD.receiverName.._hostname) then -- IF HOSTNAME WAS ALREADY TAKEN THEN ERROR
            rednet.close(_modemName)
            error("APLWD.connect: There's already someone connected with hostname: ".._hostname)
        end
        
        -- GET ID OF THE SENDER
        local _senderID = rednet.lookup(APLWD.protocol, APLWD.senderName.._senderName)
        if not _senderID then -- IF NO SENDER WAS FOUND THEN ERROR
            rednet.close(_modemName)
            error("APLWD.connect: Didn't find any sender with name: ".._senderName)
        end
        
        rednet.host(APLWD.protocol, APLWD.receiverName.._hostname) -- HOST APLWD ON HOSTNAME
        
        APLWD.isReceiver = true
        APLWD.myName = APLWD.receiverName.._hostname
        APLWD.senderID = _senderID
        APLWD.modemName = _modemName
    end
end

APLWD.close = function ()
    if APLWD.modemName ~= '' then
        if not APLWD.isReceiver then -- IF IS A SENDER THAN BROADCAST TO RECEIVERS THAT SENDER DISCONNECTED
            rednet.broadcast('disconnected', APLWD.protocol)
        end
        rednet.unhost(APLWD.protocol, APLWD.myName) -- UNHOST COMPUTER
        rednet.close(APLWD.modemName) -- CLOSE REDNET CONNECTION
        
        APLWD.enable(false)
        APLWD.clearCache() -- CLEAR CACHE AND RESET EVERY SETTING
        APLWD.isReceiver = true
        APLWD.myName = ''
        APLWD.senderID = ''
        APLWD.modemName = ''
    end
end

APLWD.broadcastCache = function ()
    if APLWD.enabled then
        local _rednetConnection = rednet.isOpen()
        assert(_rednetConnection, 'APLWD.broadcastCache: rednet connection must be opened first, connection '..tostring(_rednetConnection))

        rednet.broadcast(APLWD.cache, APLWD.protocol)
        APLWD.clearCache()
    end
end

APLWD.receiveCache = function (_timeout)
    if APLWD.enabled then
        local _rednetConnection = rednet.isOpen()
        assert(_rednetConnection, 'APLWD.receiveCache: rednet connection must be opened first, connection '..tostring(_rednetConnection))

        local _senderID, _message, _protocol = rednet.receive(APLWD.protocol, tonumber(_timeout))
        if type(_message) == 'table' then
            if _senderID == APLWD.senderID then
                APLWD.cache = _message
                return true
            end
        elseif _message == 'disconnected' then
            APLWD.close()
            return 'disconnected'
        end
        return false
    end
end

APLWD.drawCache = function ()
    if APLWD.enabled then
        local function drawCache()
            for key, value in pairs(APLWD.cache) do
                if value.type == 'point' then
                        
                    local oldColor = globalColor
                    
                    setColor(value.color)
                    point(value.pos.x, value.pos.y)

                    setColor(oldColor)

                elseif value.type == 'text' then

                    local oldTextColor = globalTextColor
                    local oldBackgroundTextColor = globalBackgroundTextColor

                    setTextColor(value.colors.textColor)
                    setBackgroundTextColor(value.colors.backgroundTextColor)
                    text(value.pos.x, value.pos.y, value.text)

                    setTextColor(oldTextColor)
                    setBackgroundTextColor(oldBackgroundTextColor)

                elseif value.type == 'background' then
                    setBackground(value.color)
                end
            end
        end

        if globalMonitorGroup.enabled then -- CHECKS IF MONITORGROUP IS ENABLED
            globalLoop.callbacks.onMonitorChange(monitorName) -- CALLS onMonitorChange EVENT
            drawCache()
            local oldMonitor = globalMonitorName -- SAVES ORIGINAL MONITOR
            for _, monitorName in pairs(globalMonitorGroup.list) do -- LOOPS THROUGH ALL MONITORS
                if monitorName ~= oldMonitor then -- DRAW ONLY ON MONITOR THAT WASN'T THE GLOBAL ONE
                    setMonitor(monitorName)
                    globalLoop.callbacks.onMonitorChange(monitorName)
                    drawCache()
                end
            end
            setMonitor(oldMonitor) -- RESETS TO ORIGINAL MONITOR
        else
            drawCache()
        end

        APLWD.clearCache()
    end
end

APLWD.clearCache = function ()
    APLWD.cache = {}
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
    if not APLWD.isReceiver then
        table.insert(
            APLWD.cache,
            {
                type = 'background',
                color = _color
            }
        )
    end
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
    
    if not APLWD.isReceiver then
        table.insert(
            APLWD.cache,
            {
                type = 'text',
                text = _text,
                pos = {
                    x = _x,
                    y = _y
                },
                colors = {
                    textColor = globalTextColor,
                    backgroundTextColor = globalBackgroundTextColor
                }
            }
        )
    end
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
    
    if not APLWD.isReceiver then
        table.insert(
            APLWD.cache,
            {
                type = 'point',
                pos = {
                    x = _x,
                    y = _y
                },
                color = globalColor
            }
        )
    end
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

Clock = {}

function Clock.new(_interval)

    assert(type(_interval) == 'number', 'Clock.new: interval must be a number, got '..type(_y))

    --CREATE CLOCK
    _newClock = {
        clock = os.clock(),
        interval = _interval,
        callbacks = {
            onClock = function() end
        }
    }
    setmetatable(_newClock, Clock) --SET CLOCK METATABLE
    return _newClock
end

function Clock:setCallback(_event, _callback)
    assert(type(_callback) == 'function', 'Clock.setCallback: callback must be a function, got '..type(_callback))
    if _event == 1 then
        self.callbacks.onClock = _callback
    end
end

function Clock:draw() end

function Clock:update() return false; end

function Clock:tick(_event)
    -- CLOCK
    if os.clock() >= self.clock + self.interval then
        self.clock = os.clock()
        self.callbacks.onClock(self, _event)
        return true
    end
    return false
end

Clock.__index = Clock

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
            onPress = function() end,
            onFailedPress = function() end
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
    elseif _event == 3 then
        self.callbacks.onFailedPress = _callback
    end
end

function Header:update(_x, _y, _event, _cantUpdate)
    assert(type(_x) == 'number', 'Header.update: x must be a number, got '..type(_x))
    assert(type(_y) == 'number', 'Header.update: y must be a number, got '..type(_y))

    if not self.hidden then
        if not _cantUpdate then
            self.pos.x = math.floor((globalMonitorWidth - string.len(self.text) + 1) / 2) -- RECALC SCREEN CENTRE
            local _x2 = self.pos.x + string.len(self.text) - 1 -- CALCULATE X2
            if checkAreaPress(self.pos.x, self.pos.y, _x2, self.pos.y, _x, _y) then -- CHECK IF IT WAS PRESSED
                -- IF THE HEADER WAS PRESSED CALL CALLBACK
                self.callbacks.onPress(self, _event)
                return true
            else
                self.callbacks.onFailedPress(self, _event)
                return false
            end
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
            onPress = function() end,
            onFailedPress = function() end
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
    elseif _event == 3 then
        self.callbacks.onFailedPress = _callback
    end
end

function Label:update(_x, _y, _event, _cantUpdate)
    assert(type(_x) == 'number', 'Label.update: x must be a number, got '..type(_x))
    assert(type(_y) == 'number', 'Label.update: y must be a number, got '..type(_y))

    if not self.hidden then
        if not _cantUpdate then
            local _x2 = self.pos.x + string.len(self.text) - 1 -- CALCULATE X2
            if checkAreaPress(self.pos.x, self.pos.y, _x2, self.pos.y, _x, _y) then -- CHECK IF IT WAS PRESSED
                -- IF THE LABEL WAS PRESSED CALL CALLBACK
                self.callbacks.onPress(self, _event)
                return true
            else
                self.callbacks.onFailedPress(self, _event)
                return false
            end
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
            onPress = function() end,
            onFailedPress = function() end
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
    elseif _event == 3 then
        self.callbacks.onFailedPress = _callback
    end
end

function Button:update(_x, _y, _event, _cantUpdate)
    assert(type(_x) == 'number', 'Button.update: x must be a number, got '..type(_x))
    assert(type(_y) == 'number', 'Button.update: y must be a number, got '..type(_y))

    if not self.hidden then
        if not _cantUpdate then
            if checkAreaPress(self.pos.x1, self.pos.y1, self.pos.x2, self.pos.y2, _x, _y) then -- CHECK IF IT WAS PRESSED
                -- IF THE BUTTON WAS PRESSED CALL CALLBACK
                self.state = not self.state
                self.callbacks.onPress(self, _event)
                return true
            else
                self.callbacks.onFailedPress(self, _event)
                return false
            end
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

Menu = {}

function Menu.new(_x1, _y1, _x2, _y2, _color)
    
    assert(type(_x1) == 'number', 'Menu.new: x1 must be a number, got '..type(_x1))
    assert(type(_y1) == 'number', 'Menu.new: y1 must be a number, got '..type(_y1))
    assert(type(_x2) == 'number', 'Menu.new: x2 must be a number, got '..type(_x2))
    assert(type(_y2) == 'number', 'Menu.new: y2 must be a number, got '..type(_y2))
    
    --FIX THINGS
    _color = tonumber(_color)

    --CHECK THINGS
    if not _color then
        _color = globalColor
    end

    --CREATE MENU
    _newMenu = {
        color = _color,
        objs = {},
        hidden = true,
        pos = {
            x1 = _x1,
            y1 = _y1,
            x2 = _x2,
            y2 = _y2
        },
        callbacks = {
            onDraw = function() end,
            onPress = function() end,
            onFailedPress = function() end,
            onButtonPress = function() end,
            onFailedButtonPress = function() end
        }
    }
    setmetatable(_newMenu, Menu) --SET MENU METATABLE
    return _newMenu
end

function Menu:draw()
    if not self.hidden then
        self.callbacks.onDraw(self)

        local oldRectType = globalRectangleType
        local oldColor = globalColor
        
        --SETTING THINGS TO MENU SETTINGS
        setColor(self.color)

        --DRAWING MENU
        rectangle(self.pos.x1, self.pos.y1, self.pos.x2, self.pos.y2)
        
        for key, obj in pairs(self.objs) do -- DRAW OBJs THAT ARE ATTACHED TO IT
            obj:draw()
        end

        --REVERTING ALL CHANGES MADE BEFORE
        setColor(oldColor)
    end
end

function Menu:setCallback(_event, _callback)
    assert(type(_callback) == 'function', 'Menu.setCallback: callback must be a function, got '..type(_callback))
    if _event == 1 then
        self.callbacks.onDraw = _callback
    elseif _event == 2 then
        self.callbacks.onPress = _callback
    elseif _event == 3 then
        self.callbacks.onFailedPress = _callback
    elseif _event == 4 then
        self.callbacks.onButtonPress = _callback
    elseif _event == 5 then
        self.callbacks.onFailedButtonPress = _callback
    end
end

function Menu:set(_table, _fillMenu)
    for key, obj in pairs(_table) do
        assert(getmetatable(obj) == Button, 'Menu.set: you can only attach buttons to menus.')
    end

    local menu_width = math.abs(self.pos.x2 - self.pos.x1) + 1 -- GET MENU WIDTH & HEIGHT
    local menu_height = math.abs(self.pos.y2 - self.pos.y1) + 1

    for i=menu_height + 1, #_table do -- REMOVE EXTRA OBJs
        table.remove(_table, menu_height + 1)
    end

    local objHeight = math.floor(menu_height / #_table) -- GET OBJs HEIGHT NEEDED TO FILL SCREEN

    local _menuX1, _menuX2, _menuY1, _menuY2

    if self.pos.x1 > self.pos.x2 then -- SORT MENU POS
        _menuX1 = self.pos.x2
        _menuX2 = self.pos.x1
    else
        _menuX1 = self.pos.x1
        _menuX2 = self.pos.x2
    end

    if self.pos.y1 > self.pos.y2 then
        _menuY1 = self.pos.y2
        _menuY2 = self.pos.y1
    else
        _menuY1 = self.pos.y1
        _menuY2 = self.pos.y2
    end

    for key, obj in pairs(_table) do -- SET OBJ POS TO BE IN THE MENU
        obj.pos.x1 = _menuX1
        obj.pos.x2 = _menuX2

        if _fillMenu then -- TRY TO FILL MENU WITH OBJs
            obj.pos.y1 = _menuY1 + (key - 1) * objHeight
            obj.pos.y2 = _menuY1 + (key - 1) * objHeight + objHeight - 1
        else
            obj.pos.y1 = _menuY1 + (key - 1)
            obj.pos.y2 = _menuY1 + (key - 1)
        end

        obj.text = string.sub(obj.text, 0, menu_width)
        table.insert(self.objs, obj)
    end
end

function Menu:update(_x, _y, _event, _cantUpdate)
    assert(type(_x) == 'number', 'Menu.update: x must be a number, got '..type(_x))
    assert(type(_y) == 'number', 'Menu.update: y must be a number, got '..type(_y))

    if not self.hidden then
        if not _cantUpdate then
            if checkAreaPress(self.pos.x1, self.pos.y1, self.pos.x2, self.pos.y2, _x, _y) then -- CHECK IF IT WAS PRESSED
                -- IF THE MENU WAS PRESSED CALL CALLBACK
                self.callbacks.onPress(self, _event)
                for key, obj in pairs(self.objs) do -- UPDATE OBJs THAT ARE ATTACHED TO IT
                    if obj:update(_x, _y, _event) then
                        self.callbacks.onButtonPress(self, obj, _event)
                        break
                    else
                        self.callbacks.onFailedButtonPress(self, obj, _event)
                    end
                end
                return true
            else
                self.callbacks.onFailedPress(self, _event)
                return false
            end
        end
    end
    return false
end

function Menu:hide(_bool)
    assert(type(_bool) == 'boolean', 'Menu.hide: bool must be a boolean, got '..type(_bool))
    self.hidden = _bool
end

Menu.__index = Menu

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
            drawOnPB = true,
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
            onPress = function() end,
            onFailedPress = function() end
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

        local _barX2 = self.pos.x1 + ((self.pos.x2 - self.pos.x1) * self.value.percentage / 100)

        if self.colors.backgroundBarColor then -- DRAW PERCENTAGE BAR WITH BACKGROUND
            setColor(self.colors.backgroundBarColor)
            rectangle(self.pos.x1, self.pos.y1, self.pos.x2, self.pos.y2)

            if self.value.percentage > 0 then
                setColor(self.colors.barColor)
                rectangle(self.pos.x1, self.pos.y1, _barX2, self.pos.y2)
            end
        else -- DRAW PERCENTAGE BAR WITHOUT BACKGROUND
            if self.value.percentage > 0 then
                setColor(self.colors.barColor)
                rectangle(self.pos.x1, self.pos.y1, _barX2, self.pos.y2)
            end
        end

        if self.value.draw then -- DRAW PB VALUE IF THE SETTING IS ENABLED
            
            -- STORE VALUE IN A VARIABLE
            local _valueText = self.value.percentage..'%'

            -- CENTER VALUE ON X AXIS
            local _valueX = self.pos.x1 + math.floor((self.pos.x2 - self.pos.x1 - string.len(_valueText) + 1) / 2)
            
            -- CENTER VALUE ON Y AXIS DEPENDING ON VALUE MODE
            local _valueY

            if self.value.drawOnPB then
                _valueY = self.pos.y1 + math.floor((self.pos.y2 - self.pos.y1) / 2)
            else
                if self.pos.y1 > self.pos.y2 then
                    _valueY = self.pos.y1 + 1
                else
                    _valueY = self.pos.y2 + 1
                end
            end

            -- SET VALUE COLOR
            setTextColor(self.colors.valueColor)

            if self.colors.backgroundValueColor then -- IF VALUE HAS A BACKGROUND COLOR WE JUST NEED TO WRITE IT

                setBackgroundTextColor(self.colors.backgroundValueColor)

                text(_valueX, _valueY, _valueText)

            else -- IF IT HASN'T ONE IS A BIT HARDER
                if self.value.drawOnPB then -- CHECK IF IT NEEDS TO BE DRAWN ON THE BAR

                    if self.colors.backgroundBarColor then -- IF BAR HAS A BACKGROUND SET TEXT BG TO IT
                        setBackgroundTextColor(self.colors.backgroundBarColor)
                    else -- IF NOT SET IT TO THE MONITOR'S CURRENT ONE
                        setBackgroundTextColor(backgroundColor)
                    end

                    if self.pos.x1 < self.pos.x2 then -- IF THE BAR ISN'T FLIPPED THEN
                        -- CALCULATE HOW MUCH OF THE VALUE IS COVERED BY IT
                        local _valueColoredByBar = math.floor(_barX2) - _valueX + 1

                        -- HOW MUCH THE VALUE IS COVERED SHOULD BE BETWEEN 0 AND THE NUMBER OF CHAR OF _valueText
                        if _valueColoredByBar < 0 then
                            _valueColoredByBar = 0
                        elseif _valueColoredByBar > string.len(_valueText) then
                            _valueColoredByBar = string.len(_valueText)
                        end

                        -- IF VALUE ISN'T ALREADY FULLY COVERED BY BAR THEN DRAW TEXT WITH BAR BACKGROUND OR THE MONITOR ONE
                        if _valueColoredByBar < string.len(_valueText) then
                            text(_valueX, _valueY, _valueText)
                        end

                        -- IF VALUE IS PARTIALLY COVERED THEN DRAW TEXT WITH BAR COLOR ON TOP OF THE ONE WITHOUT IT
                        if _valueColoredByBar > 0 then
                            setBackgroundTextColor(self.colors.barColor)
        
                            text(_valueX, _valueY, string.sub(_valueText, 1, _valueColoredByBar))
                        end
                    else
                        -- CALCULATE HOW MUCH OF THE VALUE IS COVERED BY IT
                        local _valueColoredByBar = _valueX + string.len(_valueText) - math.ceil(_barX2)

                        -- HOW MUCH THE VALUE IS COVERED SHOULD BE BETWEEN 0 AND THE NUMBER OF CHAR OF _valueText
                        if _valueColoredByBar < 0 then
                            _valueColoredByBar = 0
                        elseif _valueColoredByBar > string.len(_valueText) then
                            _valueColoredByBar = string.len(_valueText)
                        end

                        -- IF VALUE ISN'T ALREADY FULLY COVERED BY BAR THEN DRAW TEXT WITH BAR BACKGROUND OR THE MONITOR ONE
                        if _valueColoredByBar < string.len(_valueText) then
                            text(_valueX, _valueY, _valueText)
                        end

                        -- IF VALUE IS PARTIALLY COVERED THEN DRAW TEXT WITH BAR COLOR ON TOP OF THE ONE WITHOUT IT
                        if _valueColoredByBar > 0 then
                            setBackgroundTextColor(self.colors.barColor)
        
                            text(_valueX + string.len(_valueText) - _valueColoredByBar, _valueY, string.sub(_valueText, -_valueColoredByBar))
                        end
                    end

                else -- IF IT DOESN'T NEED TO BE DRAWN ON TOP OF THE BAR THEN SIMPLY DRAW IT
                    setBackgroundTextColor(backgroundColor)
                    text(_valueX, _valueY, self.value.percentage..'%')
                end
            end
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
    elseif _event == 3 then
        self.callbacks.onFailedPress = _callback
    end
end

function PercentageBar:setValue(_value)
    assert(type(_value) == 'number', 'PercentageBar.setValue: value must be a number, got '..type(_value))
    if _value < self.value.min then _value = self.value.min; end
    if _value > self.value.max then _value = self.value.max; end
    self.value.current = _value
    self.value.percentage = math.floor(((self.value.current - self.value.min) / (self.value.max - self.value.min)) * 100)
end

function PercentageBar:update(_x, _y, _event, _cantUpdate)
    assert(type(_x) == 'number', 'PercentageBar.update: x must be a number, got '..type(_x))
    assert(type(_y) == 'number', 'PercentageBar.update: y must be a number, got '..type(_y))

    if not self.hidden then
        if not _cantUpdate then
            if checkAreaPress(self.pos.x1, self.pos.y1, self.pos.x2, self.pos.y2, _x, _y) then -- CHECK IF IT WAS PRESSED
                -- IF THE PERCENTAGEBAR WAS PRESSED CALL CALLBACK
                self.callbacks.onPress(self, _event)
                return true
            else
                self.callbacks.onFailedPress(self, _event)
                return false
            end
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
        active = false,
        hidden = false,
        selfLoop = false,
        lines = {},
        pos = {
            x1 = _x1,
            y1 = _y1,
            x2 = _x2,
            y2 = _y2
        },
        editSettings = {
            editable = true,
            charEvent = true,
            keyEvent = true
        },
        cursor = {
            text = ' ',
            colors = {
                textColor = _textColor,
                backgroundTextColor = _cursorColor
            },
            visible = false,
            blink = {
                automatic = true,
                enabled = false,
                clock = os.clock(),
                speed = 0.5
            },
            pos = {
                char = 1,
                line = 1
            },
            limits = {
                enabled = true,
                char = math.abs(_x2 - _x1) + 1,
                line = math.abs(_y2 - _y1) + 1
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
            onFailedPress = function() end,
            onEdit = function() end,
            onCursorBlink = function() end,
            onActivated = function() end,
            onDeactivated = function() end
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
            x = self.cursor.pos.char - 1,
            y = self.cursor.pos.line - 1
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
            if self.cursor.pos.line - 1 <= _height then -- IF THE CURSOR IS LESS THAN THE HEIGHT OF THE SQUARE
                if self.lines[i + 1] then -- IF LINE EXISTS
                    if self.cursor.pos.char - 1 <= _width then -- IF THE CURSOR IS LESS THEN THE WIDTH OF THE SQUARE
                        text(_memoX1, _memoY1 + i, string.sub(self.lines[i + 1], 1, _width + 1))
                    else -- IF THE CURSOR IS MORE THEN THE WIDTH OF THE SQUARE
                        text(_memoX1, _memoY1 + i, string.sub(self.lines[i + 1], self.cursor.pos.char - _width, self.cursor.pos.char))
                    end
                end
            else -- IF THE CURSOR IS MORE THAN THE HEIGHT OF THE SQUARE
                if self.lines[i + self.cursor.pos.line - _height] then -- IF LINE EXISTS
                    if self.cursor.pos.char - 1 <= _width then -- IF THE CURSOR IS LESS THEN THE WIDTH OF THE SQUARE
                        text(_memoX1, _memoY1 + i, string.sub(self.lines[i + self.cursor.pos.line - _height], 1, _width + 1))
                    else -- IF THE CURSOR IS MORE THEN THE WIDTH OF THE SQUARE
                        text(_memoX1, _memoY1 + i, string.sub(self.lines[i + self.cursor.pos.line - _height], self.cursor.pos.char - _width, self.cursor.pos.char))
                    end
                end
            end
        end

        if self.cursor.visible then
            setTextColor(self.cursor.colors.textColor)
            setBackgroundTextColor(self.cursor.colors.backgroundTextColor)
            text(_memoX1 + _cursorScreenPos.x, _memoY1 + _cursorScreenPos.y, self.cursor.text) -- DRAW CURSOR
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
        self.callbacks.onFailedPress = _callback
    elseif _event == 4 then
        self.callbacks.onEdit = _callback
    elseif _event == 5 then
        self.callbacks.onCursorBlink = _callback
    elseif _event == 6 then
        self.callbacks.onActivated = _callback
    elseif _event == 7 then
        self.callbacks.onDeactivated = _callback
    end
end

function Memo:setCursorLimits(_char, _line)
    assert(type(_char) == 'number' or type(_char) == 'nil', 'Memo.setCursorLimits: char must be a number or nil, got '..type(_char))
    assert(type(_line) == 'number' or type(_line) == 'nil', 'Memo.setCursorLimits: line must be a number or nil, got '..type(_line))
    self.cursor.limits.char = _char
    self.cursor.limits.line = _line
end

function Memo:setCursorPos(_char, _line, _fillEmptyLines)
    assert(type(_char) == 'number', 'Memo.setCursorPos: char must be a number, got '..type(_char))
    assert(type(_line) == 'number', 'Memo.setCursorPos: line must be a number, got '..type(_line))

    if _char < 1 then -- IF CHAR POS IS LESS THAN 1 SET IT TO 1
        _char = 1
    end
    if _line < 1 then -- IF LINE POS IS LESS THAN 1 SET IT TO 1
        _line = 1
    end
    
    if self.cursor.limits.enabled then -- IF CURSOR LIMITS ARE ON
        if self.cursor.limits.char then
            if _char > self.cursor.limits.char + 1 then -- IF CHAR IS MORE THAN THE LIMIT SET IT TO IT
                _char = self.cursor.limits.char
            end
        end
        if self.cursor.limits.line then
            if _line > self.cursor.limits.line then -- IF LINE IS MORE THAN THE LIMIT SET IT TO IT
                _line = self.cursor.limits.line
            end
        end
    end

    if not self.lines[_line] then -- IF SELECTED LINE DOESN'T EXISTS
        if _fillEmptyLines then
            for i=#self.lines + 1, _line do -- CREATE EMPTY LINES UNTILL LINE POS
                table.insert(self.lines, '')
            end
        else
            if #self.lines > 0 then
                _line = #self.lines
            else
                _line = 1
            end
        end
    end
    if self.lines[_line] then
        if _char > #self.lines[_line] + 1 then -- IF CHAR POS IS MORE THAN THE LINE LENGTH THEN SET CHAR TO IT
            _char = #self.lines[_line] + 1
        end
    else
        _char = 1
    end
    self.cursor.pos.char = _char -- SET CHAR AND LINE POS TO MEMO CURSOR
    self.cursor.pos.line = _line

end

function Memo:edit(_event)

    if not self.editSettings.editable then
        return
    end

    if not self.hidden then -- IF MEMO ISN'T HIDDEN

        local function edit(event)
            if not event then return false; end
            if not self.lines[1] then self:setCursorPos(1, 1, true); end -- IF FIRST LINE IS NULL THEN MAKE IT AN EMPTY STRING AND SELECT IT
            self.callbacks.onEdit(self, event) -- CALL ON EDIT EVENT

            if self.cursor.limits.enabled then -- IF LIMITS ARE ACTIVE THEN
                if self.cursor.limits.line then
                    if #self.lines > self.cursor.limits.line then -- IF LINES ARE MORE THAN THE ONES AVAILABLE THEN DELETE THEM
                        for i=self.cursor.limits.line + 1, #self.lines + 1 do
                            table.remove(self.lines, self.cursor.limits.line)
                        end
                    end
                end
                for key, value in pairs(self.lines) do -- IF A LINE CONTAINS MORE CHARS THAN ALLOWED THEN DELETE THE EXTRA ONES
                    if self.cursor.limits.char then
                        if #value > self.cursor.limits.char then
                            self.lines[key] = value:sub(1, self.cursor.limits.char)
                        end
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
            elseif event[1] == 'char' and self.editSettings.charEvent then
                local cursorLine = self.lines[self.cursor.pos.line] -- GET LINE WHERE THE CURSOR IS LOCATED

                if self.cursor.limits.enabled then -- IF CURSOR LIMITS ARE ENABLED THEN
                    if self.cursor.limits.char then
                        if self.cursor.pos.char <= self.cursor.limits.char then -- IF CURSOR IS IN THE LIMITS THEN
                            self.lines[self.cursor.pos.line] = cursorLine:sub( -- ADD CHAR TO THE LINE
                                0,
                                self.cursor.pos.char - 1
                            )..event[2]..cursorLine:sub(
                                self.cursor.pos.char,
                                #cursorLine
                            )

                            self.cursor.pos.char = self.cursor.pos.char + 1 -- MOVE CURSOR BY ONE ON THE X AXIS
                        end
                    else
                        self.lines[self.cursor.pos.line] = cursorLine:sub( -- ADD CHAR TO THE LINE
                            0,
                            self.cursor.pos.char - 1
                        )..event[2]..cursorLine:sub(
                            self.cursor.pos.char,
                            #cursorLine
                        )

                        self.cursor.pos.char = self.cursor.pos.char + 1 -- MOVE CURSOR BY ONE ON THE X AXIS
                    end
                else -- IF CURSOR LIMITS ARE DISABLED THEN
                    self.lines[self.cursor.pos.line] = cursorLine:sub( -- ADD CHAR TO THE LINE
                        0,
                        self.cursor.pos.char - 1
                    )..event[2]..cursorLine:sub(
                        self.cursor.pos.char,
                        #cursorLine
                    )

                    self.cursor.pos.char = self.cursor.pos.char + 1 -- MOVE CURSOR BY ONE ON THE X AXIS
                end

            elseif event[1] == 'key' and self.editSettings.keyEvent then
                local cursorLine = self.lines[self.cursor.pos.line] -- GET LINE WHERE THE CURSOR IS LOCATED

                if event[2] == 28 then -- ENTER KEY
                    if self.cursor.limits.enabled then -- IF LIMITS ARE ENABLED THEN
                        if self.cursor.limits.line then
                            if #self.lines + 1 <= self.cursor.limits.line then -- IF THE NEXT LINE IS ALLOWED THEN
                                table.insert(self.lines, self.cursor.pos.line + 1, '') -- CREATE A NEW LINE

                                self.lines[self.cursor.pos.line] = cursorLine:sub( -- KEEP THE TEXT BEFORE THE CURSOR ON THE OLD LINE
                                    0,
                                    self.cursor.pos.char - 1
                                )
                                self.lines[self.cursor.pos.line + 1] = cursorLine:sub( -- PUT THE TEXT AFTER THE CURSOR ON THE NEW LINE
                                    self.cursor.pos.char,
                                    #cursorLine
                                )..self.lines[self.cursor.pos.line + 1]
                                
                                self.cursor.pos.line = self.cursor.pos.line + 1 -- SET CURSOR POS LINE TO NEW LINE
                                self.cursor.pos.char = 1 -- SET CURSOR POS CHAR TO 1
                            end
                        else
                            table.insert(self.lines, self.cursor.pos.line + 1, '') -- CREATE A NEW LINE

                            self.lines[self.cursor.pos.line] = cursorLine:sub( -- KEEP THE TEXT BEFORE THE CURSOR ON THE OLD LINE
                                0,
                                self.cursor.pos.char - 1
                            )
                            self.lines[self.cursor.pos.line + 1] = cursorLine:sub( -- PUT THE TEXT AFTER THE CURSOR ON THE NEW LINE
                                self.cursor.pos.char,
                                #cursorLine
                            )..self.lines[self.cursor.pos.line + 1]
                            
                            self.cursor.pos.line = self.cursor.pos.line + 1 -- SET CURSOR POS LINE TO NEW LINE
                            self.cursor.pos.char = 1 -- SET CURSOR POS CHAR TO 1
                        end
                    else -- IF LIMITS AREN'T ENABLED THEN
                        table.insert(self.lines, self.cursor.pos.line + 1, '') -- CREATE A NEW LINE

                        self.lines[self.cursor.pos.line] = cursorLine:sub( -- KEEP THE TEXT BEFORE THE CURSOR ON THE OLD LINE
                            0,
                            self.cursor.pos.char - 1
                        )
                        self.lines[self.cursor.pos.line + 1] = cursorLine:sub( -- PUT THE TEXT AFTER THE CURSOR ON THE NEW LINE
                            self.cursor.pos.char,
                            #cursorLine
                        )..self.lines[self.cursor.pos.line + 1]
                        
                        self.cursor.pos.line = self.cursor.pos.line + 1 -- SET CURSOR POS LINE TO NEW LINE
                        self.cursor.pos.char = 1 -- SET CURSOR POS CHAR TO 1
                    end
                elseif event[2] == 14 then -- BACKSPACE KEY
                    if self.cursor.pos.char > 1 then -- IF THE CURSOR ISN'T AT THE BEGINNING IF THE LINE THEN
                        self.lines[self.cursor.pos.line] = cursorLine:sub( -- DELETE CHAR BEFORE CURSOR
                            0,
                            self.cursor.pos.char - 2
                        )..cursorLine:sub(
                            self.cursor.pos.char,
                            #cursorLine
                        )
                        self.cursor.pos.char = self.cursor.pos.char - 1 -- SET CURSOR TO THE CHAR BEFORE THE ONE DELETED
                    elseif self.cursor.pos.line > 1 then -- IF CURSOR POS IS AT THE BEGINNING OF THE LINE AND NOT ON THE FIRST ONE THEN
                        local _endOfPreviousLine = #self.lines[self.cursor.pos.line - 1] -- GET THE LINE BEFORE THE ONE WHERE THE CURSOR IS
                        if self.cursor.limits.enabled then -- IF CURSOR LIMITS ARE ENABLED THEN
                            if self.cursor.limits.char then
                                if _endOfPreviousLine + #cursorLine <= self.cursor.limits.char then -- IF PREV LINE + CURR LINE IS LESS THAN CURSOR LIMITS THEN
                                    self.lines[self.cursor.pos.line - 1] = self.lines[self.cursor.pos.line - 1]..cursorLine:sub( -- SET PREV LINE TO PREVLINE + CURRLINE
                                        self.cursor.pos.char,
                                        #cursorLine
                                    )
                                    table.remove(self.lines, self.cursor.pos.line) -- REMOVE CURRLINE
                                    self.cursor.pos.line = self.cursor.pos.line - 1 -- SELECT PREV LINE
                                    self.cursor.pos.char = _endOfPreviousLine + 1 -- SELECT END OF THE PREV LINE
                                end
                            else
                                self.lines[self.cursor.pos.line - 1] = self.lines[self.cursor.pos.line - 1]..cursorLine:sub( -- SET PREV LINE TO PREVLINE + CURRLINE
                                    self.cursor.pos.char,
                                    #cursorLine
                                )
                                table.remove(self.lines, self.cursor.pos.line) -- REMOVE CURRLINE
                                self.cursor.pos.line = self.cursor.pos.line - 1 -- SELECT PREV LINE
                                self.cursor.pos.char = _endOfPreviousLine + 1 -- SELECT END OF THE PREV LINE
                            end
                        else-- IF CURSOR LIMITS AREN'T ENABLED THEN
                            self.lines[self.cursor.pos.line - 1] = self.lines[self.cursor.pos.line - 1]..cursorLine:sub(-- SET PREV LINE TO PREVLINE + CURRLINE
                                self.cursor.pos.char,
                                #cursorLine
                            )
                            table.remove(self.lines, self.cursor.pos.line) -- REMOVE CURRLINE
                            self.cursor.pos.line = self.cursor.pos.line - 1 -- SELECT PREV LINE
                            self.cursor.pos.char = _endOfPreviousLine + 1 -- SELECT END OF THE PREV LINE
                        end
                    end

                elseif event[2] == 211 then -- CANC KEY
                    if self.cursor.pos.char > #cursorLine then -- IF CURSOR IS AT THE END OF THE LINE THEN
                        if self.lines[self.cursor.pos.line + 1] then -- IF THERE'S A NEXT LINE THEN
                            if self.cursor.limits.enabled then -- IF CURSOR LIMITS ARE ENABLED THEN
                                if self.cursor.limits.char then
                                    if #self.lines[self.cursor.pos.line + 1] + #cursorLine <= self.cursor.limits.char then -- IF CURR LINE + NEXT LINE ISN'T GREATER THAN CURSOR LIMITS THEN
                                        self.lines[self.cursor.pos.line] = cursorLine..self.lines[self.cursor.pos.line + 1] -- SET CURR LINE TO CURRLINE + NEXTLINE
                                        table.remove(self.lines, self.cursor.pos.line + 1) -- REMOVE NEXT LINE
                                    end
                                else
                                    self.lines[self.cursor.pos.line] = cursorLine..self.lines[self.cursor.pos.line + 1] -- SET CURR LINE TO CURRLINE + NEXTLINE
                                    table.remove(self.lines, self.cursor.pos.line + 1) -- REMOVE NEXT LINE
                                end
                            else -- IF CURSOR LIMITS AREN'T ENABLED THEN
                                self.lines[self.cursor.pos.line] = cursorLine..self.lines[self.cursor.pos.line + 1] -- SET CURR LINE TO CURRLINE + NEXTLINE
                                table.remove(self.lines, self.cursor.pos.line + 1) -- REMOVE NEXT LINE
                            end
                        end

                    else -- IF CURSOR ISN'T AT THE END OF THE LINE THEN
                        self.lines[self.cursor.pos.line] = cursorLine:sub( -- REMOVE CHAR ON THE CURSOR
                            0,
                            self.cursor.pos.char - 1
                        )..cursorLine:sub(
                            self.cursor.pos.char + 1,
                            #cursorLine
                        )
                    end

                elseif event[2] == 203 then -- ARROW KEY LEFT
                    if self.cursor.pos.char > 1 then -- IF CURSOR POS IS GREATER THAN 0 THEN
                        self.cursor.pos.char = self.cursor.pos.char - 1 -- SET CURSOR POS CHAR TO PREV CHAR
                    else
                        if self.cursor.pos.line > 1 then -- IF IT ISN'T ON THE FIRST LINE THEN
                            self.cursor.pos.line = self.cursor.pos.line - 1 -- SET IT TO THE PREVIOUS ONE
                            self.cursor.pos.char = #self.lines[self.cursor.pos.line] + 1
                        end
                    end


                elseif event[2] == 205 then -- ARROW KEY RIGHT
                    if self.cursor.pos.char <= #cursorLine then -- IF CURSOR ISN'T AT THE END OF TEXT IN THE LINE THEN
                        if self.cursor.limits.enabled then -- IF CURSOR LIMITS ARE ENABLED THEN
                            if self.cursor.limits.char then
                                if self.cursor.pos.char <= self.cursor.limits.char then -- IF THE CURSOR DOESN'T GO OUT OF THE LIMITS IF MOVED TO THE RIGHT THEN DO IT
                                    self.cursor.pos.char = self.cursor.pos.char + 1
                                end
                            else
                                self.cursor.pos.char = self.cursor.pos.char + 1
                            end
                        else
                            self.cursor.pos.char = self.cursor.pos.char + 1 -- MOVE CURSOR TO THE RIGHT
                        end
                    else
                        if self.lines[self.cursor.pos.line + 1] then -- IF A NEXT LINE EXISTS THEN
                            if self.cursor.limits.enabled then -- IF CURSOR LIMITS ARE ENABLED THEN
                                if self.cursor.limits.line then
                                    if self.cursor.pos.line < self.cursor.limits.line then -- IF NEXT LINE IS WITHIN THE LIMITS THEN
                                        self.cursor.pos.line = self.cursor.pos.line + 1 -- SET CURSOR TO IT
                                        self.cursor.pos.char = 1
                                    end
                                else
                                    self.cursor.pos.line = self.cursor.pos.line + 1 -- SET CURSOR TO IT
                                    self.cursor.pos.char = 1
                                end
                            else -- IF CURSOR LIMITS AREN'T ENABLED THEN
                                self.cursor.pos.line = self.cursor.pos.line + 1 -- SET CURSOR TO NEXT LINE
                                self.cursor.pos.char = 1
                            end
                        end
                    end


                elseif event[2] == 200 then -- ARROW KEY UP
                    if self.cursor.pos.line > 1 then -- IF IT ISN'T ON THE FIRST LINE THEN
                        self.cursor.pos.line = self.cursor.pos.line - 1 -- SET IT TO THE PREVIOUS ONE
                        if self.cursor.pos.char - 1 > #self.lines[self.cursor.pos.line] then -- IF CURSOR POS CHAR IS GREATER THAN THE END OF THE TEXT ON PREV LINE THEN SET IT TO THE END OF IT
                            self.cursor.pos.char = #self.lines[self.cursor.pos.line] + 1
                        end
                    end


                elseif event[2] == 208 then -- ARROW KEY DOWN
                    if self.lines[self.cursor.pos.line + 1] then -- IF A NEXT LINE EXISTS THEN
                        if self.cursor.limits.enabled then -- IF CURSOR LIMITS ARE ENABLED THEN
                            if self.cursor.limits.line then
                                if self.cursor.pos.line < self.cursor.limits.line then -- IF NEXT LINE IS WITHIN THE LIMITS THEN
                                    self.cursor.pos.line = self.cursor.pos.line + 1 -- SET CURSOR TO IT
                                    if self.cursor.pos.char - 1 > #self.lines[self.cursor.pos.line] then -- IF CURSOR POS CHAR IS GREATER THAN THE END OF THE TEXT ON NEXT LINE THEN SET IT TO THE END OF IT
                                        self.cursor.pos.char = #self.lines[self.cursor.pos.line] + 1
                                    end
                                end
                            else
                                self.cursor.pos.line = self.cursor.pos.line + 1 -- SET CURSOR TO IT
                                if self.cursor.pos.char - 1 > #self.lines[self.cursor.pos.line] then -- IF CURSOR POS CHAR IS GREATER THAN THE END OF THE TEXT ON NEXT LINE THEN SET IT TO THE END OF IT
                                    self.cursor.pos.char = #self.lines[self.cursor.pos.line] + 1
                                end
                            end
                        else -- IF CURSOR LIMITS AREN'T ENABLED THEN
                            self.cursor.pos.line = self.cursor.pos.line + 1 -- SET CURSOR TO NEXT LINE
                            if self.cursor.pos.char - 1 > #self.lines[self.cursor.pos.line] then -- IF CURSOR POS CHAR IS GREATER THAN THE END OF THE TEXT ON NEXT LINE THEN SET IT TO THE END OF IT
                                self.cursor.pos.char = #self.lines[self.cursor.pos.line] + 1
                            end
                        end
                    end
                end
            end
            self:draw()
            return true
        end

        if not self.selfLoop then
            edit(_event)
        else
            self.active = true
            while self.active do
                local Timer = os.startTimer(self.cursor.blink.speed / 2)

                _event = {os.pullEvent()}

                if not edit(_event) then
                    break
                end

                if self.cursor.blink.enabled then
                    if os.clock() >= self.cursor.blink.clock + self.cursor.blink.speed then -- BLINK :)
                        self.cursor.blink.clock = os.clock() -- UPDATE BLINKCLOCK
                        self.callbacks.onCursorBlink(self, _event) -- CALL ONCURSORBLINK CALLBACK
                        self.cursor.visible = not self.cursor.visible -- INVERT CURSOR VISIBILITY
                    end
                end

                os.cancelTimer(Timer)
            end
        end
    end
end


function Memo:update(_x, _y, _event, _cantUpdate)
    assert(type(_x) == 'number', 'Memo.update: x must be a number, got '..type(_x))
    assert(type(_y) == 'number', 'Memo.update: y must be a number, got '..type(_y))

    if not self.hidden then
        if not _cantUpdate and checkAreaPress(self.pos.x1, self.pos.y1, self.pos.x2, self.pos.y2, _x, _y) then -- CHECK IF IT WAS PRESSED
            -- IF THE MEMO WAS PRESSED CALL CALLBACK
            self.callbacks.onPress(self, _event)
            self.active = true
            self.callbacks.onActivated(self, _event)

            if self.selfLoop then
                self.cursor.blink.enabled = true
                self.cursor.visible = true
                self:edit(_event)
                self.active = false
                self.callbacks.onDeactivated(self, _event)
                self.cursor.blink.enabled = false
                self.cursor.visible = false

            elseif self.editSettings.editable and self.cursor.blink.automatic then
                self.cursor.blink.enabled = true
                self.cursor.visible = true
            end

            return true
        else
            self.callbacks.onFailedPress(self, _event)
            if self.active then
                self.active = false
                self.callbacks.onDeactivated(self, _event)

                if self.editSettings.editable and self.cursor.blink.automatic then
                    self.cursor.blink.enabled = false
                    self.cursor.visible = false
                end
            end
            return false
        end
    end
    if self.active then
        self.active = false
        self.callbacks.onDeactivated(self, _event)
    end
    return false
end

function Memo:tick(_event)
    if not self.hidden then
        if not self.selfLoop then
            if self.cursor.blink.enabled then
                if os.clock() >= self.cursor.blink.clock + self.cursor.blink.speed then -- BLINK :)
                    self.cursor.blink.clock = os.clock() -- UPDATE BLINKCLOCK
                    self.callbacks.onCursorBlink(self, _event) -- CALL ONCURSORBLINK CALLBACK
                    self.cursor.visible = not self.cursor.visible -- INVERT CURSOR VISIBILITY
                end
            end
        end
    end
end

function Memo:key(_event)
    if not self.hidden then
        if not self.selfLoop then
            if self.active then
                self:edit(_event)
            end
        end
    end
end

function Memo:char(_event)
    if not self.hidden then
        if not self.selfLoop then
            if self.active then
                self:edit(_event)
            end
        end
    end
end

function Memo:write(_string)
    if not _string then _string = ''; end
    _string = tostring(_string)

    if not self.lines[1] then self:setCursorPos(1, 1, true); end -- IF FIRST LINE IS NULL THEN MAKE IT AN EMPTY STRING AND SELECT IT
    self.callbacks.onEdit(self, {'write', _string})

    local lines = stringSplit(_string, '\n')

    for key, value in pairs(lines) do

        if key ~= 1 then
            if self.lines[self.cursor.pos.line + 1] then -- IF A LINE AFTER THE CURRENT ONE EXISTS THEN GO TO IT AND TO THE END OF IT
                self:setCursorPos(#self.lines[self.cursor.pos.line + 1], self.cursor.pos.line + 1)
            else -- IF A LINE AFTER THE CURRENT ONE DOESN'T EXISTS THEN CREATE AND GO TO IT
                self:setCursorPos(1, self.cursor.pos.line + 1, true)
            end
        end
        
        local cursorLine = self.lines[self.cursor.pos.line]
    
        cursorLine = cursorLine:sub( -- ADD STRING TO THE LINE
            0,
            self.cursor.pos.char - 1
        )..value..cursorLine:sub(
            self.cursor.pos.char,
            #cursorLine
        )
    
        self.lines[self.cursor.pos.line] = cursorLine
        self:setCursorPos(self.cursor.pos.char + #value, self.cursor.pos.line)
        
        if self.cursor.limits.enabled then -- IF LIMITS ARE ACTIVE THEN
            if self.cursor.limits.char then -- IF A LINE CONTAINS MORE CHARS THAN ALLOWED THEN DELETE THE EXTRA ONES
                if #cursorLine > self.cursor.limits.char then
                    cursorLine = cursorLine:sub(1, self.cursor.limits.char)
                end
            end
        end
    
        self.lines[self.cursor.pos.line] = cursorLine

    end
    
    
end

function Memo:print(_string)
    if not _string then _string = ''; end
    _string = tostring(_string)

    self:write(_string..'\n')
end

function Memo:clear()
    self.cursor.pos.char = 1
    self.cursor.pos.line = 1
    self.lines = {}
end

function Memo:enableSelfLoop(_bool)
    assert(type(_bool) == 'boolean', 'Memo.enableSelfLoop: bool must be a boolean, got '..type(_bool))
    self.selfLoop = _bool
end

function Memo:limits(_bool)
    assert(type(_bool) == 'boolean', 'Memo.limits: bool must be a boolean, got '..type(_bool))
    self.cursor.limits.enabled = _bool
end

function Memo:editable(_bool)
    assert(type(_bool) == 'boolean', 'Memo.editable: bool must be a boolean, got '..type(_bool))
    self.editSettings.editable = _bool
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

function enableLoopFPSCounter(_bool)
    assert(type(_bool) == 'boolean', 'enableLoopFPSCounter: bool must be a boolean, got '..type(_bool))
    globalLoop.FPS.counter.enabled = _bool
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

function addLoopGroup(_groupName, _group)
    _groupName = tostring(_groupName)
    assert(_groupName ~= 'LIBPrivate' or _groupName ~= 'none', "addLoopGroup: can't overwrite Lib's Private groups")
    assert(type(_group) == 'table', 'addLoopGroup: group must be a table, got '..type(_group))
    globalLoop.group[_groupName] = _group
end

function setLoopGroup(_groupName)
    _groupName = tostring(_groupName)
    assert(globalLoop.group[_groupName], 'setLoopGroup: groupName must be a valid group.')
    globalLoop.selectedGroup = _groupName
    globalLoop.wasGroupChanged = true
end

function resetLoopSettings()
    
    globalLoop.APLWDBroadcastOnClock = false
    globalLoop.APLWDClearCacheOnDraw = true
    globalLoop.FPS.value = 0
    globalLoop.FPS.counter.enabled = false

    globalLoop.callbacks.onInit = function() end
    globalLoop.callbacks.onEvent = function() end -- CLEARS LOOP CALLBACKS
    globalLoop.callbacks.onClock = function() end

    globalLoop.selectedGroup = 'none'
    globalLoop.group = {
        none = {},
        LIBPrivate = globalLoop.group.LIBPrivate
    } --CLEARS LOOP GROUPS

    globalLoop.events = {
        tick = {},
        key = {},
        char = {}
    } -- CLEARS LOOP EVENTS SPECIFIC OBJ FUNCTIONS
end

function stopLoop()
    globalLoop.enabled = false --STOP LOOP
    
    globalLoop.events = {
        tick = {},
        key = {},
        char = {}
    } -- CLEARS LOOP EVENTS SPECIFIC OBJ FUNCTIONS
end

function loop()

    local function updateGlobalLoopEvents()
        globalLoop.events = {
            tick = {},
            key = {},
            char = {}
        } -- CLEARS LOOP EVENTS SPECIFIC OBJ FUNCTIONS

        for _, obj in pairs(globalLoop.group[globalLoop.selectedGroup]) do
            if obj.tick then
                table.insert(globalLoop.events.tick, obj)
            end
            if obj.key then
                table.insert(globalLoop.events.key, obj)
            end
            if obj.char then
                table.insert(globalLoop.events.char, obj)
            end
        end
    end
    
    globalLoop.enabled = true -- ACTIVATE LOOP

    if globalLoop.autoClear then
        bClear()
    end
    
    updateGlobalLoopEvents()
    
    globalLoop.callbacks.onInit()
    drawLoopOBJs()
    
    -- CREATE FPS CLOCK
    local FPSClock = Clock.new(1)
    FPSClock.FPS = 0
    FPSClock:setCallback(
        event.clock.onClock,
        function (self, event)
            globalLoop.FPS.value = self.FPS
            self.FPS = 0
        end
    )
    
    -- SET LOOP CLOCK
    local loopClock = os.clock()
    
    while globalLoop.enabled do

        if globalLoop.wasGroupChanged then
            updateGlobalLoopEvents()
            globalLoop.wasGroupChanged = false
        end

        local Timer = os.startTimer(globalLoop.timerSpeed) -- START A TIMER

        local event = {os.pullEvent()} -- PULL EVENTS

        -- EVENT
        if event[1] == 'monitor_touch' and (event[2] == globalMonitorName or (globalMonitorGroup.enabled and tableHas(globalMonitorGroup.list, event[2]))) then -- CHECK IF A BUTTON WAS PRESSED
            
            updateLoopOBJs(event[3], event[4], event)

        elseif event[1] == 'mouse_click' and (globalMonitorName == 'term' or (globalMonitorGroup.enabled and tableHas(globalMonitorGroup.list, 'term'))) then
            
            updateLoopOBJs(event[3], event[4], event)

        elseif event[1] == 'key' then
            for _, obj in pairs(globalLoop.events.key) do -- CALL OBJs KEY EVENTS
               obj:key(event)
            end

        elseif event[1] == 'char' then
            for _, obj in pairs(globalLoop.events.char) do -- CALL OBJs CHAR EVENTS
                obj:char(event)
            end

        elseif event[1] == 'timer' then
            globalLoop.callbacks.onTimer(event)
        end

        -- CLOCK
        globalLoop.clock = os.clock()
        if globalLoop.clock >= loopClock + globalLoop.clockSpeed then

            loopClock = os.clock()

            if globalLoop.drawOnClock then -- CLOCK DRAW
                if APLWD.enabled and globalLoop.APLWDClearCacheOnDraw then
                    APLWD.clearCache()
                end

                if globalLoop.autoClear then
                    bClear()
                end
                globalLoop.callbacks.onClock(event) -- TIMER CALLBACK
                drawLoopOBJs()
                
                -- FPS draw counter
                if globalLoop.FPS.counter.enabled then
                    drawLoopFPSCounter()
                end

                -- add 1 Frame
                FPSClock.FPS = FPSClock.FPS + 1
            else
                globalLoop.callbacks.onClock(event) -- TIMER CALLBACK
            end

            if APLWD.enabled and globalLoop.APLWDBroadcastOnClock then
                APLWD.broadcastCache()
            end
        end

        --OBJ EVENT TICK
        for _, obj in pairs(globalLoop.events.tick) do
            obj:tick(event)
        end
        
        -- FPS calc
        FPSClock:tick('calcFPS')

        --EVENT DRAW
        if not globalLoop.drawOnClock then -- NON CLOCK DRAW
            if APLWD.enabled and globalLoop.APLWDClearCacheOnDraw then
                APLWD.clearCache()
            end

            if globalLoop.autoClear then
                bClear()
            end
            globalLoop.callbacks.onEvent(event) -- EVENT CALLBACK
            drawLoopOBJs()
            
            -- FPS draw counter
            if globalLoop.FPS.counter.enabled then
                drawLoopFPSCounter()
            end

            -- add 1 Frame
            FPSClock.FPS = FPSClock.FPS + 1
        else
            globalLoop.callbacks.onEvent(event) -- EVENT CALLBACK
        end
        
        os.cancelTimer(Timer) -- DELETE TIMER
    end
end

function drawLoopFPSCounter()

    local oldTextColor = globalTextColor
    local oldBackgroundTextColor = globalBackgroundTextColor
    
    local backgroundColor = globalMonitor.getBackgroundColor()
    
    --SETTING THINGS TO FPS COUNTER SETTINGS
    setTextColor(globalLoop.FPS.counter.colors.textColor)
    if globalLoop.FPS.counter.colors.backgroundTextColor then
        setBackgroundTextColor(globalLoop.FPS.counter.colors.backgroundTextColor)
    else
        setBackgroundTextColor(backgroundColor)
    end

    --DRAWING FPS COUNTER
    local _text = tostring(globalLoop.FPS.value)..'FPS'
    text(globalMonitorWidth - string.len(_text) + 1 + globalLoop.FPS.counter.offsets.x, globalMonitorHeight + globalLoop.FPS.counter.offsets.y, _text)
    
    --REVERTING ALL CHANGES MADE BEFORE
    setTextColor(oldTextColor)
    setBackgroundTextColor(oldBackgroundTextColor)
end

function drawLoopOBJs()
    if globalMonitorGroup.enabled then -- CHECKS IF MONITORGROUP IS ENABLED
        globalLoop.callbacks.onMonitorChange(monitorName) -- CALLS onMonitorChange EVENT
        for i=#globalLoop.group[globalLoop.selectedGroup], 1, -1 do -- DRAW ALL OBJs
            local obj = globalLoop.group[globalLoop.selectedGroup][i]
            obj:draw()
        end
        local oldMonitor = globalMonitorName -- SAVES ORIGINAL MONITOR
        for _, monitorName in pairs(globalMonitorGroup.list) do -- LOOPS THROUGH ALL MONITORS
            if monitorName ~= oldMonitor then -- DRAW ONLY ON MONITOR THAT WASN'T THE GLOBAL ONE
                setMonitor(monitorName)
                globalLoop.callbacks.onMonitorChange(monitorName)
                for i=#globalLoop.group[globalLoop.selectedGroup], 1, -1 do -- DRAW ALL OBJs
                    local obj = globalLoop.group[globalLoop.selectedGroup][i]
                    obj:draw()
                end
            end
        end
        setMonitor(oldMonitor) -- RESETS TO ORIGINAL MONITOR
    else
        for i=#globalLoop.group[globalLoop.selectedGroup], 1, -1 do -- DRAW ALL OBJs
            local obj = globalLoop.group[globalLoop.selectedGroup][i]
            obj:draw()
        end
    end
end

function updateLoopOBJs(_x, _y, _event)
    assert(type(_x) == 'number', 'updateLoopOBJs: x must be a number, got '..type(_x))
    assert(type(_y) == 'number', 'updateLoopOBJs: y must be a number, got '..type(_y))
    local _objUpdated = false
    for _, obj in pairs(globalLoop.group[globalLoop.selectedGroup]) do -- UPDATE OBJs
        if obj:update(_x, _y, _event, _objUpdated) then
            _objUpdated = true
        end
    end
end

local tArgs = { ... } -- GETTING TERMINAL ARGS
if table.maxn(tArgs) > 0 then
    tArgs[1] = string.lower(tArgs[1]) -- GETTING OPTION
    if tArgs[1] == 'ver' then -- OPTION LIB
        print('Lib version: '..ver)
    elseif tArgs[1] == 'setup' then -- OPTION SETUP
        if shell then -- CHECKING IF SHELL API IS AVAILABLE
            local _LibPath = '/'..shell.getRunningProgram()
            OSSettings.set('APLibPath', _LibPath)
            print('Setup completed!\nAPLibPath: '..tostring(settings.get('APLibPath')))
            sleep(2)
            os.reboot() -- REBOOTING AFTER SETUP
        else
            error("Setup failed, shell API not available!")
        end
    elseif tArgs[1] == 'create' then -- OPTION CREATE
        if tArgs[2] then
            local _file = fs.open('/'..tArgs[2], 'w') -- OPEN FILE WITH NAME tArgs[1]
            if _file then -- IF FILE WAS OPENED THEN
                -- STORE TEXT IN A VARIABLE
                local _text = "\n-- //AUTO-GENERATED-CODE//\nassert(  -- check if setup was done before, if not return with an error\n    type(settings.get('APLibPath')) == 'string',\n"..'    "'.."Couldn't open APLib through path: "..'"..tostring(\n'.."        settings.get('APLibPath')\n"..'    ).."'.."; probably you haven't completed Lib setup via 'LIBFILE setup' or the setup failed"..'"\n)\n\n'.."assert( -- check if API is still there, if not return with an error\n    fs.exists(settings.get('APLibPath')),\n"..'    "'.."Couldn't open APLib through path: "..'"..tostring(\n'.."    	settings.get('APLibPath')\n    ).."..'"'.."; remember that if you move the API's folder you must set it up again via 'LIBFILE setup'"..'"\n)\n\n'.."os.loadAPI(settings.get('APLibPath')) -- load API with CraftOS's built-in feature\n-- //--//\n\n"
                _file.write(_text) -- WRITE TEXT IN THE FILE
                _file.close() -- CLOSE THE FILE
                print('File succesfully created!')
            else
                print("Couldn't create file.")
            end
        else
            print('You must specify the name of the file you want to create.')
        end
    end
end
