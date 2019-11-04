
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



-- create a label with red text color and blue background text color that says 'ClockDraw'
-- at x = 1, y = 1
local label = APLib.Label.new(1, 1, 'ClockDraw', colors.red, colors.blue)

-- creating onPress label callback
label:setCallback(
	APLib.event.label.onPress,
    function (self, event)
        -- here we switch the color from red to white and vice-versa every time the label is pressed
        if self.colors.textColor == colors.red then
            self.colors.textColor = colors.white
            -- making the user know what's the current loop draw mode
            self.text = 'EventDraw'
            -- switching between the 2 draw modes (difference should now be noticeable with what
        	-- we're working with)
            APLib.drawOnLoopEvent()
        else
        	self.colors.textColor = colors.red
            -- making the user know what's the current loop draw mode
            self.text = 'ClockDraw'
            -- switching between the 2 draw modes (difference should now be noticeable with what
        	-- we're working with)
            APLib.drawOnLoopClock()
        end
    end
)

-- Adding loop group 'Main' and putting the Label in it
APLib.addLoopGroup('Main', {label})
-- Setting 'Main' as the current loop group
APLib.setLoopGroup('Main')


-- Setting loop clock speed very slow to show the difference between the two modes
APLib.setLoopClockSpeed(3)
-- Setting loop timer speed very fast to show the difference between the two modes
APLib.setLoopTimerSpeed(0.1)

-- I'm lazy so i don't want to clear the screen by myself
APLib.loopAutoClear(true)

-- Adding loop callback onInit and onEvent
APLib.setLoopCallback(
	APLib.event.loop.onInit,
    function ()
        print('Starting loop in 1 sec!')
        sleep(1)
        APLib.bClear()
    end
)

APLib.setLoopCallback(
	APLib.event.loop.onEvent,
    function (event)
        if event[1] == 'key' then
            -- making the label move depending on which arrow key was pressed
            if event[2] == 200 then -- UP_ARROW_KEY
                label.pos.y = label.pos.y - 1 -- making the label go up by 1 pixel
            elseif event[2] == 208 then -- DOWN_ARROW_KEY
                label.pos.y = label.pos.y + 1 -- making the label go down by 1 pixel
            elseif event[2] == 205 then -- RIGHT_ARROW_KEY
                label.pos.x = label.pos.x + 1 -- making the label go right by 1 pixel
            elseif event[2] == 203 then -- LEFT_ARROW_KEY
                label.pos.x = label.pos.x - 1 -- making the label go left by 1 pixel
            -- if another button was pressed then stop loop
            else
        		APLib.stopLoop()
            end
    	end
    end
)

-- Starting the loop
APLib.loop()
-- If loop ends then reset loop groups
APLib.resetLoopSettings()
-- Clearing screen
APLib.bClear()
