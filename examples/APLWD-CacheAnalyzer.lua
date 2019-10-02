
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
    print('Args: modemName, senderName [, receiveTimeout]')
    return
end

APLib.APLWD.enable(true)
APLib.APLWD.connect(tArgs[1], tArgs[2])

tArgs[3] = tonumber(tArgs[3])
if not tArgs[3] then
    tArgs[3] =  10
end



while true do

    print('Press any key to Receive & Analyze')
    print(' or press Backspace to exit.')
    print()
    event = {os.pullEvent('key')}

    if event[2] == 14 then
        APLib.APLWD.close()
        break
    end
    
    local received, state = APLib.APLWD.receiveCache(tArgs[3])
    if not received then
        if APLib.APLWD.enabled then
            APLib.APLWD.close()
            print("Didn't get any message in "..tostring(tArgs[3])..' Seconds')
        else
            print('The other user disconnected')
        end
        break
    end

    local Texts = 0
    local Points = 0
    local BackgroundChanges = 0

    for key, value in pairs(APLib.APLWD.cache) do
        if value.type == 'text' then
            Texts = Texts + 1
        elseif value.type == 'point' then
            Points = Points + 1
        elseif value.type == 'background' then
            BackgroundChanges = BackgroundChanges + 1
        end
    end

    print('Collected data:')
    print('  Texts received: '..tostring(Texts))
    print('  Points received: '..tostring(Points))
    print('  BackgroundChanges received: '..tostring(BackgroundChanges))
    print()

end

APLib.setBackground(colors.black)
APLib.bClear()
