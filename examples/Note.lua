
--//INIT\\--
if type(settings.get('APLibPath')) == 'string' then
    if fs.exists(tostring(settings.get('APLibPath'))) then
        os.loadAPI(settings.get('APLibPath'))
    else
        error("Couldn't open APLib through path: "..tostring(
                settings.get('APLibPath')
            )..";\n remember that if you move the lib's folder\n you must set it up again via 'LIBFILE setup'")
    end
else
    error("Couldn't open APLib through path: "..tostring(
        settings.get('APLibPath')
    )..";\n probably you haven't completed Lib setup\n via 'LIBFILE setup' or the setup failed")
end

--//-----------------------------------------\\--

local tArgs = { ... }

local shapeColor = colors.lightGray
local textColor = colors.white
local bgTextColor = colors.gray
local bgColor = colors.gray

local defPath

if type(settings.get('NotesPath')) == 'string' then
    local path = settings.get('NotesPath')
    if path:sub(1, 1) == '/' then
        path = path:sub(2)
    end
    if path:sub(#path, #path) == '/' then
        path = path:sub(1, #path - 1)
    end
    defPath = settings.get('NotesPath')
else
    defPath = 'Documents'
end

local owpFileName
local CurrFile = defPath..'/new'
local File

APLib.setColor(shapeColor)
APLib.setTextColor(textColor)
APLib.setBackgroundTextColor(bgTextColor)

-- CREATING MEMO
local mMemo = APLib.Memo.new(5, 2, 51, 18, nil, nil, colors.black)
mMemo:limits(true)
mMemo:setCursorLimits(nil, 9999)

--mMemo:enableSelfLoop(true)

local mbmInput = APLib.Memo.new(0, 0, 0, 0, nil, shapeColor, shapeColor)
mbmInput:enableSelfLoop(true)

-- CREATING BUTTONS
local mbFile = APLib.Button.new(1, 1, 4, 1, 'File', nil, nil, colors.lightGray, colors.gray)

local mbNewOpen = APLib.Button.new(0, 0, 0, 0, 'New/Open', nil, nil, colors.lightGray, colors.gray)
local mbSave = APLib.Button.new(0, 0, 0, 0, 'Save', nil, nil, colors.lightGray, colors.gray)
local mbSaveAs = APLib.Button.new(0, 0, 0, 0, 'SaveAs', nil, nil, colors.lightGray, colors.gray)
local mbDelete = APLib.Button.new(0, 0, 0, 0, 'Delete', nil, nil, colors.lightGray, colors.gray)
local mbGoto = APLib.Button.new(0, 0, 0, 0, 'Goto', nil, nil, colors.lightGray, colors.gray)
local mbRun = APLib.Button.new(0, 0, 0, 0, 'Run', nil, nil, colors.lightGray, colors.gray)
local mbExit = APLib.Button.new(0, 0, 0, 0, 'Exit', nil, nil, colors.green, colors.red)

local mFileButtons = {mbNewOpen, mbSave, mbSaveAs, mbDelete, mbGoto, mbRun, mbExit}

local bCompact = APLib.Button.new(51, 1, 51, 1, 'C', nil, nil, colors.green, colors.red)

-- CREATING MENUS
local mFileMenu = APLib.Menu.new(1, 2, 10, 8)
mFileMenu:set(mFileButtons)


-- LABELS
local lLines = APLib.Label.new(9, 1, 'Lines: '..#mMemo.lines)
local lCursorPos = APLib.Label.new(21, 1, 'Cursor: ('..mMemo.cursor.pos.char..'; '..mMemo.cursor.pos.line..')')

local lPath = APLib.Label.new(1, 19, CurrFile)

local main = {mFileMenu, mbFile, bCompact, mMemo, lLines, lCursorPos, lPath}

-- CREATING OVERWRITE PROMPT

local owplL1 = APLib.Label.new(20, 8, 'Do you want', nil, colors.lightGray)
local owplL2 = APLib.Label.new(19, 9, 'to overwrite?', nil, colors.lightGray)

local owpbAccept = APLib.Button.new(19, 11, 21, 11, 'Yes', nil, nil, colors.gray, colors.lightGray)
local owpbReject = APLib.Button.new(30, 11, 31, 11, 'No', nil, nil, colors.gray, colors.lightGray)

local owpwMain = APLib.Window.new(18, 7, 32, 12, colors.lightGray)
owpwMain:set({owplL1, owplL2, owpbAccept, owpbReject, owprBG})

-- FUNCTIONS

local function CompactNotes(_memo)
    local i = 1
    while i <= #_memo.lines do
        if _memo.lines[i] == '' or _memo.lines[i] == ' ' then
            table.remove(_memo.lines, i)
        else
            i = i + 1
        end
    end
    _memo:setCursorPos(1, 1)
    _memo:draw()
end

local function OpenNotes(_memo, FileName)
    FileName = tostring(FileName)
    if FileName:sub(1, #defPath) ~= defPath then FileName = defPath..'/'..FileName end

    if fs.exists(FileName) and not fs.isDir(FileName) then
        _memo:clear()
        local File = fs.open(FileName, 'r')
        while true do
            local currLine = File.readLine()
            if not currLine then break; end
            table.insert(_memo.lines, currLine)
        end
        File.close()

        if fs.getDir(FileName):sub(1, #defPath) ~= defPath then
            local name = APLib.stringSplit(FileName, '/')
            name = name[#name]
            FileName = defPath..'/'..fs.getDir(FileName)..'/'..name
        end

        CurrFile = FileName
    else
        _memo:clear()
        CurrFile = defPath..'/new'
    end
end

local function SaveNotes(_memo, FileName)
    FileName = tostring(FileName)
    if FileName:sub(1, #defPath) ~= defPath then FileName = defPath..'/'..FileName end
    if fs.getDir(FileName):sub(1, #defPath) ~= defPath then
        local name = APLib.stringSplit(FileName, '/')
        name = name[#name]
        FileName = defPath..'/'..fs.getDir(FileName)..'/'..name
    end

    if not fs.exists(FileName) then
        
        local File = fs.open(FileName, 'w')
        
        if not File then return; end

        for key, value in pairs(_memo.lines) do
            File.writeLine(value)
        end
        
        File.close()
        
        CurrFile = FileName
        
    else
        
        owpFileName = FileName
        
        APLib.setLoopGroup('owp')
        
    end
end

local function DeleteNotes()
    fs.delete(CurrFile)
    CurrFile = defPath..'/new'
end

local function RunNotes()
    term.clear()
    term.setCursorPos(1, 1)
    local oldCurrFile = CurrFile
    SaveNotes(mMemo, CurrFile..'.temp')
    os.run({}, CurrFile)
    fs.delete(CurrFile)
    CurrFile = oldCurrFile
end

-- OBJs CALLBACKS

--//MENU BUTTONS\\--
mbFile:setCallback(
    APLib.event.button.onPress,
    function (self, event)
        mFileMenu:hide(not self.state)
    end
)

mbNewOpen:setCallback(
    APLib.event.button.onPress,
    function (self, event)
        self:draw()

        mbmInput.pos.x1 = self.pos.x2 + 1
        mbmInput.pos.x2 = self.pos.x2 + 1 + 6
        mbmInput.pos.y1 = self.pos.y1
        mbmInput.pos.y2 = self.pos.y1

        mbmInput:setCursorPos(0, 0)
        mbmInput:setCursorLimits(nil, 1)
        mbmInput:edit()

        OpenNotes(mMemo, mbmInput.lines[1])
        mbmInput.lines = {}
        self.state = false
    end
)

mbSave:setCallback(
    APLib.event.button.onPress,
    function (self, event)
        if self.state then
            self:draw()
            sleep(0.5)
            self.state = false
            self:draw()
            SaveNotes(mMemo, CurrFile)
        end
    end
)

mbSaveAs:setCallback(
    APLib.event.button.onPress,
    function (self, event)
        self:draw()

        mbmInput.pos.x1 = self.pos.x2 + 1
        mbmInput.pos.x2 = self.pos.x2 + 1 + 6
        mbmInput.pos.y1 = self.pos.y1
        mbmInput.pos.y2 = self.pos.y1

        mbmInput:setCursorPos(0, 0)
        mbmInput:setCursorLimits(nil, 1)
        mbmInput:edit()

        if tostring(mbmInput.lines[1]) then
            SaveNotes(mMemo, tostring(mbmInput.lines[1]))
        end
        mbmInput.lines = {}
        self.state = false
    end
)

mbGoto:setCallback(
    APLib.event.button.onPress,
    function (self, event)
        self:draw()

        mbmInput.pos.x1 = self.pos.x2 + 1
        mbmInput.pos.x2 = self.pos.x2 + 1 + 4
        mbmInput.pos.y1 = self.pos.y1
        mbmInput.pos.y2 = self.pos.y1

        mbmInput:setCursorPos(1, 1)
        mbmInput:setCursorLimits(4, 1)
        mbmInput:edit()

        if tonumber(mbmInput.lines[1]) then
            mMemo:setCursorPos(1, tonumber(mbmInput.lines[1]))
        end
        mbmInput.lines = {}
        self.state = false
    end
)

mbRun:setCallback(
    APLib.event.button.onPress,
    function (self, event)
        if self.state then
            self:draw()
            sleep(0.5)
            self.state = false
            self:draw()
            RunNotes()
        end
    end
)

mbExit:setCallback(
    APLib.event.button.onPress,
    function (self, event)
        if self.state then
            self:draw()
            sleep(0.5)
            self.state = false
            self:draw()
            APLib.stopLoop()
            APLib.resetLoopSettings()
        end
    end
)

--//-----------------------------------------\\--

owpbAccept:setCallback(
    APLib.event.button.onPress,
    function (self, event)
        if owpFileName then
            if not fs.isDir(owpFileName) then
                fs.delete(owpFileName)
                SaveNotes(mMemo, owpFileName)
            end
            owpFileName = nil
            self:draw()
            sleep(0.5)
            APLib.setLoopGroup('main')
            self.state = false
        end
    end
)

owpbReject:setCallback(
    APLib.event.button.onPress,
    function (self, event)
        if owpFileName then
            owpFileName = nil
            self:draw()
            sleep(0.5)
            APLib.setLoopGroup('main')
            self.state = false
        end
    end
)

--//-----------------------------------------\\--

bCompact:setCallback(
    APLib.event.button.onPress,
    function (self, event)
        if self.state then
            self:draw()
            sleep(0.5)
            self.state = false
            self:draw()
            CompactNotes(mMemo)
        end
    end
)

--//MEMO\\--

mMemo:setCallback(
    APLib.event.memo.onPress,
    function (self, event)
        if not mFileMenu.hidden then
            mFileMenu:hide(true)

            APLib.setColor(bgTextColor)
            APLib.rectangle(mFileMenu.pos.x1, mFileMenu.pos.y1, mFileMenu.pos.x2, mFileMenu.pos.y2)
            APLib.setColor(shapeColor)

            mbFile.state = false
            mbFile:draw()
        end
    end
)

mMemo:setCallback(
    APLib.event.memo.onEdit,
    function (self, event)
        if event then
            if event[1] == 'mouse_scroll' then
                if event[2] == 1 then
                    mMemo:setCursorPos(mMemo.cursor.pos.char, mMemo.cursor.pos.line + event[2])
                elseif event[2] == -1 then
                    mMemo:setCursorPos(mMemo.cursor.pos.char, mMemo.cursor.pos.line + event[2])
                end
            end
        end
        APLib.setColor(bgColor)
        APLib.rectangle(lLines.pos.x, lLines.pos.y, 50, lLines.pos.y)
        APLib.setColor(shapeColor)
        lLines.text = 'Lines: '..#self.lines
        lLines:draw()
        lCursorPos.text = 'Cursor: ('..mMemo.cursor.pos.char..'; '..mMemo.cursor.pos.line..')'
        lCursorPos:draw()
    end
)

mbmInput:setCallback(
    APLib.event.memo.onEdit,
    function (self, event)
        if event then
            if event[1] == 'key' and event[2] == 28 then
                self.active = false
            end
        end
    end
)

--//LOOP\\--

APLib.addLoopGroup('main', main)
APLib.addLoopGroup('owp', {owpwMain, cAPLWDBroadcast})

APLib.setLoopGroupCallback(
    'main',
    APLib.event.loop.group.onClock,
    function (event)

        APLib.setColor(bgColor)
        APLib.rectangle(lLines.pos.x, lLines.pos.y, lLines.pos.x + #lLines.text - 1, lLines.pos.y)
        APLib.setColor(shapeColor)
        
        lLines.text = 'Lines: '..#mMemo.lines
        lCursorPos.text = 'Cursor: ('..mMemo.cursor.pos.char..'; '..mMemo.cursor.pos.line..')'
        lLines:draw()
        lCursorPos:draw()

        lPath.text = CurrFile
    end
)

APLib.setLoopGroupCallback(
    'main',
    APLib.event.loop.group.onEvent,
    function (event)
        if event[1] == 'mouse_scroll' then
            if event[2] == 1 then
                mMemo:setCursorPos(mMemo.cursor.pos.char, mMemo.cursor.pos.line + event[2])
            elseif event[2] == -1 then
                mMemo:setCursorPos(mMemo.cursor.pos.char, mMemo.cursor.pos.line + event[2])
            end
        end
    end
)

APLib.setLoopGroupCallback(
    'main',
    APLib.event.loop.group.onSet,
    function (self, lastGroup)
        APLib.drawOnLoopClock()
        APLib.globalLoop.stats.FPS.colors.backgroundTextColor = colors.black
    end
)

APLib.setLoopGroupCallback(
    'owp',
    APLib.event.loop.group.onEvent,
    function (event)
        if event[1] == 'char' then
            event[2] = event[2]:lower()
            if event[2] == 'y' then
                owpbAccept.state = true
                owpbAccept.callbacks.onPress(owpbAccept, event)
            elseif event[2] == 'n' then
                owpbReject.state = true
                owpbReject.callbacks.onPress(owpbReject, event)
            end
        end
    end
)

APLib.setLoopGroupCallback(
    'owp',
    APLib.event.loop.group.onSet,
    function (self, lastGroup)
        APLib.drawOnLoopEvent()
        APLib.globalLoop.stats.FPS.colors.backgroundTextColor = colors.gray
    end
)

--//-----------------------------------------\\--

-- MAIN PROGRAM

if table.maxn(tArgs) > 0 then
    tArgs[1] = string.lower(tArgs[1])
    if tArgs[1] == 'open' then
        if tArgs[2] then
            if not tArgs[2]:sub(1, 1) == '/' then
                tArgs[2] = '/'..tArgs[2]
            end
            OpenNotes(mMemo, tArgs[2])
        end
    elseif tArgs[1] == 'multi' then
        if tArgs[2] then
            if tostring(peripheral.getType(tArgs[2])) == 'monitor' then
                table.remove(tArgs, 1)
                APLib.setMonitorGroup(tArgs)
                APLib.setMonitorGroupEnabled(true)
            end
        end
    elseif tArgs[1] == 'path' then
        if tArgs[2] then
            if tArgs[2]:sub(1, 1) ~= '/' then tArgs[2] = '/'..tArgs[2]; end
            if tArgs[2]:sub(#tArgs[2], #tArgs[2]) ~= '/' then tArgs[2] = tArgs[2]..'/'; end
            
            if shell then -- CHECKING IF SHELL API IS AVAILABLE
                local _settingsPath = '/.settings'
                local _NotesPath = tArgs[2]
                settings.set('NotesPath', _NotesPath)
                settings.save(_settingsPath)
                print("Path succesfully changed to '"..tostring(settings.get('NotesPath')).."'")
                sleep(2)
                os.reboot() -- REBOOTING AFTER SETUP
            else
                error("Path change failed, shell API not available!")
            end
        end
    end
end


APLib.setLoopCallback(
    APLib.event.loop.onInit,
    function ()
        APLib.setBackground(bgColor)
    end
)

APLib.setLoopCallback(
    APLib.event.loop.onClock,
    function (event)
        APLib.setBackgroundMonitorGroup(bgColor)
    end
)

APLib.setMonitor('term')

APLib.setLoopClockSpeed(0.1)

APLib.globalLoop.stats.automaticPosOffset.x = APLib.globalLoop.stats.automaticPosOffset.x - 1
APLib.drawLoopStats(true)

APLib.setLoopGroup('main')
APLib.loop()

APLib.setBackgroundMonitorGroup(colors.black)
