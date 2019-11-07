
info = {
    ver = '1.20.1',
    author = 'hds536jhmk',
    website = 'https://github.com/hds536jhmk/APLib'
}

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
    stats = {
        automaticPos = true,
        automaticPosOffset = {
            x = 0,
            y = 0
        }
        -- FPS (LABEL)      These are created near the end
        -- EPS (LABEL)
    },
    callbacks = {
        onInit = function() end,
        onClock = function() end,
        onEvent = function() end,
        onTimer = function() end,
        onMonitorChange = function() end
    },
    events = {
        draw = {},
        touch = {},
        tick = {},
        key = {},
        char = {},
        mouse_drag = {}
    },
    wasGroupChanged = false,
    selectedGroup = 'none',
    group = {
        none = {
            callbacks = {
                onClock = function () end,
                onEvent = function () end,
                onTimer = function () end,
                onMonitorChange = function () end,
                onSet = function () end,
                onUnset = function () end
            },
            objs = {}
        },
        LIBPrivate = {
            callbacks = {
                onClock = function () end,
                onEvent = function () end,
                onTimer = function () end,
                onMonitorChange = function () end,
                onSet = function () end,
                onUnset = function () end
            },
            objs = {}
        }
    }
}

--GLOBALCALLBACKS
globalCallbacks = {
    onBClear = function() end,
    onSetMonitor = function() end
}

--HELPERS
rectangleTypes = {filled = 1, hollow = 2, checker = 3}

event = {
    global = {
        onBClear = 1,
        onSetMonitor = 2
    },
    clock = {
        onClock = 1
    },
    point = {
        onDraw = 1,
        onPress = 2,
        onFailedPress = 3
    },
    rectangle = {
        onDraw = 1,
        onPress = 2,
        onFailedPress = 3
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
    window = {
        onDraw = 1,
        onPress = 2,
        onFailedPress = 3,
        onOBJPress = 4,
        onFailedOBJPress = 5,
        onEvent = 6
    },
    objGroup = {
        onDraw = 1,
        onOBJPress = 2,
        onFailedOBJPress = 3
    },
    loop = {
        group = {
            onClock = 1,
            onEvent = 2,
            onTimer = 3,
            onMonitorChange = 4,
            onSet = 5,
            onUnset = 6
        },
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

function tableHasKey(_table, _key)
    assert(type(_table) == 'table', 'tableHasKey: table must be a table, got '..type(_table))
    assert((type(_key) == 'string') or (type(_key) == 'number'), 'tableHasKey: key must be a string or a number, got '..type(_key))
    for key, value in pairs(_table) do
        if key == _key then
            return true, value
        end
    end
    return false
end

function tableHasValue(_table, _value)
    assert(type(_table) == 'table', 'tableHasValue: table must be a table, got '..type(_table))
    for key, value in pairs(_table) do
        if value == _value then
            return true, key
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
        globalCallbacks.onBClear = _callback
    elseif _event == 2 then
        globalCallbacks.onSetMonitor = _callback
    end
end

function bClear()
    globalMonitor.clear()
    globalMonitor.setCursorPos(1, 1)
    globalCallbacks.onBClear()

    if not APLWD.isReceiver and APLWD.cacheWritable then
        table.insert(
            APLWD.cache,
            {
                type = 'bClear'
            }
        )
    end
end

function bClearMonitorGroup()
    if globalMonitorGroup.enabled then -- CHECKS IF MONITORGROUP IS ENABLED
        globalLoop.callbacks.onMonitorChange(monitorName) -- CALLS onMonitorChange EVENT
        globalLoop.group[globalLoop.selectedGroup].callbacks.onMonitorChange(monitorName)
        
        bClear()

        local wasCacheWritable = APLWD.cacheWritable
        if APLWD.enabled and wasCacheWritable then APLWD.cacheWritable = false; end -- DISABLE APLWD CACHE WRITE
        local oldMonitor = globalMonitorName -- SAVES ORIGINAL MONITOR
        for _, monitorName in pairs(globalMonitorGroup.list) do -- LOOPS THROUGH ALL MONITORS
            if monitorName ~= oldMonitor then -- DRAW ONLY ON MONITOR THAT WASN'T THE GLOBAL ONE
                setMonitor(monitorName)
                globalLoop.callbacks.onMonitorChange(monitorName)
                globalLoop.group[globalLoop.selectedGroup].callbacks.onMonitorChange(monitorName)
                bClear()
            end
        end
        setMonitor(oldMonitor) -- RESETS TO ORIGINAL MONITOR
        if APLWD.enabled and wasCacheWritable then APLWD.cacheWritable = true; end -- ENABLE APLWD CACHE WRITE
    else
        bClear()
    end
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

function getMonitorSize()
    return globalMonitorWidth, globalMonitorHeight
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
    cacheWritable = true,
    clearOnDraw = false,
    protocol = 'APLWD-'..info.ver,
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

APLWD.broadcastOnLoopClock = function ()
    globalLoop.APLWDBroadcastOnClock = true
end

APLWD.dontBroadcastOnLoopClock = function ()
    globalLoop.APLWDBroadcastOnClock = false
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
            return false, 'disconnected'
        end
        return false
    end
end

APLWD.drawCache = function ()
    if APLWD.enabled then
        local function drawCache()
            for key, value in pairs(APLWD.cache) do
                if value.type == 'bClear' then

                    bClearMonitorGroup()

                elseif value.type == 'background' then

                    setBackgroundMonitorGroup(value.color)
                
                elseif value.type == 'text' then

                    local oldTextColor = globalTextColor
                    local oldBackgroundTextColor = globalBackgroundTextColor

                    setTextColor(value.colors.textColor)
                    setBackgroundTextColor(value.colors.backgroundTextColor)
                    text(value.pos.x, value.pos.y, value.text)

                    setTextColor(oldTextColor)
                    setBackgroundTextColor(oldBackgroundTextColor)

                elseif value.type == 'point' then
                        
                    local oldColor = globalColor
                    
                    setColor(value.color)
                    point(value.pos.x, value.pos.y)

                    setColor(oldColor)

                elseif value.type == 'rectangle' then

                    local oldColor = globalColor

                    setColor(value.color)
                    rectangle(value.pos.x1, value.pos.y1, value.pos.x2, value.pos.y2)

                    setColor(oldColor)

                end
            end
        end

        if globalMonitorGroup.enabled then -- CHECKS IF MONITORGROUP IS ENABLED
            globalLoop.callbacks.onMonitorChange(monitorName) -- CALLS onMonitorChange EVENT
            globalLoop.group[globalLoop.selectedGroup].callbacks.onMonitorChange(monitorName)
            if APLWD.clearOnDraw then bClear(); end
            drawCache()
            local oldMonitor = globalMonitorName -- SAVES ORIGINAL MONITOR
            for _, monitorName in pairs(globalMonitorGroup.list) do -- LOOPS THROUGH ALL MONITORS
                if monitorName ~= oldMonitor then -- DRAW ONLY ON MONITOR THAT WASN'T THE GLOBAL ONE
                    setMonitor(monitorName)
                    globalLoop.callbacks.onMonitorChange(monitorName)
                    globalLoop.group[globalLoop.selectedGroup].callbacks.onMonitorChange(monitorName)
                    if APLWD.clearOnDraw then bClear(); end
                    drawCache()
                end
            end
            setMonitor(oldMonitor) -- RESETS TO ORIGINAL MONITOR
        else
            if APLWD.clearOnDraw then bClear(); end
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

    local wasCacheWritable = APLWD.cacheWritable
    if APLWD.enabled and wasCacheWritable then APLWD.cacheWritable = false; end -- DISABLE APLWD CACHE WRITE

    bClear() --CLEARS MONITOR

    if APLWD.enabled and wasCacheWritable then APLWD.cacheWritable = true; end -- ENABLE APLWD CACHE WRITE

    if not APLWD.isReceiver and APLWD.cacheWritable then
        table.insert(
            APLWD.cache,
            {
                type = 'background',
                color = _color
            }
        )
    end
end

function setBackgroundMonitorGroup(_color)
    assert(type(_color) == 'number', 'setBackgroundMonitorGroup: color must be a number, got '..type(_color))
    
    if globalMonitorGroup.enabled then -- CHECKS IF MONITORGROUP IS ENABLED
        globalLoop.callbacks.onMonitorChange(monitorName) -- CALLS onMonitorChange EVENT
        globalLoop.group[globalLoop.selectedGroup].callbacks.onMonitorChange(monitorName)
        
        setBackground(_color)

        local wasCacheWritable = APLWD.cacheWritable
        if APLWD.enabled and wasCacheWritable then APLWD.cacheWritable = false; end -- DISABLE APLWD CACHE WRITE
        local oldMonitor = globalMonitorName -- SAVES ORIGINAL MONITOR
        for _, monitorName in pairs(globalMonitorGroup.list) do -- LOOPS THROUGH ALL MONITORS
            if monitorName ~= oldMonitor then -- DRAW ONLY ON MONITOR THAT WASN'T THE GLOBAL ONE
                setMonitor(monitorName)
                globalLoop.callbacks.onMonitorChange(monitorName)
                globalLoop.group[globalLoop.selectedGroup].callbacks.onMonitorChange(monitorName)
                setBackground(_color)
            end
        end
        setMonitor(oldMonitor) -- RESETS TO ORIGINAL MONITOR
        if APLWD.enabled and wasCacheWritable then APLWD.cacheWritable = true; end -- ENABLE APLWD CACHE WRITE
    else
        setBackground(_color)
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

    globalMonitor.setTextColor(globalTextColor)
    globalMonitor.setBackgroundColor(globalBackgroundTextColor)
    
    local lines = stringSplit(_text, '\n')
    
    for key, value in pairs(lines) do
        
        globalMonitor.setCursorPos(_x, _y + key - 1)
        globalMonitor.write(value)

    end

    globalMonitor.setCursorPos(oldCursorPosX, oldCursorPosY)
    globalMonitor.setTextColor(oldTextColor)
    globalMonitor.setBackgroundColor(oldBackgroundColor)
    
    if not APLWD.isReceiver and APLWD.cacheWritable then
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
    
    if not APLWD.isReceiver and APLWD.cacheWritable then
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
    
    local wasCacheWritable = APLWD.cacheWritable
    if APLWD.enabled and wasCacheWritable then APLWD.cacheWritable = false; end -- DISABLE APLWD CACHE WRITE
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
    elseif globalRectangleType == 3 then -- DRAWS CHECKER RECTANGLE
        local draw = true
        for x = _x1, _x2, _incrementX do
            for y = _y1, _y2, _incrementY do
                if draw then
                    point(x, y)
                end
                draw = not draw
            end
            if math.abs(_x1 - _x2) % 2 ~= 0 then draw = not draw; end
        end
    end
    if APLWD.enabled and wasCacheWritable then APLWD.cacheWritable = true; end -- DISABLE APLWD CACHE WRITE
    
    if not APLWD.isReceiver and APLWD.cacheWritable then
        table.insert(
            APLWD.cache,
            {
                type = 'rectangle',
                pos = {
                    x1 = _x1,
                    y1 = _y1,
                    x2 = _x2,
                    y2 = _y2
                },
                color = globalColor
            }
        )
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

    assert(type(_interval) == 'number', 'Clock.new: interval must be a number, got '..type(_interval))

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

Point = {}

function Point.new(_x, _y, _color)
    
    assert(type(_x) == 'number', 'Point.new: x must be a number, got '..type(_x))
    assert(type(_y) == 'number', 'Point.new: y must be a number, got '..type(_y))
    
    --FIX THINGS
    _color = tonumber(_color)

    --CHECK THINGS
    if not _color then
        _color = globalColor
    end

    --CREATE RECTANGLE
    _newPoint = {
        color = _color,
        hidden = false,
        pos = {
            x = _x,
            y = _y
        },
        callbacks = {
            onDraw = function() end,
            onPress = function() end,
            onFailedPress = function() end
        }
    }
    setmetatable(_newPoint, Point) --SET POINT METATABLE
    return _newPoint
end

function Point:draw()
    if not self.hidden then
        self.callbacks.onDraw(self)

        local oldColor = globalColor
        
        --SETTING THINGS TO RECTANGLE SETTINGS
        setColor(self.color)

        --DRAWING RECTANGLE
        point(self.pos.x, self.pos.y)

        --REVERTING ALL CHANGES MADE BEFORE
        setColor(oldColor)
    end
end

function Point:setCallback(_event, _callback)
    assert(type(_callback) == 'function', 'Point.setCallback: callback must be a function, got '..type(_callback))
    if _event == 1 then
        self.callbacks.onDraw = _callback
    elseif _event == 2 then
        self.callbacks.onPress = _callback
    elseif _event == 3 then
        self.callbacks.onFailedPress = _callback
    end
end

function Point:touch(_x, _y, _event, _cantUpdate)
    assert(type(_x) == 'number', 'Point.touch: x must be a number, got '..type(_x))
    assert(type(_y) == 'number', 'Point.touch: y must be a number, got '..type(_y))

    if not self.hidden then
        if not _cantUpdate then
            if (self.pos.x == _x) and (self.pos.y == _y) then -- CHECK IF IT WAS PRESSED
                self.callbacks.onPress(self, _event)
                return true
            else
                self.callbacks.onFailedPress(self, _event)
                return false
            end
        else
            self.callbacks.onFailedPress(self, _event)
        end
    end
    return false
end

function Point:hide(_bool)
    assert(type(_bool) == 'boolean', 'Point.hide: bool must be a boolean, got '..type(_bool))
    self.hidden = _bool
end

Point.__index = Point

--//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////--

Rectangle = {}

function Rectangle.new(_x1, _y1, _x2, _y2, _color, _type)
    
    assert(type(_x1) == 'number', 'Rectangle.new: x1 must be a number, got '..type(_x1))
    assert(type(_y1) == 'number', 'Rectangle.new: y1 must be a number, got '..type(_y1))
    assert(type(_x2) == 'number', 'Rectangle.new: x2 must be a number, got '..type(_x2))
    assert(type(_y2) == 'number', 'Rectangle.new: y2 must be a number, got '..type(_y2))
    
    --FIX THINGS
    _color = tonumber(_color)
    _type = tonumber(_type)

    --CHECK THINGS
    if not _color then
        _color = globalColor
    end
    if not _type then
        _type = globalRectangleType
    end

    --CREATE RECTANGLE
    _newRectangle = {
        color = _color,
        type = _type,
        hidden = false,
        pos = {
            x1 = _x1,
            y1 = _y1,
            x2 = _x2,
            y2 = _y2
        },
        callbacks = {
            onDraw = function() end,
            onPress = function() end,
            onFailedPress = function() end
        }
    }
    setmetatable(_newRectangle, Rectangle) --SET RECTANGLE METATABLE
    return _newRectangle
end

function Rectangle:draw()
    if not self.hidden then
        self.callbacks.onDraw(self)

        local oldRectType = globalRectangleType
        local oldColor = globalColor
        
        --SETTING THINGS TO RECTANGLE SETTINGS
        setRectangleType(self.type)
        setColor(self.color)

        --DRAWING RECTANGLE
        rectangle(self.pos.x1, self.pos.y1, self.pos.x2, self.pos.y2)

        --REVERTING ALL CHANGES MADE BEFORE
        setRectangleType(oldRectType)
        setColor(oldColor)
    end
end

function Rectangle:setCallback(_event, _callback)
    assert(type(_callback) == 'function', 'Rectangle.setCallback: callback must be a function, got '..type(_callback))
    if _event == 1 then
        self.callbacks.onDraw = _callback
    elseif _event == 2 then
        self.callbacks.onPress = _callback
    elseif _event == 3 then
        self.callbacks.onFailedPress = _callback
    end
end

function Rectangle:touch(_x, _y, _event, _cantUpdate)
    assert(type(_x) == 'number', 'Rectangle.touch: x must be a number, got '..type(_x))
    assert(type(_y) == 'number', 'Rectangle.touch: y must be a number, got '..type(_y))

    if not self.hidden then
        if not _cantUpdate then
            if checkAreaPress(self.pos.x1, self.pos.y1, self.pos.x2, self.pos.y2, _x, _y) then -- CHECK IF IT WAS PRESSED
                self.callbacks.onPress(self, _event)
                return true
            else
                self.callbacks.onFailedPress(self, _event)
                return false
            end
        else
            self.callbacks.onFailedPress(self, _event)
        end
    end
    return false
end

function Rectangle:hide(_bool)
    assert(type(_bool) == 'boolean', 'Rectangle.hide: bool must be a boolean, got '..type(_bool))
    self.hidden = _bool
end

Rectangle.__index = Rectangle

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
        
        local lines = stringSplit(self.text, '\n')
        
        self.pos.x = math.floor((globalMonitorWidth - string.len(lines[1]) + 1) / 2)
        text(self.pos.x, self.pos.y, lines[1])
        
        table.remove(lines, 1)
        
        for key, value in pairs(lines) do

            local posX = math.floor((globalMonitorWidth - string.len(value) + 1) / 2)
            local posY = self.pos.y + key
            text(posX, posY, value)

        end

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

function Header:touch(_x, _y, _event, _cantUpdate)
    assert(type(_x) == 'number', 'Header.touch: x must be a number, got '..type(_x))
    assert(type(_y) == 'number', 'Header.touch: y must be a number, got '..type(_y))

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
        else
            self.callbacks.onFailedPress(self, _event)
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

function Label:touch(_x, _y, _event, _cantUpdate)
    assert(type(_x) == 'number', 'Label.touch: x must be a number, got '..type(_x))
    assert(type(_y) == 'number', 'Label.touch: y must be a number, got '..type(_y))

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
        else
            self.callbacks.onFailedPress(self, _event)
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

function Button:touch(_x, _y, _event, _cantUpdate)
    assert(type(_x) == 'number', 'Button.touch: x must be a number, got '..type(_x))
    assert(type(_y) == 'number', 'Button.touch: y must be a number, got '..type(_y))

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
        else
            self.callbacks.onFailedPress(self, _event)
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
        
        for i=#self.objs, 1, -1 do -- DRAW OBJs THAT ARE ATTACHED TO IT
            local obj = self.objs[i]
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

    -- SORT MENU POS
    local _menuX1 = math.min(self.pos.x1, self.pos.x2)
    local _menuX2 = math.max(self.pos.x1, self.pos.x2)
    local _menuY1 = math.min(self.pos.y1, self.pos.y2)
    local _menuY2 = math.max(self.pos.y1, self.pos.y2)

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

function Menu:touch(_x, _y, _event, _cantUpdate)
    assert(type(_x) == 'number', 'Menu.touch: x must be a number, got '..type(_x))
    assert(type(_y) == 'number', 'Menu.touch: y must be a number, got '..type(_y))

    if not self.hidden then
        if not _cantUpdate then
            if checkAreaPress(self.pos.x1, self.pos.y1, self.pos.x2, self.pos.y2, _x, _y) then -- CHECK IF IT WAS PRESSED
                -- IF THE MENU WAS PRESSED CALL CALLBACK
                self.callbacks.onPress(self, _event)
                local _objUpdated = false
                for key, obj in pairs(self.objs) do -- UPDATE OBJs THAT ARE ATTACHED TO IT
                    if obj:touch(_x, _y, _event, _objUpdated) then
                        self.callbacks.onButtonPress(self, obj, _event)
                        _objUpdated = true
                    else
                        self.callbacks.onFailedButtonPress(self, obj, _event)
                    end
                end
                return _objUpdated
            else
                self.callbacks.onFailedPress(self, _event)
                return false
            end
        else
            self.callbacks.onFailedPress(self, _event)
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

function PercentageBar:touch(_x, _y, _event, _cantUpdate)
    assert(type(_x) == 'number', 'PercentageBar.touch: x must be a number, got '..type(_x))
    assert(type(_y) == 'number', 'PercentageBar.touch: y must be a number, got '..type(_y))

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
        else
            self.callbacks.onFailedPress(self, _event)
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
        local _memoX1 = math.min(self.pos.x1, self.pos.x2)
        local _memoX2 = math.max(self.pos.x1, self.pos.x2)
        local _memoY1 = math.min(self.pos.y1, self.pos.y2)
        local _memoY2 = math.max(self.pos.y1, self.pos.y2)
        
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

            if event[1] == 'monitor_touch' and (event[2] == globalMonitorName or (globalMonitorGroup.enabled and tableHasValue(globalMonitorGroup.list, event[2]))) then -- CHECK IF A BUTTON WAS PRESSED
                if checkAreaPress(self.pos.x1, self.pos.y1, self.pos.x2, self.pos.y2, event[3], event[4]) then
                    return true -- IF PRESS OUTSIDE MEMO THEN RETURN TRUE, ELSE FALSE
                else
                    return false
                end
            elseif event[1] == 'mouse_click' and (globalMonitorName == 'term' or (globalMonitorGroup.enabled and tableHasValue(globalMonitorGroup.list, 'term'))) then
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
                self:draw()

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


function Memo:touch(_x, _y, _event, _cantUpdate)
    assert(type(_x) == 'number', 'Memo.touch: x must be a number, got '..type(_x))
    assert(type(_y) == 'number', 'Memo.touch: y must be a number, got '..type(_y))

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

Window = {}

function Window.new(_x1, _y1, _x2, _y2, _color)
    
    assert(type(_x1) == 'number', 'Window.new: x1 must be a number, got '..type(_x1))
    assert(type(_y1) == 'number', 'Window.new: y1 must be a number, got '..type(_y1))
    assert(type(_x2) == 'number', 'Window.new: x2 must be a number, got '..type(_x2))
    assert(type(_y2) == 'number', 'Window.new: y2 must be a number, got '..type(_y2))
    
    --FIX THINGS
    _color = tonumber(_color)

    --CHECK THINGS
    if not _color then
        _color = term.getBackgroundColor()
    end

    --CREATE WINDOW
    _newWindow = {
        active = false,
        hidden = false,
        color = _color,
        grabbedFrom = {
            x = 1,
            y = 1
        },
        shadow = {
            enabled = false,
            color = colors.black,
            offset = {
                x = 1,
                y = 1
            }
        },
        objs = {
            list = {},
            events = {
                draw = {},
                touch = {},
                tick = {},
                key = {},
                char = {},
                mouse_drag = {}
            }
        },
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
            onOBJPress = function() end,
            onFailedOBJPress = function() end,
            onEvent = function() end
        }
    }
    setmetatable(_newWindow, Window) --SET WINDOW METATABLE
    return _newWindow
end

function Window:draw()
    if not self.hidden then
        self.callbacks.onDraw(self)

        local oldRectType = globalRectangleType
        local oldColor = globalColor
        
        -- SETTING THINGS TO WINDOW SETTINGS
        setRectangleType(rectangleTypes.filled)
        
        -- DRAWING SHADOW
        if self.shadow.enabled then
            setColor(self.shadow.color)
            local xOff = self.shadow.offset.x
            local yOff = self.shadow.offset.y
            local x1 = self.pos.x1 + xOff
            local x2 = self.pos.x2 + xOff
            local y1 = self.pos.y1 + yOff
            local y2 = self.pos.y2 + yOff
            rectangle(x1, y1, x2, y2)
        end
        
        -- DRAWING WINDOW
        setColor(self.color)
        rectangle(self.pos.x1, self.pos.y1, self.pos.x2, self.pos.y2)

        -- REVERTING ALL CHANGES MADE BEFORE
        setRectangleType(oldRectType)
        setColor(oldColor)
        
        for _, obj in pairs(self.objs.events.draw) do -- DRAW OBJs THAT ARE ATTACHED TO IT
            obj:draw()
        end
    end
end

function Window:setCallback(_event, _callback)
    assert(type(_callback) == 'function', 'Window.setCallback: callback must be a function, got '..type(_callback))
    if _event == 1 then
        self.callbacks.onDraw = _callback
    elseif _event == 2 then
        self.callbacks.onPress = _callback
    elseif _event == 3 then
        self.callbacks.onFailedPress = _callback
    elseif _event == 4 then
        self.callbacks.onOBJPress = _callback
    elseif _event == 5 then
        self.callbacks.onFailedOBJPress = _callback
    elseif _event == 6 then
        self.callbacks.onEvent = _callback
    end
end

function Window:set(_objGroup)
    assert(type(_objGroup) == 'table', 'Window.set: objGroup must be a table, got '..type(_objGroup))

    self.objs.list = _objGroup
    self.objs.events = getOBJSEvents(_objGroup)
end

function Window:touch(_x, _y, _event, _cantUpdate)
    assert(type(_x) == 'number', 'Window.touch: x must be a number, got '..type(_x))
    assert(type(_y) == 'number', 'Window.touch: y must be a number, got '..type(_y))

    if not self.hidden then
        self.callbacks.onEvent(self, _event)
        if not _cantUpdate then
            if checkAreaPress(self.pos.x1, self.pos.y1, self.pos.x2, self.pos.y2, _x, _y) then -- CHECK IF IT WAS PRESSED
                -- IF THE WINDOW WAS PRESSED CALL CALLBACK
                self.active = true
                self.grabbedFrom.x = _x
                self.grabbedFrom.y = _y
                self.callbacks.onPress(self, _event)
                
                local _objUpdated = false
                for _, obj in pairs(self.objs.events.touch) do -- UPDATE OBJs THAT ARE ATTACHED TO IT
                    if obj:touch(_x, _y, _event, _objUpdated) then
                        self.callbacks.onOBJPress(self, obj, _event)
                        _objUpdated = true
                    else
                        self.callbacks.onFailedOBJPress(self, obj, _event)
                    end
                end

                return true
            else
                self.active = false
                self.callbacks.onFailedPress(self, _event)
                return false
            end
        else
            self.active = false
            self.callbacks.onFailedPress(self, _event)
        end
    end
    return false
end

function Window:mouse_drag(_event)
    if not self.hidden then
        self.callbacks.onEvent(self, _event)
        if self.active then

            local xDiff = _event[3] - self.grabbedFrom.x
            local yDiff = _event[4] - self.grabbedFrom.y

            self.grabbedFrom.x = _event[3]
            self.grabbedFrom.y = _event[4]

            self.pos.x1 = self.pos.x1 + xDiff
            self.pos.x2 = self.pos.x2 + xDiff
            self.pos.y1 = self.pos.y1 + yDiff
            self.pos.y2 = self.pos.y2 + yDiff

            for _, obj in pairs(self.objs.list) do
                if obj.pos.x then obj.pos.x = obj.pos.x + xDiff; end
                if obj.pos.x1 then obj.pos.x1 = obj.pos.x1 + xDiff; end
                if obj.pos.x2 then obj.pos.x2 = obj.pos.x2 + xDiff; end
                if obj.pos.y then obj.pos.y = obj.pos.y + yDiff; end
                if obj.pos.y1 then obj.pos.y1 = obj.pos.y1 + yDiff; end
                if obj.pos.y2 then obj.pos.y2 = obj.pos.y2 + yDiff; end
            end
        end
    end
end

function Window:tick(_event)
    if not self.hidden then
        self.callbacks.onEvent(self, _event)
        for key, obj in pairs(self.objs.events.tick) do
            obj:tick(_event)
        end
    end
end

function Window:key(_event)
    if not self.hidden then
        self.callbacks.onEvent(self, _event)
        for key, obj in pairs(self.objs.events.key) do
            obj:key(_event)
        end
    end
end

function Window:char(_event)
    if not self.hidden then
        self.callbacks.onEvent(self, _event)
        for key, obj in pairs(self.objs.events.char) do
            obj:char(_event)
        end
    end
end


function Window:hide(_bool)
    assert(type(_bool) == 'boolean', 'Window.hide: bool must be a boolean, got '..type(_bool))
    self.hidden = _bool
end

Window.__index = Window

--//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////--

OBJGroup = {}

function OBJGroup.new()

    --CREATE OBJGROUP
    _newOBJGroup = {
        objs = {
            list = {},
            events = {
                draw = {},
                touch = {},
                tick = {},
                key = {},
                char = {},
                mouse_drag = {}
            }
        },
        hidden = false,
        callbacks = {
            onDraw = function() end,
            onOBJPress = function() end,
            onFailedOBJPress = function() end
        }
    }
    setmetatable(_newOBJGroup, OBJGroup) --SET OBJGROUP METATABLE
    return _newOBJGroup
end

function OBJGroup:draw()
    if not self.hidden then
        self.callbacks.onDraw(self)
        
        for _, obj in pairs(self.objs.events.draw) do -- DRAW OBJs THAT ARE ATTACHED TO IT
            obj:draw()
        end
    end
end

function OBJGroup:setCallback(_event, _callback)
    assert(type(_callback) == 'function', 'OBJGroup.setCallback: callback must be a function, got '..type(_callback))
    if _event == 1 then
        self.callbacks.onDraw = _callback
    elseif _event == 2 then
        self.callbacks.onOBJPress = _callback
    elseif _event == 3 then
        self.callbacks.onFailedOBJPress = _callback
    end
end

function OBJGroup:set(_objGroup)
    assert(type(_objGroup) == 'table', 'OBJGroup.set: objGroup must be a table, got '..type(_objGroup))

    self.objs.list = _objGroup
    self.objs.events = getOBJSEvents(_objGroup)
end

function OBJGroup:touch(_x, _y, _event, _cantUpdate)
    assert(type(_x) == 'number', 'OBJGroup.touch: x must be a number, got '..type(_x))
    assert(type(_y) == 'number', 'OBJGroup.touch: y must be a number, got '..type(_y))

    if not self.hidden then
        if not _cantUpdate then
            local _objUpdated = false
            for _, obj in pairs(self.objs.list) do -- UPDATE OBJs THAT ARE ATTACHED TO IT
                if obj:touch(_x, _y, _event, _objUpdated) then
                    self.callbacks.onOBJPress(self, obj, _event)
                    _objUpdated = true
                else
                    self.callbacks.onFailedOBJPress(self, obj, _event)
                end
            end
            return _objUpdated
        end
    end
    return false
end

function OBJGroup:tick(_event)
    if not self.hidden then
        for key, obj in pairs(self.objs.events.tick) do
            obj:tick(_event)
        end
    end
end

function OBJGroup:key(_event)
    if not self.hidden then
        for key, obj in pairs(self.objs.events.key) do
            obj:key(_event)
        end
    end
end

function OBJGroup:char(_event)
    if not self.hidden then
        for key, obj in pairs(self.objs.events.char) do
            obj:char(_event)
        end
    end
end

function OBJGroup:mouse_drag(_event)
    if not self.hidden then
        for key, obj in pairs(self.objs.events.mouse_drag) do
            obj:mouse_drag(_event)
        end
    end
end

function OBJGroup:hide(_bool)
    assert(type(_bool) == 'boolean', 'OBJGroup.hide: bool must be a boolean, got '..type(_bool))
    self.hidden = _bool
end

OBJGroup.__index = OBJGroup

--//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////--

-- STATS LABELS

globalLoop.stats.FPS = Label.new(0, 0, '0FPS')
globalLoop.stats.EPS = Label.new(0, 0, '0EPS')

globalLoop.stats.FPS.hidden = true
globalLoop.stats.EPS.hidden = true

table.insert(globalLoop.group.LIBPrivate.objs, globalLoop.stats.FPS)
table.insert(globalLoop.group.LIBPrivate.objs, globalLoop.stats.EPS)

--/////////////

function drawOnLoopClock()
    globalLoop.drawOnClock = true
end

function drawOnLoopEvent()
    globalLoop.drawOnClock = false
end

function drawLoopStats(_bool)
    assert(type(_bool) == 'boolean', 'enableLoopStats: bool must be a boolean, got '..type(_bool))
    
    -- IF IS BEING ACTIVATED AND POSITION SHOULD BE CALCULATED AUTOMATICALLY THEN CALCULATE IT
    if _bool and globalLoop.stats.automaticPos then
        local offsetX = globalLoop.stats.automaticPosOffset.x
        local offsetY = globalLoop.stats.automaticPosOffset.y

        globalLoop.stats.FPS.pos.x = globalMonitorWidth - #globalLoop.stats.FPS.text + 1 + offsetX
        globalLoop.stats.FPS.pos.y = globalMonitorHeight - 1 + offsetY
    
        globalLoop.stats.EPS.pos.x = globalMonitorWidth - #globalLoop.stats.EPS.text + 1 + offsetX
        globalLoop.stats.EPS.pos.y = globalMonitorHeight + offsetY
    end

    -- HIDE/UNHIDE STATS
    globalLoop.stats.FPS.hidden = not _bool
    globalLoop.stats.EPS.hidden = not _bool
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
    globalLoop.group[_groupName] = {
        callbacks = {
            onClock = function () end,
            onEvent = function () end,
            onTimer = function () end,
            onMonitorChange = function () end,
            onSet = function () end,
            onUnset = function () end
        },
        objs = _group
    }
end

function removeLoopGroup(_groupName)
    _groupName = tostring(_groupName)
    assert(_groupName ~= 'LIBPrivate' or _groupName ~= 'none', "removeLoopGroup: can't remove Lib's Private groups")
    globalLoop.group[_groupName] = nil
end

function setLoopGroup(_groupName)
    _groupName = tostring(_groupName)
    assert(globalLoop.group[_groupName], 'setLoopGroup: groupName must be a valid group.')
    
    local currentGroup = globalLoop.group[globalLoop.selectedGroup]
    local newGroup = globalLoop.group[_groupName]

    currentGroup.callbacks.onUnset(currentGroup, newGroup)
    
    globalLoop.selectedGroup = _groupName

    newGroup.callbacks.onSet(newGroup, currentGroup)

    globalLoop.wasGroupChanged = true
end

function setLoopGroupCallback(_groupName, _event, _callback)
    _groupName = tostring(_groupName)
    assert(_groupName ~= 'LIBPrivate' or _groupName ~= 'none', "setLoopGroupCallback: can't overwrite Lib's Private groups' callbacks")
    assert(globalLoop.group[_groupName], 'setLoopGroupCallback: groupName must be a valid group.')
    assert(type(_callback) == 'function', 'setLoopGroupCallback: callback must be a function, got '..type(_callback))
    if _event == 1 then
        globalLoop.group[_groupName].callbacks.onClock = _callback
    elseif _event == 2 then
        globalLoop.group[_groupName].callbacks.onEvent = _callback
    elseif _event == 3 then
        globalLoop.group[_groupName].callbacks.onTimer = _callback
    elseif _event == 4 then
        globalLoop.group[_groupName].callbacks.onMonitorChange = _callback
    elseif _event == 5 then
        globalLoop.group[_groupName].callbacks.onSet = _callback
    elseif _event == 6 then
        globalLoop.group[_groupName].callbacks.onUnset = _callback
    end
end

function resetLoopSettings()
    
    globalLoop.APLWDBroadcastOnClock = false
    globalLoop.APLWDClearCacheOnDraw = true
    globalLoop.stats.FPS.hidden = true
    globalLoop.stats.EPS.hidden = true

    globalLoop.callbacks.onInit = function() end
    globalLoop.callbacks.onEvent = function() end -- CLEARS LOOP CALLBACKS
    globalLoop.callbacks.onClock = function() end

    globalLoop.selectedGroup = 'none'
    globalLoop.group = {
        none = {
            callbacks = {
                onClock = function () end,
                onEvent = function () end,
                onTimer = function () end,
                onMonitorChange = function () end,
                onSet = function () end,
                onUnset = function () end
            },
            objs = {}
        },
        LIBPrivate = {
            callbacks = {
                onClock = function () end,
                onEvent = function () end,
                onTimer = function () end,
                onMonitorChange = function () end,
                onSet = function () end,
                onUnset = function () end
            },
            objs = {}
        }
    } --CLEARS LOOP GROUPS

    globalLoop.events = {
        draw = {},
        touch = {},
        tick = {},
        key = {},
        char = {},
        mouse_drag = {}
    } -- CLEARS LOOP EVENTS SPECIFIC OBJ FUNCTIONS
end

function stopLoop()
    globalLoop.enabled = false --STOP LOOP
    
    globalLoop.events = {
        draw = {},
        touch = {},
        tick = {},
        key = {},
        char = {},
        mouse_drag = {}
    } -- CLEARS LOOP EVENTS SPECIFIC OBJ FUNCTIONS
end

function loop()
    
    globalLoop.enabled = true -- ACTIVATE LOOP

    if globalLoop.autoClear then
        bClearMonitorGroup()
    end
    
    updateLoopEvents()
    
    globalLoop.callbacks.onInit()
    drawLoopOBJs()
    
    -- CREATE STATS CLOCK
    local statsClock = Clock.new(1)
    statsClock.FPS = 0
    statsClock.EPS = 0
    statsClock:setCallback(
        event.clock.onClock,
        function (self, event)
            globalLoop.stats.FPS.text = tostring(self.FPS)..'FPS'
            globalLoop.stats.EPS.text = tostring(self.EPS)..'EPS'

            if globalLoop.stats.automaticPos then
                local offsetX = globalLoop.stats.automaticPosOffset.x
                local offsetY = globalLoop.stats.automaticPosOffset.y
        
                globalLoop.stats.FPS.pos.x = globalMonitorWidth - #globalLoop.stats.FPS.text + 1 + offsetX
                globalLoop.stats.FPS.pos.y = globalMonitorHeight - 1 + offsetY
            
                globalLoop.stats.EPS.pos.x = globalMonitorWidth - #globalLoop.stats.EPS.text + 1 + offsetX
                globalLoop.stats.EPS.pos.y = globalMonitorHeight + offsetY
            end

            self.FPS = 0
            self.EPS = 0
        end
    )
    
    -- SET LOOP CLOCK
    local loopClock = os.clock()
    
    while globalLoop.enabled do

        if globalLoop.wasGroupChanged then
            updateLoopEvents()
            globalLoop.wasGroupChanged = false
        end

        local Timer = os.startTimer(globalLoop.timerSpeed) -- START A TIMER

        local event = {os.pullEvent()} -- PULL EVENTS

        -- EVENT
        if event[1] == 'monitor_touch' and (event[2] == globalMonitorName or (globalMonitorGroup.enabled and tableHasValue(globalMonitorGroup.list, event[2]))) then -- CHECK IF A BUTTON WAS PRESSED
            
            touchLoopOBJs(event[3], event[4], event)

        elseif event[1] == 'mouse_click' and (globalMonitorName == 'term' or (globalMonitorGroup.enabled and tableHasValue(globalMonitorGroup.list, 'term'))) then
            
            touchLoopOBJs(event[3], event[4], event)

        elseif event[1] == 'key' then
            for _, obj in pairs(globalLoop.events.key) do -- CALL OBJs KEY EVENTS
                obj:key(event)
            end

        elseif event[1] == 'char' then
            for _, obj in pairs(globalLoop.events.char) do -- CALL OBJs CHAR EVENTS
                obj:char(event)
            end

        elseif event[1] == 'mouse_drag' then
            for _, obj in pairs(globalLoop.events.mouse_drag) do -- CALL OBJs MOUSE_DRAG EVENTS
                obj:mouse_drag(event)
            end

        elseif event[1] == 'timer' then
            globalLoop.callbacks.onTimer(event)
            globalLoop.group[globalLoop.selectedGroup].callbacks.onTimer(event)
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
                    bClearMonitorGroup()
                end
                globalLoop.callbacks.onClock(event) -- CLOCK CALLBACK
                globalLoop.group[globalLoop.selectedGroup].callbacks.onClock(event)
                drawLoopOBJs()

                -- add 1 Frame to FPS
                statsClock.FPS = statsClock.FPS + 1
            else
                globalLoop.callbacks.onClock(event) -- CLOCK CALLBACK
                globalLoop.group[globalLoop.selectedGroup].callbacks.onClock(event)
            end

            if APLWD.enabled and globalLoop.APLWDBroadcastOnClock then
                APLWD.broadcastCache() -- BROADCAST APLWDCACHE ON CLOCK
            end
        end
        
        --EVENT DRAW
        if not globalLoop.drawOnClock then -- NON CLOCK DRAW
            if APLWD.enabled and globalLoop.APLWDClearCacheOnDraw then
                APLWD.clearCache()
            end
            
            if globalLoop.autoClear then
                bClearMonitorGroup()
            end
            globalLoop.callbacks.onEvent(event) -- EVENT CALLBACK
            globalLoop.group[globalLoop.selectedGroup].callbacks.onEvent(event)
            drawLoopOBJs()
            
            -- add 1 Frame to FPS
            statsClock.FPS = statsClock.FPS + 1
        else
            globalLoop.callbacks.onEvent(event) -- EVENT CALLBACK
            globalLoop.group[globalLoop.selectedGroup].callbacks.onEvent(event)
        end
        
        --OBJ EVENT TICK
        for _, obj in pairs(globalLoop.events.tick) do
            obj:tick(event)
        end
        
        -- Stats clock
        statsClock:tick()
        
        -- add 1 Event to EPS
        statsClock.EPS = statsClock.EPS + 1

        os.cancelTimer(Timer) -- DELETE TIMER
    end
end

function getOBJSEvents(_table)
    assert(type(_table) == 'table', 'getOBJSEvents: table must be a table, got '..type(_table))

    local eventsTable = { -- CREATE RETURN TABLE
        draw = {},
        touch = {},
        tick = {},
        key = {},
        char = {},
        mouse_drag = {}
    }

    for _, obj in pairs(_table) do -- SORT OBJS IN TABLE
        if obj.draw then
            table.insert(eventsTable.draw, 1, obj)
        end
        if obj.touch then
            table.insert(eventsTable.touch, obj)
        end
        if obj.tick then
            table.insert(eventsTable.tick, obj)
        end
        if obj.key then
            table.insert(eventsTable.key, obj)
        end
        if obj.char then
            table.insert(eventsTable.char, obj)
        end
        if obj.mouse_drag then
            table.insert(eventsTable.mouse_drag, obj)
        end
    end

    return eventsTable -- RETURN EVENTSTABLE
end

function updateLoopEvents()
    
    local _objs = {} -- CREATE OBJS TABLE

    for _, obj in pairs(globalLoop.group.LIBPrivate.objs) do -- INSERT LIBPRIVATE OBJS TO OBJS TABLE
        table.insert(_objs, obj)
    end
    
    for _, obj in pairs(globalLoop.group[globalLoop.selectedGroup].objs) do -- INSERT CURRENT LOOP GROUP OBJS TO OBJS TABLE
        table.insert(_objs, obj)
    end

    globalLoop.events = getOBJSEvents(_objs) -- PUT OBJS EVENTS INTO GLOBALLOOP EVENTS
end

function drawLoopOBJs()
    if globalMonitorGroup.enabled then -- CHECKS IF MONITORGROUP IS ENABLED
        globalLoop.callbacks.onMonitorChange(monitorName) -- CALLS onMonitorChange EVENT
        globalLoop.group[globalLoop.selectedGroup].callbacks.onMonitorChange(monitorName)
        for key, obj in pairs(globalLoop.events.draw) do -- DRAW ALL OBJs
            obj:draw()
        end

        local wasCacheWritable = APLWD.cacheWritable
        if APLWD.enabled and wasCacheWritable then APLWD.cacheWritable = false; end -- DISABLE APLWD CACHE WRITE
        local oldMonitor = globalMonitorName -- SAVES ORIGINAL MONITOR
        for _, monitorName in pairs(globalMonitorGroup.list) do -- LOOPS THROUGH ALL MONITORS
            if monitorName ~= oldMonitor then -- DRAW ONLY ON MONITOR THAT WASN'T THE GLOBAL ONE
                setMonitor(monitorName)
                globalLoop.callbacks.onMonitorChange(monitorName)
                globalLoop.group[globalLoop.selectedGroup].callbacks.onMonitorChange(monitorName)
                for key, obj in pairs(globalLoop.events.draw) do -- DRAW ALL OBJs
                    obj:draw()
                end
                
            end
        end
        setMonitor(oldMonitor) -- RESETS TO ORIGINAL MONITOR
        if APLWD.enabled and wasCacheWritable then APLWD.cacheWritable = true; end -- ENABLE APLWD CACHE WRITE
    else
        for key, obj in pairs(globalLoop.events.draw) do -- DRAW ALL OBJs
            obj:draw()
        end
    end
end

function touchLoopOBJs(_x, _y, _event)
    assert(type(_x) == 'number', 'touchLoopOBJs: x must be a number, got '..type(_x))
    assert(type(_y) == 'number', 'touchLoopOBJs: y must be a number, got '..type(_y))
    local _objAlreadyTouched = false
    
    for _, obj in pairs(globalLoop.events.touch) do -- UPDATE OBJs
        if obj:touch(_x, _y, _event, _objAlreadyTouched) then
            _objAlreadyTouched = true
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
            error('Setup failed, shell API not available!')
        end
    elseif tArgs[1] == 'create' then -- OPTION CREATE
        if tArgs[2] then
            -- STORE TEXT IN A VARIABLE
            local _text = '\n-- //AUTO-GENERATED-CODE//\nlocal APLibPath = settings.get(\'APLibPath\')\n\nassert(  -- check if setup was done before, if not return with an error\n    type(APLibPath) == \'string\',\n    \'Couldn\\\'t open APLib through path: \'..tostring(\n        APLibPath\n    )..\'; probably you haven\\\'t completed Lib setup via \\\'LIBFILE setup\\\' or the setup failed\'\n)\n\nassert( -- check if Lib is still there, if not return with an error\n    fs.exists(APLibPath),\n    \'Couldn\\\'t open APLib through path: \'..tostring(\n      	APLibPath\n    )..\'; remember that if you move the Lib\\\'s folder you must set it up again via \\\'LIBFILE setup\\\'\'\n)\n\nos.loadAPI(APLibPath) -- load Lib with CraftOS\'s built-in feature\n\nAPLibPath = fs.getName(APLibPath)\nif APLibPath:sub(#APLibPath - 3) == \'.lua\' then APLibPath = APLibPath:sub(1, #APLibPath - 4); end\nlocal APLib = _ENV[APLibPath]\nAPLibPath = nil\n-- //--//\n\n'
            -- STORE PATH IN A VARIABLE
            local path = '/'..tArgs[2]
            if fs.exists(path) then
                print('Are you sure you want to overwrite: '..path)
                print('Press ENTER to confirm or another key to cancel.')
                local event = {os.pullEvent('key')}
                if event[2] == 28 then
                    local _file = fs.open(path, 'w') -- OPEN FILE WITH NAME tArgs[1]
                    if _file then -- IF FILE WAS OPENED THEN
                        _file.write(_text) -- WRITE TEXT IN THE FILE
                        _file.close() -- CLOSE THE FILE
                        print('File succesfully created!')
                    else
                        print('Couldn\'t create file.')
                    end
                else
                    print('File wasn\'t created!')
                end
            else
                local _file = fs.open(path, 'w') -- OPEN FILE WITH NAME tArgs[1]
                if _file then -- IF FILE WAS OPENED THEN
                    _file.write(_text) -- WRITE TEXT IN THE FILE
                    _file.close() -- CLOSE THE FILE
                    print('File succesfully created!')
                else
                    print('Couldn\'t create file.')
                end
            end
        else
            print('You must specify the name of the file you want to create.')
        end
    end
end
