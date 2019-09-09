
assert(  -- check if setup was done before, if not return with an error
    type(settings.get('APLibPath')) == 'string',
    "Couldn't open APLib through path: "..tostring(
        settings.get('APLibPath')
    )..";\n probably you haven't completed Lib setup\n via 'LIBFILE setup' or the setup failed"
)

assert( -- check if API is still there, if not return with an error
	fs.exists(settings.get('APLibPath')),
    "Couldn't open APLib through path: "..tostring(
    	settings.get('APLibPath')
    )..";\n remember that if you move the API's folder\n you must set it up again via 'LIBFILE setup'"
)
 
os.loadAPI(settings.get('APLibPath')) -- load API with CraftOS's built-in feature



-- create an header with red text color and blue background text color that says 'This is an header'
-- at y = 2
local header = APLib.Header.new(2, 'This is an header', colors.red, colors.blue)

-- NOTE: header:setCallback(event, callback) is the same as
-- writing header.setCallback(header, event, callback)
header:setCallback(
	APLib.event.header.onPress,
    -- self is the object itself and event is the event that was passed through update function
    function (self, event)
        -- here we switch the color from red to white and vice-versa every time the header is pressed
        if self.colors.textColor == colors.red then
            self.colors.textColor = colors.white
            -- NEW STUFF
            -- switching between the 2 draw modes (difference shouldn't be noticeable with what
        	-- we're working with)
            APLib.drawOnLoopEvent()
        else
        	self.colors.textColor = colors.red
            -- NEW STUFF
            -- switching between the 2 draw modes (difference shouldn't be noticeable with what
        	-- we're working with)
            APLib.drawOnLoopClock()
        end
    end
)

-- NEW STUFF

-- Adding loop group 'Main' and putting the Header in it
APLib.addLoopGroup('Main', {header})
-- Setting 'Main' ad the current loop group
APLib.setLoopGroup('Main')


-- Setting loop clock speed very slow to show the difference between the two modes
APLib.setLoopClockSpeed(3)
-- Setting loop timer speed very fast to show the difference between the two modes
APLib.setLoopTimerSpeed(0.1) -- this is overkill on this app btw

-- I'm lazy so i don't want to clear the screen by myself
APLib.loopAutoClear(true)

-- Adding loop callback onInit and onEvent
APLib.setLoopCallback(
	APLib.event.loop.onInit,
    function ()
        print('Starting loop in 3 sec!')
        sleep(3)
        APLib.bClear()
    end
)

APLib.setLoopCallback(
	APLib.event.loop.onEvent,
    function (event)
        if event[1] == 'key' then
        	APLib.stopLoop()
    	end
    end
)

-- Starting the loop
APLib.loop()
-- If loop ends then reset loop groups
APLib.resetLoopSettings()
-- Clearing screen
APLib.bClear()
