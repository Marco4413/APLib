
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

    term.setTextColor(colors.red)
    print('Press any key to Receive & Analyze')
    print(' or press Backspace to exit.')
    print()
    local event = {os.pullEventRaw('key')}

    if event[2] == 14 then
        APLib.APLWD.close()
        break
    end
    
    local received, state = APLib.APLWD.receiveCache(tArgs[3])
    if not received then
        if APLib.APLWD.enabled then
            APLib.APLWD.close()
            term.setTextColor(colors.red)
            print("Didn't get any message in "..tostring(tArgs[3])..' Seconds')
        else
            term.setTextColor(colors.red)
            print('The other user disconnected')
        end
        break
    end

    local bClears = {}
    local Backgrounds = {}
    local Texts = {}
    local Points = {}
    local Rectangles = {}

    for key, value in pairs(APLib.APLWD.cache) do
        if value.type == 'bClear' then
            table.insert(bClears, value)
        elseif value.type == 'background' then
            table.insert(Backgrounds, value)
        elseif value.type == 'text' then
            table.insert(Texts, value)
        elseif value.type == 'point' then
            table.insert(Points, value)
        elseif value.type == 'rectangle' then
            table.insert(Rectangles, value)
        end
    end

    term.setTextColor(colors.yellow)
    print('Collected data:')
    term.setTextColor(colors.green)
    print('  b[C]lears received: '..tostring(#bClears))
    print('  [B]ackgrounds received: '..tostring(#Backgrounds))
    print('  [T]exts received: '..tostring(#Texts))
    print('  [P]oints received: '..tostring(#Points))
    print('  [R]ectangles received: '..tostring(#Rectangles))
    term.setTextColor(colors.red)
    print('\nPress ENTER to save data to APLWDCA.log')
    print(' or press any other key to continue.\n')

    event = {os.pullEventRaw('key')}

    term.setTextColor(colors.green)
    if event[2] == 46 then -- 'C'
        print('bClears:\n'..textutils.serialize(bClears)..'\n')
    elseif event[2] == 48 then -- 'B'
        print('Backgrounds:\n'..textutils.serialize(Backgrounds)..'\n')
    elseif event[2] == 20 then -- 'T'
        print('Texts:\n'..textutils.serialize(Texts)..'\n')
    elseif event[2] == 25 then -- 'P'
        print('Points:\n'..textutils.serialize(Points)..'\n')
    elseif event[2] == 19 then -- 'R'
        print('Rectangles:\n'..textutils.serialize(Rectangles)..'\n')
    elseif event[2] == 28 then -- ENTER
        print('Saving data...')
        local File = fs.open('APLWDCA.log', 'w')
        File.write(textutils.serialize(
            {
                bClears = bClears,
                Backgrounds = Backgrounds,
                Texts = Texts,
                Points = Points,
                Rectangles = Rectangles
            }
        ))
        File.close()
        term.setTextColor(colors.yellow)
        print('Data saved!\n')
    end
end

APLib.setBackground(colors.black)
APLib.bClear()
