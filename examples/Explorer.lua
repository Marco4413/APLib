
-- //AUTO-GENERATED-CODE//
local APLibPath = settings.get('APLibPath')

assert(  -- check if setup was done before, if not return with an error
    type(APLibPath) == 'string',
    'Couldn\'t open APLib through path: '..tostring(
        APLibPath
    )..'; probably you haven\'t completed Lib setup via \'LIBFILE setup\' or the setup failed'
)

assert( -- check if Lib is still there, if not return with an error
    fs.exists(APLibPath),
    'Couldn\'t open APLib through path: '..tostring(
      	APLibPath
    )..'; remember that if you move the Lib\'s folder you must set it up again via \'LIBFILE setup\''
)

os.loadAPI(APLibPath) -- load Lib with CraftOS's built-in feature

APLibPath = fs.getName(APLibPath)
if APLibPath:sub(#APLibPath - 3) == '.lua' then APLibPath = APLibPath:sub(1, #APLibPath - 4); end
local APLib = _ENV[APLibPath]
APLib.APLibPath = APLibPath
APLibPath = nil
-- //MAIN-PROGRAM//

Path = ''
FSDirs = {}
FSFiles = {}

function reloadFS(_path)
    local _list = fs.list(_path)

    FSDirs = {}
    FSFiles = {}

    local _FSDirs = {}
    local _FSFiles = {}

    for key, value in pairs(_list) do
        if fs.isDir(_path..'/'..value) then
            table.insert(_FSDirs, value)
        else
            table.insert(_FSFiles, value)
        end
    end

    table.sort(_FSDirs)
    table.sort(_FSFiles)

    if Path ~= '' then
        table.insert(FSDirs, {name = '..'})
    end
    for key, value in pairs(_FSDirs) do
        table.insert(FSDirs, {name = value})
    end

    for key, value in pairs(_FSFiles) do
        table.insert(FSFiles, {name = value, size = fs.getSize(_path..'/'..value)})
    end
end

function mFSReset()
    mFSDirs:clear()
    mFSFiles:clear()

    local oldLine = mFSDirs.cursor.pos.line

    for key, value in pairs(FSDirs) do
        mFSDirs:print('  '..value.name)
    end
    table.remove(mFSDirs.lines)
    mFSDirs:setCursorPos(1, oldLine)

    oldLine = mFSFiles.cursor.pos.line
    
    for key, value in pairs(FSFiles) do
        mFSFiles:print('  '..value.name..' - Size:'..tostring(value.size))
    end
    table.remove(mFSFiles.lines)
    mFSFiles:setCursorPos(1, oldLine)
end

reloadFS(Path)

-- HEADER

hTitle = APLib.Header.new(1, {'EXPLORER', colors.red, colors.gray})

-- MEMOs

mFSDirs = APLib.Memo.new(1, 2, 25, 19, {colors.lime, nil, colors.lightGray, colors.lightGray})
mFSFiles = APLib.Memo.new(27, 2, 51, 19, {colors.white, nil, colors.lightGray, colors.lightGray})

mFSDirs.editSettings.charEvent = false
mFSDirs.editSettings.keyEvent = false

mFSFiles.editSettings.charEvent = false
mFSFiles.editSettings.keyEvent = false

mFSDirs:setCursorLimits(nil, nil)
mFSFiles:setCursorLimits(nil, nil)

mFSDirs.cursor.text = '>'
mFSFiles.cursor.text = '>'

mFSDirs.cursor.colors.textColor = colors.red
mFSFiles.cursor.colors.textColor = colors.red

mFSReset()

mFSDirs:setCallback(
    APLib.event.memo.onEdit,
    function (self, event)
        if event[1] == 'key' then
            if event[2] == 208 then -- DOWN KEY
                
                self:setCursorPos(1, self.cursor.pos.line + 1)

            elseif event[2] == 200 then -- UP KEY
                
                self:setCursorPos(1, self.cursor.pos.line - 1)

            elseif event[2] == 28 then -- ENTER
                local _selDir = FSDirs[self.cursor.pos.line]
                if _selDir then
                    _selDir = _selDir.name
                    if _selDir == '..' then
                        Path = fs.getDir(Path)
                    else
                        Path = Path..'/'.._selDir
                    end

                    reloadFS(Path)
                    mFSReset()
                end
            end
        end
    end
)

mFSFiles:setCallback(
    APLib.event.memo.onEdit,
    function (self, event)
        if event[1] == 'key' then
            if event[2] == 208 then -- DOWN KEY
                
                self:setCursorPos(1, self.cursor.pos.line + 1)

            elseif event[2] == 200 then -- UP KEY
                
                self:setCursorPos(1, self.cursor.pos.line - 1)

            elseif event[2] == 28 then -- ENTER
                local _selFile = FSFiles[self.cursor.pos.line]
                if _selFile then
                    _selFile = _selFile.name

                    os.run({}, '/Note.lua', 'open', Path..'/'.._selFile)
                    
                end
            end
        end
    end
)

APLib.setLoopCallback(
    APLib.event.loop.onClock,
    function (_event)
        APLib.setBackground(colors.gray)
    end
)

APLib.setBackground(colors.gray)
APLib.addLoopGroup('main', {hTitle, mFSDirs, mFSFiles})
APLib.setLoopGroup('main')
APLib.loop()

-- //AUTO-GENERATED-CODE//
os.unloadAPI(APLib.APLibPath)
-- //--//
