
-- //AUTO-GENERATED-CODE//
assert(  -- check if setup was done before, if not return with an error
    type(settings.get('APLibPath')) == 'string',
    "Couldn't open APLib through path: "..tostring(
        settings.get('APLibPath')
    ).."; probably you haven't completed Lib setup via 'LIBFILE setup' or the setup failed"
)

assert( -- check if API is still there, if not return with an error
    fs.exists(settings.get('APLibPath')),
    "Couldn't open APLib through path: "..tostring(
    	settings.get('APLibPath')
    ).."; remember that if you move the API's folder you must set it up again via 'LIBFILE setup'"
)

os.loadAPI(settings.get('APLibPath')) -- load API with CraftOS's built-in feature
-- //--//

APLib.bClear()

tArgs = { ... }
if tArgs[1] == '/help' then
    print('Args: modemName, senderName [, monitorName]')
    return
end

APLib.APLWD.enable(true)
APLib.APLWD.connect(tArgs[1], tArgs[2])

if tArgs[3] then
    APLib.setMonitor(tArgs[3])
end

while true do

    if APLib.APLWD.receiveCache() == 'disconnected' then
        break
    end

    APLib.APLWD.drawCache()

end

APLib.setBackground(colors.black)
APLib.bClear()
