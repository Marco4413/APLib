
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



-- create a button with blue text color and 'transparent' background text color
-- that says 'Button' from x = 1, y = 1, to x = 10, y = 5
-- When it's on a true state it will be green and when on a false state red
local button = APLib.Button.new(1, 1, 10, 5, 'Button', colors.blue, nil, colors.green, colors.red)

-- creating onPress button callback
button:setCallback(
	APLib.event.button.onPress,
    function (self, event)
        -- if when the button was pressed its state was changed to true then
        if self.state then
            local _colors = {colors.blue, colors.yellow, colors.white}
            -- pick a random color from _colors array and change button's text color to it
            self.colors.textColor = _colors[math.random(#_colors)]
            self:draw()
            -- switching button's state to its false one after .5 seconds
            sleep(0.5)
            self.state = false
        end
    end
)

-- Adding loop group 'Main' and putting the button in it
APLib.addLoopGroup('Main', {button})
-- Setting 'Main' as the current loop group
APLib.setLoopGroup('Main')

-- This time i'm keeping the default clock and timer's speeds

-- Drawing on loop event
APLib.drawOnLoopEvent()

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
            -- making the button move depending on which arrow key was pressed
            if event[2] == 200 then -- UP_ARROW_KEY
                button.pos.y1 = button.pos.y1 - 1 -- making the button go up by 1 pixel
                button.pos.y2 = button.pos.y2 - 1
            elseif event[2] == 208 then -- DOWN_ARROW_KEY
                button.pos.y1 = button.pos.y1 + 1 -- making the button go down by 1 pixel
                button.pos.y2 = button.pos.y2 + 1
            elseif event[2] == 205 then -- RIGHT_ARROW_KEY
                button.pos.x1 = button.pos.x1 + 1 -- making the button go right by 1 pixel
                button.pos.x2 = button.pos.x2 + 1
            elseif event[2] == 203 then -- LEFT_ARROW_KEY
                button.pos.x1 = button.pos.x1 - 1 -- making the button go left by 1 pixel
                button.pos.x2 = button.pos.x2 - 1
            -- if another key was pressed then stop loop
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
