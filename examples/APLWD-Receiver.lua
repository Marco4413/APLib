
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
APLibPath = nil
-- //--//

APLib.bClear()

tArgs = { ... }
if tArgs[1] == '/help' then
    print('Args:\nmodemName, senderName [, monitor1, monitor2, ...]')
    return
end

APLib.APLWD.enable(true)
APLib.APLWD.connect(tArgs[1], tArgs[2])

if tArgs[3] == 'multi' then
    table.remove(tArgs, 1)
    table.remove(tArgs, 1)
    table.remove(tArgs, 1)
    APLib.setMonitorGroup(tArgs)
    APLib.setMonitorGroupEnabled(true)
elseif tArgs[3] then
    APLib.setMonitor(tArgs[3])
end

while true do

    if APLib.APLWD.receiveCache() == 'disconnected' then
        break
    elseif #APLib.APLWD.cache == 0 then
        break
    end

    APLib.bClearMonitorGroup()
    APLib.APLWD.drawCache()

end

APLib.setBackgroundMonitorGroup(colors.black)
APLib.bClearMonitorGroup()
