os.loadAPI('APLib/APLib.lua')

local shapeColor = colors.lightGray
local textColor = colors.white
local bgTextColor = colors.gray
local bgColor = colors.gray

local defPath = "/Documents/"
local CurrFile = defPath.."new"
local File

local tArgs = { ... }

APLib.setColor(shapeColor)
APLib.setTextColor(textColor)
APLib.setBackgroundTextColor(bgTextColor)

-- CREATING MEMO
local mMemo = APLib.Memo.new(5, 2, 51, 18, nil, nil, colors.black)
mMemo:limits(true)
mMemo:setCursorLimits(nil, 9999)
mMemo:optimize(true)

local mbmInput = APLib.Memo.new(0, 0, 0, 0, nil, shapeColor, shapeColor)
mbmInput:optimize(true)

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

local lPath = APLib.Label.new(1, 19, CurrFile)

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
    _memo:draw()
end

local function OpenNotes(_memo, FileName)
    if FileName and FileName ~= '' then
        if fs.exists(FileName) and not fs.isDir(FileName) then
            _memo:setCursorPos(0, 0)
            _memo.lines = {}
            File = fs.open(FileName, "r")
            while true do
                local currLineText = File.readLine()
                if currLineText == nil then break; end
                table.insert(_memo.lines, currLineText)
            end
            File.close()
            _memo:draw()
        else
            _memo:setCursorPos(0, 0)
            FileName = 'new'
            _memo.lines = {}
            _memo:draw()
        end
        if string.sub(FileName, 1, #defPath) ~= defPath then
            FileName = defPath..FileName
            if (string.sub(FileName, #defPath + 1, #defPath + 1) == "/") then
                FileName = string.sub(FileName, 1, #defPath)..string.sub(FileName, #defPath + 2)
            end
        end
        CurrFile = FileName
    end
end

local function SaveNotes(_memo, FileName)
    if FileName and FileName ~= '' then
        if string.sub(FileName, 1, #defPath) ~= defPath then
            FileName = defPath..FileName
            if (string.sub(FileName, #defPath + 1, #defPath + 1) == '/') then
                FileName = string.sub(FileName, 1, #defPath)..string.sub(FileName, #defPath + 2)
            end
        end
        if not fs.exists(FileName) then
            File = fs.open(FileName, 'w')
            for i=1, #_memo.lines do
                File.writeLine(_memo.lines[i])
            end
            File.close()
            CurrFile = FileName
        else
            if not forceOverwrite then
                local function drawPrompt()
                    APLib.setColor(bgTextColor)
                    APLib.rectangle(19, 8, 31, 11)
                    APLib.setColor(shapeColor)
                    APLib.text(20, 8, 'Do you want')
                    APLib.text(19, 9, 'to overwrite?')
                    APLib.text(19, 11, 'Yes(Y)')
                    APLib.text(27, 11, 'No(N)')
                end

                local libInfo = APLib.getInfo()

                if libInfo.globalMonitorGroup.enabled then

                    libInfo.globalLoop.callbacks.onMonitorChange(monitorName)
                    drawPrompt()
                    local oldMonitor = libInfo.globalMonitorName
                    for _, monitorName in pairs(libInfo.globalMonitorGroup.list) do
                        APLib.setMonitor(monitorName)
                        libInfo.globalLoop.callbacks.onMonitorChange(monitorName)
                        drawPrompt()
                    end
                    APLib.setMonitor(oldMonitor)
                else
                    drawPrompt()
                end

                while true do
                    local event = {os.pullEvent()}
                    if event[1] == "char" then
                        if (event[2] == "n") or (event[2] == "N") then
                            break
                        elseif (event[2] == "y") or (event[2] == "Y") then
                            File = fs.open(FileName, "w")
                            for i=1, #_memo.lines do
                                File.writeLine(_memo.lines[i])
                            end
                            File.close()
                            CurrFile = FileName
                            break
                        end
                    end
                end

            end
        end
    elseif not FileName or FileName == '' then
        File = fs.open(CurrFile, 'w')
        for i=1, #_memo.lines do
            File.writeLine(_memo.lines[i])
        end
        File.close()
    end
end


local function DeleteNotes()
    fs.delete(CurrFile)
    CurrFile = defPath..'new'
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

local function drawBackgroundToAllScreens(_color)
    if _color then
        local libInfo = APLib.getInfo()

        if libInfo.globalMonitorGroup.enabled then
            libInfo.globalLoop.callbacks.onMonitorChange(monitorName)
            APLib.setBackground(_color)
            local oldMonitor = libInfo.globalMonitorName
            for _, monitorName in pairs(libInfo.globalMonitorGroup.list) do
                APLib.setMonitor(monitorName)
                libInfo.globalLoop.callbacks.onMonitorChange(monitorName)
                APLib.setBackground(_color)
            end
            APLib.setMonitor(oldMonitor)
        else
            APLib.setBackground(_color)
        end
    end
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
            SaveNotes(mMemo, nil, true)
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

        mbmInput:setCursorPos(0, 0)
        mbmInput:setCursorLimits(4, 1)
        mbmInput:edit()

        if tonumber(mbmInput.lines[1]) then
            mMemo:setCursorPos(0, tonumber(mbmInput.lines[1]) - 1)
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
        APLib.setColor(bgColor)
        APLib.rectangle(lLines.pos.x, lLines.pos.y, lLines.pos.x + #lLines.text - 1, lLines.pos.y)
        APLib.setColor(shapeColor)
        lLines.text = 'Lines: '..#self.lines
        lLines:draw()
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

--//-----------------------------------------\\--

-- MAIN PROGRAM
local objs = {mMemo, mbFile, bCompact, mFileMenu, lLines, lPath}

APLib.setLoopCallback(
    APLib.event.loop.onInit,
    function ()
        APLib.setBackground(bgColor)
    end
)

APLib.setLoopCallback(
    APLib.event.loop.onClock,
    function (event)

        drawBackgroundToAllScreens(bgColor)

        APLib.setColor(bgColor)
        APLib.rectangle(lLines.pos.x, lLines.pos.y, lLines.pos.x + #lLines.text - 1, lLines.pos.y)
        APLib.setColor(shapeColor)
        lLines.text = 'Lines: '..#mMemo.lines
        lLines:draw()

        lPath.text = CurrFile
    end
)

if table.maxn(tArgs) > 0 then
    if tArgs[1] then
        tArgs[1] = string.lower(tArgs[1])
        if tArgs[1] == 'open' then
            if tArgs[2] then
                OpenNotes(mMemo, tostring(tArgs[2]))
            end
        elseif tArgs[1] == 'multi' then
            if tArgs[2] then
                if tostring(peripheral.getType(tArgs[2])) == 'monitor' then
                    local monGroup = {tArgs[2]}
                    APLib.setMonitorGroup(monGroup)
                    APLib.setMonitorGroupEnabled(true)
                end
            end
        end
    end
end

APLib.setMonitor('term')

APLib.drawOnLoopEvent()
APLib.loop(objs)

drawBackgroundToAllScreens(colors.black)

