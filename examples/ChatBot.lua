
-- //AUTO-GENERATED-CODE//
local APLibPath = settings.get('APLibPath')

assert(  -- check if setup was done before, if not return with an error
    type(APLibPath) == 'string',
    "Couldn't open APLib through path: "..tostring(
        APLibPath
    ).."; probably you haven't completed Lib setup via 'LIBFILE setup' or the setup failed"
)

assert( -- check if API is still there, if not return with an error
    fs.exists(APLibPath),
    "Couldn't open APLib through path: "..tostring(
    	APLibPath
    ).."; remember that if you move the API's folder you must set it up again via 'LIBFILE setup'"
)

os.loadAPI(APLibPath) -- load API with CraftOS's built-in feature

local APLib = APLibPath:reverse():sub(1, APLibPath:reverse():find('/') - 1):reverse()
if APLib:sub(#APLib - 3) == '.lua' then APLib = APLib:sub(1, #APLib - 4); end
local APLib = _ENV[APLib]
-- //--//

-- PARAMS

-- BASIC

local chat
local defaultPrefix = '!'
local botName = 'bot'

-- ADVANCED

local chatEvent = 'chat'
local prefix = APLib.OSSettings.get('ChatBotPrefix')

-- SEEKING FOR CHATBOX

for key, value in pairs(peripheral.getNames()) do
    if peripheral.getType(value) == 'chatBox' then
        chat = peripheral.wrap(value)
        break
    end
end

assert(chat, "Couldn't find any chatBox.")

-- SEEKING FOR PREFIX

if not prefix then
    prefix = defaultPrefix
    APLib.OSSettings.set('ChatBotPrefix', defaultPrefix)
end

-- MEMO

local meConsole = APLib.Memo.new(2, 4, 50, 16, nil, nil, colors.gray)
meConsole:editable(true)
meConsole:limits(false)

-- FUNCTIONS

local function reply(user, str)
    chat.say(user..': '..str)
end

local function print(string)
    meConsole:setCursorPos(1, #meConsole.lines)
    meConsole:print(string)
    meConsole:setCursorPos(1, #meConsole.lines - 1)
    meConsole:draw()
end

-- HEADER

local hTitle = APLib.Header.new(2, 'ChatBot powered by APLib '..APLib.ver)

-- LABEL

local lCredits = APLib.Label.new(2, 18, '& PeripheralsPlusOne')

-- BUTTON

local bQuit = APLib.Button.new(45, 18, 50, 18, 'Quit', nil, nil, colors.green, colors.red)

-- CALLBACKS

-- BUTTON CALLBACKS

bQuit:setCallback(
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

-- LOOP CALLBACKS

APLib.setLoopCallback(
    APLib.event.loop.onInit,
    function ()
        print("Current prefix is '"..prefix.."'")
        print()
    end
)

APLib.setLoopCallback(
    APLib.event.loop.onEvent,
    function (event)
        if event[1] == chatEvent then

            local user, message = event[2], event[3]
            sleep(0.5)

            message = message:lower()

            if (message:sub(1, #botName) == botName) or (message:sub(1, #prefix) == prefix) then

                if message:sub(1, #botName) == botName then
                    message = message:sub(#botName + 1)
                else
                    message = message:sub(#prefix + 1)
                end

                if message:sub(1, 1) == ' ' then message = message:sub(2); end

                local words = APLib.stringSplit(message, ' ')

                local command = table.remove(words, 1)
                print('Command sent: '..command)
                print('Command sent by '..user)
                local args = words
                print('Args used:')
                print(textutils.serialize(args))
                print()

                if command == 'prefix' then
                    if args[1] then
                        APLib.OSSettings.set('ChatBotPrefix', args[1])
                        prefix = APLib.OSSettings.get('ChatBotPrefix')

                        reply(user, "Prefix was succesfully changed to '"..prefix.."'")
                    else
                        reply(user, "Current prefix is '"..prefix.."'")
                    end

                elseif command == 'reboot' then
                    reply(user, 'Rebooting in 3 secs!')
                    sleep(3)
                    os.reboot()

                elseif command == 'shutdown' then
                    reply(user, 'Shutting down in 3 secs!')
                    sleep(3)
                    os.shutdown()
                else
                    reply(user, "'"..command.."' isn't a valid command!")
                end

            end

        
        elseif event[1] == 'mouse_scroll' then
            meConsole:setCursorPos(1, meConsole.cursor.pos.line + event[2])
        end
    end
)

-- PROGRAM

APLib.drawOnLoopEvent()

APLib.addLoopGroup('main', {hTitle, meConsole, lCredits, bQuit})
APLib.setLoopGroup('main')

APLib.loop()

APLib.bClear()
