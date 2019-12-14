
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

-- WINDOW STUFF
-- Create window
local window = APLib.Window.new(2, 2, 12 ,12, {color=colors.lightGray})
-- Create button inside the window that hides it
local wbMinimize = APLib.Button.new(11, 1, 11, 1, {text='_', pressedButtonColor=colors.green, notPressedButtonColor=colors.red})
-- Create button to reopen the window when it's hidden
local bReopen = APLib.Button.new(1, 19, 10, 19, {text='WINDOW', pressedButtonColor=colors.green, notPressedButtonColor=colors.red})
bReopen.state = true -- Set the button state to true

-- Set as objects inside the window a rectangle and the button that hides it
window:set({wbMinimize, APLib.Rectangle.new(1, 1, 11, 1, {color=colors.blue})}, true)

-- Set callback to the button inside the window
wbMinimize:setCallback(
    APLib.event.button.onPress,
    function (self, event)
        -- Set the other button state to being the opposite of this one
        bReopen.state = not self.state
        -- Draw the button on the buffer and draw the buffer (This is done to make the user see the button change color and state)
        self:draw()
        APLib.globalMonitorBuffer.draw()
        sleep(0.1)
        -- Hide the parent window
        self.parent:hide(self.state)
    end
)

-- Set callback to the button that reopens the window
bReopen:setCallback(
    APLib.event.button.onPress,
    function (self, event)
        -- Set the other button state to being the opposite of this one
        wbMinimize.state = not self.state
        -- Hide the window based on this button's state
        window:hide(not self.state)
    end
)

-- CREATING BUTTON TO CLOSE APP

-- Create button to quit the app
local bQuit = APLib.Button.new(51, 19, 51, 19, {text='X', pressedButtonColor=colors.green, notPressedButtonColor=colors.red})

-- Set its callback
bQuit:setCallback(
    APLib.event.button.onPress,
    function (self, event)
        -- The same thing of wbMinimize
        self:draw()
        APLib.globalMonitorBuffer.draw()
        sleep(0.1)
        -- Stop loop
        APLib.stopLoop()
    end
)

-- SETTING UP THE LIBRARY

-- Sets the renderer to use the buffer and sets background to gray
APLib.setRenderer(APLib.renderEngine.experimental)
APLib.setBackground(colors.gray)

-- Adds a group of objects that is going to be called 'main' and sets it to the current group of objects that are looped by the library
APLib.addLoopGroup('main', {window, bReopen, bQuit})
APLib.setLoopGroup('main')

-- Sets the clock speed to 0.1s and runs the loop (objects by default are drawn on clock)
APLib.setLoopClockSpeed(0.1)
APLib.loop()

-- Set the background to black and draw the monitor buffer before quitting
APLib.setBackground(colors.black)
APLib.globalMonitorBuffer.draw()

-- //AUTO-GENERATED-CODE//
os.unloadAPI(APLib.APLibPath)
-- //--//