-- ********************************************
--
--        Hub Level
--
-- ********************************************

BoxLocations = require("box_locations")
SentLocations = require("sent_locations")
CommandsMain = require("commands_main")
ReceivedLocations = require("received_locations")

--will get called when the game starts
function OnGameStart()
	CommandsMain.MainSetup()
    IncreaseStartingGold()
    Startup()
    LevelStatus()
    ItemStatus()

end

function OnGameLoad()
      QuickMessage("Game loaded.", "ARCHIPELAGO_ICON")
      CommandsMain.MainSetup()
end

function Startup()
    ConcealMapRect(PLAYER0, 187, 328, 24, 24)
    RevealMapRect(PLAYER0,34,100,3,3)
    ZoomToLocation(PLAYER0, 50)
    RunDKScriptCommand("COMPUTER_PLAYER(PLAYER6,ROAMING)")
    RunDKScriptCommand("ALLY_PLAYERS(PLAYER0, PLAYER6, 3)")
    RunDKScriptCommand("SET_GAME_RULE(AlliesShareVision,1)")
    PLAYER6.colour = "RED"
    Game.FlatAPBox = {}
    RegisterTimerEvent(function ()
        QuickInformation(99,"Welcome to KeeperAP!\nWoo!")
        QuickObjective("Welcome to KeeperAP!\nWoo!")
    end, 20, false)
end

function SlabToCentreSubtile(slab_coord)
    local centresubtile_coord = 3*slab_coord+1
    return centresubtile_coord
end

function SubtileToSlab(subtile_coord)
    local slab_coord = math.floor(subtile_coord/3)
    return slab_coord
end

function FlattenBoxes() --because specboxes have a limit of 256 we just make a link between the location number and a number from 1+ so we can display them all on one map
    local FlatBoxNumbers = {}
    local number = 1
    local level_ids = {}

    for level_id, location_ids in pairs(BoxLocations) do
        if type(level_id) == "number" then
            table.insert(level_ids, level_id)
        end
    end
    table.sort(level_ids, function(a, b)
        return a < b
    end)

    for _, level_id in ipairs(level_ids) do
        for _, box in ipairs(BoxLocations[level_id]) do
            FlatBoxNumbers[box] = number
            number = number + 1
        end
    end
    --print_r(FlatBoxNumbers)
    return FlatBoxNumbers
end

function LevelStatus()
    local FlatBoxNumbers = FlattenBoxes()
    for level=1,26 do
        local level_subtile_x = 88 + 18*(((level-1) % 10) + 1)
        local level_subtile_y = 34 + 15*math.floor((level-1) / 10)
        --if level not unlocked...
        --starting at subtile 88, 34: for 1 to 10, add 18 to x coord (so 1 is 106,34, 2 is 124,34 etc)
        --starting at subtile 88, 49: for 11 to 20, add 18 to x coord
        --starting at subtile 124, 64: for 21 to 26, add 18 to x coord
        local nudge_amount
        local level_actual
        if level <= 20 then
            nudge_amount = 0
            level_actual = level
        else
            nudge_amount = 36
            level_actual = level + 79
        end
        RevealMapRect(PLAYER0, level_subtile_x + nudge_amount, level_subtile_y + 3, 21, 16)
        if not ReceivedLocationsTable.Has(level + 500) then
            AddObjectToLevelAtPos("SPINNING_KEY_DUMMY", level_subtile_x + nudge_amount, level_subtile_y, 0)
            --add tooltip "Level level locked"
        elseif SentLocations.Has(level + 10000) then
            AddObjectToLevelAtPos("HEARTFLAME_RED", level_subtile_x + nudge_amount, level_subtile_y, 0)
            --add tooltip "Level level completed"
        else
            AddObjectToLevelAtPos("BANNER", level_subtile_x + nudge_amount, level_subtile_y, 0,PLAYER0,1024)
        end
        local mapBoxIDs = BoxLocations[level_actual]
        for location=1, 15 do
            local box_subtile_x = level_subtile_x + nudge_amount - 6 + 3*((location - 1) % 5)
            local box_subtile_y = level_subtile_y + 3 + 3*math.floor((location - 1) / 5)
            if location <= #mapBoxIDs then
            	local boxID = mapBoxIDs[location]
                local flatBoxID = FlatBoxNumbers[boxID]
                if ReceivedLocationsTable.Has(level + 500) then
                    ChangeSlabType(SubtileToSlab(box_subtile_x), SubtileToSlab(box_subtile_y), "PRETTY_PATH", "NONE")
                    ChangeSlabOwner(SubtileToSlab(box_subtile_x), SubtileToSlab(box_subtile_y), PLAYER6)
                    Game.FlatAPBox[flatBoxID] = AddObjectToLevelAtPos("SPECBOX_CUSTOM", box_subtile_x, box_subtile_y, flatBoxID)
                    --SetBoxTooltip(flatBoxID, "Box " .. flatBoxID .. " for location " .. boxID)
                    --check if we got it. If so, update its tooltip and sprite to match what it unlocked. Also make it unclickable.
					if SentLocations.Has(boxID) then
                        local info = GetAPLocationInfo(boxID) -- this never works, do you lose the info when a locations is sent?
                        --do we need to write all of the info info to a lua table and read it later?
                        if info == nil then
                            --QuickMessage("Could not get location info for box " .. boxID, "ARCHIPELAGO_ICON")
                            print("Could not call GetAPLocationInfo on box " .. boxID)
                            SetBoxTooltip(flatBoxID, "Box found!")
                        else
                            SetBoxTooltip(flatBoxID, info.itemName .. " for " .. info.playerName)
                            if (info.flags % 2) ~= 0 then
                                Game.FlatAPBox[flatBoxID].anim_sprite = "ARCHIPELAGOITEMUSEFUL"
                            end
                        end
                    else
                    	SetBoxTooltip(flatBoxID, "Box not found!")
                        Game.FlatAPBox[flatBoxID].anim_sprite = "ARCHIPELAGOITEMOFF"
                    end
                else
                    ChangeSlabType(SubtileToSlab(box_subtile_x), SubtileToSlab(box_subtile_y), "HARD_FLOOR", "NONE")
                end
            end
        end
    end
end

--for other stuff:
--look at ChecksTable, place the thing

--creatures: 85,88 + 12*creature id
--AddCreatureToLevel("PLAYER0", creatureModel, portalNumber, 1, 0, "DEFAULT")


--ChecksTable, 

function ItemStatus()
    --Creatures
    for itemid=1, 100 do
        if ChecksTable[itemid] then
            local item_subtile_x = 85 + 12*(itemid)
            local item_subtile_y = 88
            if itemid > 16  then
                item_subtile_x = 169 + 12*(itemid)
                item_subtile_y = 112
            end
            local item_pos = {stl_x = item_subtile_x, stl_y = item_subtile_y}
            RunDKScriptCommand("SET_CREATURE_CONFIGURATION(" .. ChecksTable[itemid].internal_name .. ",HungerRate,0)")
            AddCreatureToLevel("PLAYER6",ChecksTable[itemid].internal_name,item_pos,1,0,"INITIALIZE")
            if ReceivedLocationsTable.Has(itemid) then
                AddObjectToLevelAtPos("HEARTFLAME_RED", item_subtile_x, item_subtile_y+6, 0)
                AddObjectToLevelAtPos("HEARTFLAME_BLUE", item_subtile_x, item_subtile_y+12, 0)
            end
            --be needlessly extra and replace prison with that creature sleeping or something idk
        end
    end
    --Rooms
    for itemid=101, 200 do
        if ChecksTable[itemid] then
            local item_subtile_x = 97 + 12*(itemid % 100)
            local item_subtile_y = 142
            --ChangeSlabType(SubtileToSlab(item_subtile_x), SubtileToSlab(item_subtile_y), ChecksTable[itemid].internal_name, "NONE") --terrain and rooms are different. Just place them on the map.
            if ReceivedLocationsTable.Has(itemid) then
                AddObjectToLevelAtPos("HEARTFLAME_RED", item_subtile_x, item_subtile_y+6, 0)
                AddObjectToLevelAtPos("HEARTFLAME_BLUE", item_subtile_x, item_subtile_y+12, 0)
            end
        end
    end
    --Traps
    --for itemid=101, 200 do
    --    if ChecksTable[itemid] then
    --        local item_subtile_x = 97 + 12*(itemid % 100)
    --        local item_subtile_y = 142
    --        --ChangeSlabType(SubtileToSlab(item_subtile_x), SubtileToSlab(item_subtile_y), ChecksTable[itemid].internal_name, "NONE") --terrain and rooms are different. Just place them on the map.
    --        if ReceivedLocationsTable.Has(itemid) then
    --            AddObjectToLevelAtPos("HEARTFLAME_RED", item_subtile_x, item_subtile_y+6, 0)
    --            AddObjectToLevelAtPos("HEARTFLAME_BLUE", item_subtile_x, item_subtile_y+12, 0)
    --        end
    --    end
    --end
    --Doors
    --for itemid=101, 200 do
    --    if ChecksTable[itemid] then
    --        local item_subtile_x = 97 + 12*(itemid % 100)
    --        local item_subtile_y = 142
    --        --ChangeSlabType(SubtileToSlab(item_subtile_x), SubtileToSlab(item_subtile_y), ChecksTable[itemid].internal_name, "NONE") --terrain and rooms are different. Just place them on the map.
    --        if ReceivedLocationsTable.Has(itemid) then
    --            AddObjectToLevelAtPos("HEARTFLAME_RED", item_subtile_x, item_subtile_y+6, 0)
    --            AddObjectToLevelAtPos("HEARTFLAME_BLUE", item_subtile_x, item_subtile_y+12, 0)
    --        end
    --    end
    --end
    --Spells
    for itemid=401, 500 do
        if ChecksTable[itemid] then
            local item_subtile_x = 73 + 12*(itemid % 100)
            local item_subtile_y = 196
            --AddObjectToLevelAtPos("SPELLBOOK_IMP",item_subtile_x,item_subtile_y,1,"PLAYER_NEUTRAL",0)
            if ReceivedLocationsTable.Has(itemid) then
                AddObjectToLevelAtPos("HEARTFLAME_RED", item_subtile_x, item_subtile_y+6, 0)
                AddObjectToLevelAtPos("HEARTFLAME_BLUE", item_subtile_x, item_subtile_y+12, 0)
            end
        end
    end
    --501 is Levels
    --recipes
    for itemid=601, 700 do
        if ChecksTable[itemid] then
            local item_subtile_x = 34
            local item_subtile_y = 28 + 6*(itemid % 100)
            --AddObjectToLevelAtPos("SPELLBOOK_IMP",item_subtile_x,item_subtile_y,1,"PLAYER_NEUTRAL",0)
            if ReceivedLocationsTable.Has(itemid) then
                AddObjectToLevelAtPos("HEARTFLAME_RED", item_subtile_x+24, item_subtile_y, 0) --unlocked
                AddObjectToLevelAtPos("HEARTFLAME_BLUE", item_subtile_x+30, item_subtile_y, 0) --active
            end
            if SentLocations.Has(11000+(itemid % 100)) then --check this is the id we will use for having done a recipe
                AddObjectToLevelAtPos("HEARTFLAME_GREEN", item_subtile_x+36, item_subtile_y, 0) --sent
            end
        end
    end
    for itemid=701, 800 do
        if ChecksTable[itemid] then
            local item_subtile_x = 310
            local item_subtile_y = 28 + 6*(itemid % 100)
            --AddObjectToLevelAtPos("SPELLBOOK_IMP",item_subtile_x,item_subtile_y,1,"PLAYER_NEUTRAL",0)

            --once this is changed to work properly (1 item multiple times?):
            -- for each copy of that item in the received pool, for i from 1 to n, place a green potion at subtile 316 + i (first one is always green representing starting value)
                --level Cap
                --portal limit
                --start gold
                --starting imps?
                --progressive starting unlocks (i.e. if it's 1 you have bridge and SOE, 2 you have guard post and speed etc.)
                --progressive starting traps

                --would be cool to continuously spawn the effect for selling (to display values onscreen)

            --if ReceivedLocationsTable.Has(itemid) then
            --    AddObjectToLevelAtPos("HEARTFLAME_RED", item_subtile_x+24, item_subtile_y, 0) --unlocked
            --    AddObjectToLevelAtPos("HEARTFLAME_BLUE", item_subtile_x+30, item_subtile_y, 0) --active
            --end
            --if SentLocations.Has(11000+(itemid % 100)) then --check this is the id we will use for having done a recipe
            --    AddObjectToLevelAtPos("HEARTFLAME_GREEN", item_subtile_x+36, item_subtile_y, 0) --sent
            --end
        end
    end
end


--600 is Recipes
--700 is progressives



--for creatures, rooms etc etc:
--creature should go in the prison i guess
--red flame means "have unlocked"
--blue flame means "toggled on/off" (special underneath turns it off ingame, e.g. if you don't want to get a certain creature any more, you can just choose not to, same with rooms etc)

-- need to do something similar for optional fx bonus creatures like druid and maiden - hide them if we don't have the associated option on.

-- i dunno what else we need! Some useful explanatory text! Then uhhhhhh if we somehow set up a way to do transfers a more robust way: have a "pool" of transferable creatures (maybe allied creatures in an allied prison so you can see them), that when you receive a transferable one, it goes here, and you can take one or more with you to the next level by activating a box here. It's one use (but only goes away if you complete the level you transferred them to???)