
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

-- PARAMS

local wallDistance = 2
local treeHeight = 6 -- OAK TREE HEIGHT
local saplingID = 'minecraft:sapling' -- SAPLING ID
local logID = 'minecraft:log' -- OAK BLOCK ID
local refuelSlot = 1
local saplingSlot = 2
local dropSlots = {5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16}

turtle.select(dropSlots[1])

-- MEMO

local meConsole = APLib.Memo.new(2, 8, 38, 12, nil, nil, colors.gray)
meConsole:editable(false)
meConsole:limits(false)

-- FUNCTIONS

local function print(string)
    meConsole:setCursorPos(1, #meConsole.lines)
    meConsole:print(string)
    meConsole:setCursorPos(1, #meConsole.lines - 1)
    meConsole:draw()
end

local function invertFacing(facing)
    if facing == 'north' then
        facing = 'south'
    elseif facing == 'south' then
        facing = 'north'
    elseif facing == 'east' then
        facing = 'west'
    elseif facing == 'west' then
        facing = 'east'
    end

    return facing
end

local function refuel()
    if not (turtle.getFuelLevel() > 0) then
        local lastSlot = turtle.getSelectedSlot()
        local fuelCount = turtle.getItemCount()

        if fuelCount > 1 then
            turtle.select(refuelSlot)
            if not turtle.refuel(fuelCount - 1) then
                print('Fuel Level: '..tostring(turtle.getFuelLevel()))
                write('Waiting for fuel... ')
                read()
                print()
                refuel()
            end
        end

        turtle.select(lastSlot)
    end
end

local function dropDownAll()
    local lastSlot = turtle.getSelectedSlot()
    print('Dropping all items in dropSlots...')
    
    for key, value in pairs(dropSlots) do
        turtle.select(value)
        turtle.dropDown()
    end

    turtle.select(lastSlot)
    print('Item dropping ended!')
end

local function treeCapitate()

    local currHeight = 0
    print('Harvesting tree...')

    for i=1, treeHeight do
        turtle.dig()
        if turtle.detectUp() then
            turtle.digUp()
        end

        refuel()
        turtle.up()
        
        currHeight = i

        local blockInspect = {turtle.inspect()}
        if blockInspect[1] then
            if not (blockInspect[2].name == logID) then
                print('Tree harvest stopped at '..currHeight)
                print('  blocks from the ground!')
                break
            end
        else
            break
        end
    end

    print('Going back down...')
    for i=1, currHeight do
        if turtle.detectDown() then
            turtle.digDown()
        end

        refuel()
        turtle.down()
    end

    print('Tree harvest ended!')
end

local function treeStock()
    local lastSlot = turtle.getSelectedSlot()
    local saplingSlotDetail = turtle.getItemDetail(saplingSlot)

    if not (saplingSlotDetail.count > 1) then
        local saplingFound = false

        -- // 1 //
        print('Searching for saplings in inventory...')
        for key, value in pairs(dropSlots) do
            local valueDetail = turtle.getItemDetail(value)
            if valueDetail then
                if valueDetail.name == saplingID then
                    turtle.select(value)
                    turtle.transferTo(saplingSlot)
                    saplingFound = true
                end
            end
        end

        if saplingFound then
            turtle.select(lastSlot)
            refuel()
            turtle.forward()
            print('Sapling found!')
            return
        end

        -- // 2 //
        for i=1, wallDistance - 1 do
            refuel()
            turtle.back()
        end

        local chest = peripheral.wrap('back')

        while true do
            print('Searching for saplings in chest...')

            for i=1, chest.size() do
                local item = chest.getItem(i)
                if item then
                    local itemMeta = item.getMetadata()
                    if itemMeta.name == saplingID then
                        local chestMeta = chest.getMetadata()
                        local invertedChestFacing = invertFacing(chestMeta.state.facing)
                        chest.pushItems(invertedChestFacing, i)
                        saplingFound = true
                    end
                end
            end


            if saplingFound then
                turtle.select(lastSlot)
                refuel()
                turtle.forward()
                print('Sapling found!')
                return
            end
        end

    end
end

local function treePlant()
    local lastSlot = turtle.getSelectedSlot()
    print('Replanting tree...')

    treeStock()
    turtle.select(saplingSlot)
    if turtle.place() then
        print('Tree Planted!')
    else
        print('Tree not Planted...')
    end

    turtle.select(lastSlot)
end


-- HEADERS

local hMain = APLib.Header.new(1, 'Main Menu')
local hTask = APLib.Header.new(3, 'Task Bar')

-- BUTTONS

local bAutoFarm = APLib.Button.new(34, 1, 39, 1, 'Auto', nil, nil, colors.green, colors.red)

local bActions = APLib.Button.new(1, 1, 9, 1, 'Actions', nil, nil, colors.lightGray, colors.gray)

local mbHarvest = APLib.Button.new(0, 0, 0, 0, 'Harvest', nil, nil, colors.blue, colors.green)

local mbPlant = APLib.Button.new(0, 0, 0, 0, 'Plant', nil, nil, colors.blue, colors.green)

local mbDropAll = APLib.Button.new(0, 0, 0, 0, 'DropAll', nil, nil, colors.blue, colors.green)

local mbQuit = APLib.Button.new(0, 0, 0, 0, 'Quit', nil, nil, colors.green, colors.red)

-- MENUS

local mActions = APLib.Menu.new(1, 2, 9, 5, colors.lightGray)
mActions:set({mbHarvest, mbPlant, mbDropAll, mbQuit}, true)

-- PERCENTAGEBAR

local pbState = APLib.PercentageBar.new(4, 4, 36, 6, 0, 0, 4, true, nil, nil, colors.green, colors.black)

-- CALLBACKS

local function lockButtons(blacklist)
    local mb = {mbHarvest, mbPlant, mbDropAll}

    for key, value in pairs(mb) do
        if value ~= blacklist then
            value.colors.notPressedButtonColor = colors.red
            value:draw()
        end
    end
end

local function unlockButtons(blacklist)
    local mb = {mbHarvest, mbPlant, mbDropAll}

    for key, value in pairs(mb) do
        if value ~= blacklist then
            value.colors.notPressedButtonColor = colors.green
            value:draw()
        end
    end
end

bAutoFarm:setCallback(
    APLib.event.button.onPress,
    function (self, event)
        if self.state then
            mActions:hide(self.state)
        else
            mActions:hide(not bActions.state)
        end
        bActions:hide(self.state)
    end
)

bActions:setCallback(
    APLib.event.button.onPress,
    function (self, event)
        mActions:hide(not self.state)
    end
)

mbHarvest:setCallback(
    APLib.event.button.onPress,
    function (self, event)
        lockButtons(self)
        self:draw()
        treeCapitate()
        self.state = not self.state
        unlockButtons(self)
    end
)

mbPlant:setCallback(
    APLib.event.button.onPress,
    function (self, event)
        lockButtons(self)
        self:draw()
        treePlant()
        self.state = not self.state
        unlockButtons(self)
    end
)

mbDropAll:setCallback(
    APLib.event.button.onPress,
    function (self, event)
        lockButtons(self)
        self:draw()
        dropDownAll()
        self.state = not self.state
        unlockButtons(self)
    end
)

mbQuit:setCallback(
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

APLib.drawOnLoopEvent()

APLib.addLoopGroup('main', {mActions, hMain, hTask, bAutoFarm, bActions, pbState, meConsole})
APLib.setLoopGroup('main')

APLib.setLoopCallback(
    APLib.event.loop.onClock,
    function (event)

        if bAutoFarm.state then
            local blockInspect = {turtle.inspect()}
            if blockInspect[1] then
                if blockInspect[2].name == logID then
                    pbState:setValue(1)
                    pbState:draw()

                    treeCapitate()

                    pbState:setValue(2)
                    pbState:draw()

                    dropDownAll()

                    pbState:setValue(3)
                    pbState:draw()

                    treePlant()

                    pbState:setValue(4)
                    pbState:draw()

                    dropDownAll()

                    pbState:setValue(0)
                    pbState:draw()
                end
            end
        end
    end
)

APLib.loop()

APLib.bClear()
