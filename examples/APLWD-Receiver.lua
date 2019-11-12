
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

table.remove(tArgs, 1)
table.remove(tArgs, 1)

local hasMultiOption, multiOptionKey = APLib.tableHasValue(tArgs, 'multi')
local hasRenderEngineOption, renderEngineOptionKey = APLib.tableHasValue(tArgs, 'renderer')

if hasMultiOption then

    local monitors = {}

    if hasRenderEngineOption then
        if multiOptionKey < renderEngineOptionKey then
            for key=multiOptionKey + 1, renderEngineOptionKey - 1 do
                table.insert(monitors, tArgs[key])
            end
        else
            for key=multiOptionKey + 1, #tArgs do
                table.insert(monitors, tArgs[key])
            end
        end

        local renderEngine = tArgs[renderEngineOptionKey + 1]
        if tArgs[renderEngineOptionKey + 1] then
            if renderEngine == 'experimental' then
                APLib.setRenderer(APLib.renderEngine.experimental)
            end
        end
    else
        table.remove(tArgs, 1)
        monitors = tArgs
    end

    APLib.setMonitorGroup(monitors)
    APLib.setMonitorGroupEnabled(true)
else
    if hasRenderEngineOption then
        if renderEngineOptionKey > 1 then
            APLib.setMonitor(tArgs[1])
            local renderEngine = tArgs[renderEngineOptionKey + 1]
            if tArgs[renderEngineOptionKey + 1] then
                if renderEngine == 'experimental' then
                    APLib.setRenderer(APLib.renderEngine.experimental)
                end
            end
        else
            local renderEngine = tArgs[renderEngineOptionKey + 1]
            if tArgs[renderEngineOptionKey + 1] then
                if renderEngine == 'experimental' then
                    APLib.setRenderer(APLib.renderEngine.experimental)
                end
            end
            if tArgs[renderEngineOptionKey + 2] then
                APLib.setMonitor(tArgs[renderEngineOptionKey + 2])
            end
        end
    else
        if tArgs[1] then
            APLib.setMonitor(tArgs[1])
        end
    end
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

APLib.setRenderer(APLib.renderEngine.classic)

APLib.setBackgroundMonitorGroup(colors.black)
APLib.bClearMonitorGroup()
