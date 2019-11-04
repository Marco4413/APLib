
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
        else
        	self.colors.textColor = colors.red
        end
    end
)

-- if you're scared of this part, don't worry it will get simplified drastically in the chapter
-- after the next one

while true do
    local event = {os.pullEvent()} -- here we pull an event from the computer
    -- we check if the event was a mouse_click, if it was we update the object
    if event[1] == 'mouse_click' then
        local x, y = event[3], event[4]
        header:update(x, y, event)
    -- else if a key was pressed then we hide/unhide the object
    elseif event[1] == 'key' then
        header:hide(not header.hidden)
    end
	APLib.bClear() -- clears the monitor
    -- at the end of all we draw it
    header:draw()
end
