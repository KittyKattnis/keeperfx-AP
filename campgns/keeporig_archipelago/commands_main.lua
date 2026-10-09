--Commands to be run and saved/loaded in every level.
CommandsMain = {}

function CommandsMain.MainSetup()
      RunDKScriptCommand("SET_NEXT_LEVEL(1000)")
      Setup()
      if Map.map_number ~= 1000 then
            SetupTriggers()
      end
end

function Setup()
      QuickMessage("Map: " .. Map.map_number .. " (" .. Map.map_name .. ").", "ARCHIPELAGO_ICON")
      ActivateItems()
      if Map.map_number ~= 1000 then
            IncreaseLevelCap()
            IncreaseCreatureLimit()
            --IncreaseStartingGold() --Calling this each save and reload keeps adding gold to the player oops.
            HideVariable()
            DisplayVariableWithLabel("PLAYER0","BOXES_REMAIN","ARCHIPELAGO_BIG")
            BoxLocations.DeleteBoxes(Map.map_number)
            BoxLocations.SpawnBoxes(Map.map_number)
            BoxLocations.ActivateBoxes(Map.map_number)
            BoxLocations.IsLevelComplete(Map.map_number)
      end
      BoxLocations.UpdateEnsigns()
end

function SetupTriggers()
      print("=== SetupTriggers called on map " .. Map.map_number .. " ===")
      print("SetupTriggers called; trigger count before: " .. #(Game.triggers or {}))
      RegisterSpecialActivatedEvent(function (eventData)
            print("=== RegisterSpecialActivatedEvent ===")
            local activated_box = (eventData.SpecialBoxId % 100) + ((Map.map_number % 79)*100) --SpecialBoxId currently capped to 256 so this is a workaround. % 79 is a stupid workaround to map 100-105 to 21-26
            print("Activated Box No.: " .. activated_box)
            SendLocation(activated_box)
            print("=== GetAPCheckedLocations ===")
            local checked = GetAPCheckedLocations() or {}
            for index, id in pairs(checked) do
                  print(tostring(index) .. " = " .. tostring(id))
            end
            BoxLocations.UpdateEnsigns()
      end)
    RegisterOnConditionEvent(function() print("Level " .. Map.map_number .. " Complete!") SendLocation(10000+(Map.map_number % 79)) BoxLocations.UpdateEnsigns() BoxLocations.IsLevelComplete(Map.map_number) end, function() return (PLAYER0.victory_state == 1) end)
    print("SetupTriggers finished; trigger count after: " .. #(Game.triggers or {}))
end

Game.APBoxMessage = 1

function OnItemReceived(itemid)
      print("=== OnItemReceived ===")
      print("itemid type: " .. type(itemid) .. ", itemid value: " .. tostring(itemid))
      print("Received item " .. itemid)
      if type(itemid) ~= "number" then
          print("ERROR: Invalid item ID:", tostring(itemid))
          return
      end
      --print("Game.APBoxMessage: " .. Game.APBoxMessage)
      print("ChecksTable[itemid].text: " .. ChecksTable[itemid].text)
      RunDKScriptCommand("QUICK_INFORMATION(" .. Game.APBoxMessage .. ",\"AP Item Received:\n" .. ChecksTable[itemid].text .. "\",ALL_PLAYERS,ARCHIPELAGO_MESSAGE)") -- have to use this version as the custom icon argument isn't set up in Lua yet
      print("Quick Info (Msg ID " .. Game.APBoxMessage .."): Received: " .. ChecksTable[itemid].text)
      Game.APBoxMessage = (Game.APBoxMessage or 0) + 1
      print("Game.APBoxMessage: " .. Game.APBoxMessage)
      -- Also if you receive items while outside a level and then join, will it send all of the new ones when you go into a level?
      ReceivedLocations.ReceivedItemCheck(itemid)
      QuickMessage("Total AP Items Received: " .. ReceivedLocationsTable.Total() .. "/" .. ChecksTable.Total() .. ".", "ARCHIPELAGO_ICON")
      print("QuickMessage: Total AP Items Received: " .. ReceivedLocationsTable.Total() .. "/" .. ChecksTable.Total())
end

function ActivateItems()
      -- now returns full AP_NetworkItem!
      print("=== ActivateItems ===")
      local receivedItems = GetAPItems() or {}
      -- get the last processed index, stored in intralvl data so persists between levels and saves
      local lastProcessed = GetAPLastProcessedItemIndex()
      print("lastProcessed: " .. lastProcessed)
      for _, apitem in pairs(receivedItems) do
            local itemid = apitem.item
            local index = apitem.index
            local flags = apitem.flags
            local sender = apitem.player
            local location = apitem.location
            -- process all items that need to be unlocked on each level, i.e. rooms/creatures/spells etc
            if itemid <= 900 or itemid > 1000 then --avoid filler items
                  ReceivedLocations.ReceivedItemCheck(itemid)
            end
            print("itemid = " .. itemid .. ", index = " .. index ..", lastProcessed = " .. lastProcessed)
            if index > lastProcessed then
                  UnlockFiller(itemid)
                  lastProcessed = index
                  -- NEW LOGIC HERE TO HANDLE ONLY SINGLE SHOT ACTIVATIONS! (fillers, traps, "progressives"?)
            end
      end
      if lastProcessed ~= GetAPLastProcessedItemIndex() then
            SetAPLastProcessedItemIndex(lastProcessed)
      end
      CheckForMiscUnlocks()
      QuickMessage("Total AP Items Received: " .. ReceivedLocationsTable.Total() .. "/" .. ChecksTable.Total() .. ".", "ARCHIPELAGO_ICON")
end

function OnChatMsg(plyr_idx, msg)
      SendAPMessage(msg)
end

function print_r(t, indent)
    indent = indent or 0
    local spacing = string.rep("  ", indent)
    if type(t) == "table" then
        print(spacing .. "{")
        for k, v in pairs(t) do
            if type(v) == "table" then
                print_r(v, indent + 1)
            else
                print(spacing .. "  " .. tostring(k) .. " => " .. tostring(v))
            end
        end
        print(spacing .. "}")
    else
        print(t)
    end
end


------ Fun stuff --------------------------------------------------------------------------------------------------------

-- Testing area, set these up to options in the future.
local shuffle_tilesets = true
local change_player_colour = "RANDOM"
local change_neutrals_option = "KILL"
local swap_water_and_lava = true
local remove_neutral_rooms = true

local map_tileset_shuffle_value = {
    [1]  = -1,
    [2]  = -1,
    [3]  = -1,
    [4]  = -1,
    [5]  = -1,
    [6]  = -1,
    [7]  = -1,
    [8]  = -1,
    [9]  = -1,
    [10] = -1,
    [11] = -1,
    [12] = -1,
    [13] = -1,
    [14] = -1,
    [15] = -1,
    [16] = -1,
    [17] = -1,
    [18] = -1,
    [19] = -1,
    [20] = -1,
    [21] = -1,
    [22] = -1,
    [23] = -1,
    [24] = -1,
    [25] = -1,
    [26] = -1,
}

local player_colour_change_table = {
    [0]  = "RED",
    [1]  = "BLUE",
    [2]  = "GREEN",
    [3]  = "YELLOW",
    [4]  = "WHITE",
    [5]  = "PURPLE",
    [6]  = "BLACK",
    [7]  = "ORANGE",
    [8]  = "RANDOM",
}

-- randomly shuffle level tilesets (need to inherit from options and save those values? I.e. options will generate 26 random values from 0 to 13)
function SetShuffledTileset()
      if (map_tileset_shuffle_value[(Map.map_number % 79)] or -1) ~= -1 then
            Game.swapped_texture = map_tileset_shuffle_value[(Map.map_number % 79)]
            Map.default_texture = Game.swapped_texture
      end
end

-- if player changes colour to something other than red...
function PlayerColour()
      if PLAYER0.colour == "BLUE" then
            PLAYER1.colour = "PURPLE"
            PLAYER2.colour = "GREEN"
            PLAYER3.colour = "YELLOW"
            PLAYER5.colour = "BLACK"
            PLAYER_GOOD.colour = "WHITE"
      elseif PLAYER0.colour == "GREEN" then
            PLAYER1.colour = "BLUE"
            PLAYER2.colour = "PURPLE"
            PLAYER3.colour = "YELLOW"
            PLAYER5.colour = "BLACK"
            PLAYER_GOOD.colour = "WHITE"
      elseif PLAYER0.colour == "YELLOW" then
            PLAYER1.colour = "BLUE"
            PLAYER2.colour = "GREEN"
            PLAYER3.colour = "PURPLE"
            PLAYER5.colour = "BLACK"
            PLAYER_GOOD.colour = "WHITE"
      elseif PLAYER0.colour == "WHITE" then
            PLAYER1.colour = "BLUE"
            PLAYER2.colour = "GREEN"
            PLAYER3.colour = "YELLOW"
            PLAYER5.colour = "PURPLE"
            PLAYER_GOOD.colour = "BLACK"
      else
            PLAYER1.colour = "BLUE"
            PLAYER2.colour = "GREEN"
            PLAYER3.colour = "YELLOW"
            PLAYER5.colour = "BLACK"
            PLAYER_GOOD.colour = "WHITE"
      end
end

-- if "remove neutrals" is on
function ChangeOnMapNeutrals()
      local neutral_creatures_table = GetCreaturesOfPlayer(PLAYER_NEUTRAL)
      if change_neutrals_option == "REMOVE" then
            for _, creature in ipairs(neutral_creatures_table) do
                  if creature then
                        creature:delete()
                  end
            end
            print("Neutrals removed!")
      elseif change_neutrals_option == "KILL" then
            for _, creature in ipairs(neutral_creatures_table) do
                  if creature then
                        creature:kill()
                  end
            end
            print("Neutrals killed!")
      elseif change_neutrals_option == "HOSTILE" then
            ComputerPlayer("PLAYER5","ROAMING")
            RunDKScriptCommand("ALLY_PLAYERS(PLAYER5, PLAYER1, 3)")
            RunDKScriptCommand("ALLY_PLAYERS(PLAYER5, PLAYER2, 3)")
            RunDKScriptCommand("ALLY_PLAYERS(PLAYER5, PLAYER3, 3)")
            RunDKScriptCommand("ALLY_PLAYERS(PLAYER5, PLAYER_GOOD, 3)")
            for _, creature in ipairs(neutral_creatures_table) do
                  if creature then
                        creature.owner = PLAYER5
                  end
            end
            -- ChangeCreatureOwner doesn't work. Doing it the old fasioned way for now.
--            for _, creature in ipairs(neutral_creatures_table) do
--                  if creature then
--                        ChangeCreatureOwner(creature,"PLAYER5")
--                  end
--            end
--            for i = 1, #neutral_creatures_table do
--                  RunDKScriptCommand("CHANGE_CREATURE_OWNER(PLAYER_NEUTRAL,ANY_CREATURE,ANYWHERE,PLAYER5)")
--            end
--            print("Neutrals made hostile!")
      else
            print("Invalid option, options are \"REMOVE\", \"KILL\" and \"HOSTILE\". Default behaviour used instead.")
      end
end

-- if "swap water and lava" is on
function SwapWaterAndLava()
      print("Swapping water and lava")
      for slab_x = 0, Map.width-1 do
            for slab_y = 0, Map.height-1 do
                  local slab = GetSlab(slab_x, slab_y)
                  if slab.kind == "LAVA" then
                        print("slab (" .. slab_x .. "," .. slab_y .."), type: " .. slab.kind)
                        ChangeSlabType(slab_x, slab_y, "PURPLE_PATH", "MATCH")
                        print("Changed to PURPLE_PATH!")
                  end
            end
      end
      --print("First pass done!")
      for slab_x = 0, Map.width-1 do
            for slab_y = 0, Map.height-1 do
                  local slab = GetSlab(slab_x, slab_y)
                  if slab.kind == "WATER" then
                        print("slab (" .. slab_x .. "," .. slab_y .."), type: " .. slab.kind)
                        ChangeSlabType(slab_x, slab_y, "LAVA", "MATCH")
                        print("Changed to LAVA!")
                  end
            end
      end
      --print("Second pass done!")
      for slab_x = 0, Map.width-1 do
            for slab_y = 0, Map.height-1 do
                  local slab = GetSlab(slab_x, slab_y)
                  if slab.kind == "PURPLE_PATH" then
                        print("slab (" .. slab_x .. "," .. slab_y .."), type: " .. slab.kind)
                        ChangeSlabType(slab_x, slab_y, "WATER", "MATCH")
                        print("Changed to WATER!")
                  end
            end
      end
      --does this fix the graphics?
      --not really, it's waaaaaay too slow, so you'll have to live with it.
      --print("Refreshing slab types")
      --local final_pass_slab_type = "HARD"
      --for slab_x = 0, Map.width-1 do
      --      for slab_y = 0, Map.height-1 do
      --            local slab = GetSlab(slab_x, slab_y)
      --            local slabtype = slab.kind
      --            if slabtype ~= final_pass_slab_type and (slabtype == "HARD"
      --            or slabtype == "GOLD"
      --            or slabtype == "DIRT"
      --            or slabtype == "GEMS"
      --            or slabtype == "DENSE_GOLD"
      --            or slabtype == "ABYSS") then
      --                  print("slab (" .. slab_x .. "," .. slab_y .."), type: " .. slabtype)
      --                  ChangeSlabType(slab_x, slab_y, "PURPLE_PATH", "MATCH")
      --                  ChangeSlabType(slab_x, slab_y, slabtype, "MATCH")
      --                  print("Changed to " .. slabtype .."!")
      --                  final_pass_slab_type = slabtype
      --                  print("final_pass_slab_type: " .. final_pass_slab_type)
      --            end
      --      end
      --end
      print("Swap complete!")
end

function RemoveNeutralRooms()
      print("Removing neutral rooms")
      for slab_x = 0, Map.width-1 do
            for slab_y = 0, Map.height-1 do
                  local slab = GetSlab(slab_x, slab_y)
                  if slab.owner == PLAYER_NEUTRAL
                  and (slab.kind == "TREASURY_AREA"
                  or slab.kind == "BOOK_SHELVES"
                  or slab.kind == "PRISON_AREA"
                  or slab.kind == "TORTURE_AREA"
                  or slab.kind == "TRAINING_AREA"
                  or slab.kind == "WORKSHOP_AREA"
                  or slab.kind == "SCAVENGE_AREA"
                  or slab.kind == "TEMPLE_POOL"
                  or slab.kind == "GRAVE_AREA"
                  or slab.kind == "HATCHERY"
                  or slab.kind == "LAIR_AREA"
                  or slab.kind == "BARRACK_AREA"
                  or slab.kind == "BRIDGE_FRAME"
                  or slab.kind == "GUARD_AREA") then
                        print("slab (" .. slab_x .. "," .. slab_y .."), type: " .. slab.kind)
                        ChangeSlabType(slab_x, slab_y, "PATH", "MATCH")
                        print("Changed to PATH!")
                  end
                  if slab.owner == PLAYER_NEUTRAL
                  and (slab.kind == "TREASURY_WALL"
                  or slab.kind == "LIBRARY_WALL"
                  or slab.kind == "PRISON_WALL"
                  or slab.kind == "TORTURE_WALL"
                  or slab.kind == "TRAINING_WALL"
                  or slab.kind == "WORKSHOP_WALL"
                  or slab.kind == "SCAVENGER_WALL"
                  or slab.kind == "TEMPLE_WALL"
                  or slab.kind == "GRAVE_WALL"
                  or slab.kind == "HATCHERY_WALL"
                  or slab.kind == "LAIR_WALL"
                  or slab.kind == "BARRACK_WALL") then
                        print("slab (" .. slab_x .. "," .. slab_y .."), type: " .. slab.kind)
                        ChangeSlabType(slab_x, slab_y, "DRAPE_WALL", "MATCH")
                        print("Changed to DRAPE_WALL!")
                  end
            end
      end
      print("Neutral room removal complete!")
end


function FunOptions()
      print("=== FUN OPTIONS ===")
      if shuffle_tilesets then
            for i = 1,26 do
                  map_tileset_shuffle_value[i] = math.random(0,13)
            end
            SetShuffledTileset()
            print("Tileset changed to: " .. Map.default_texture)
      end

      if change_player_colour ~= nil then
            if type(change_player_colour) == "number" then
                  if change_player_colour >= 8 then
                        PLAYER0.colour = player_colour_change_table[math.random(0,7)]
                  elseif change_player_colour < 0 then
                        PLAYER0.colour = player_colour_change_table[0]
                  else
                        PLAYER0.colour = player_colour_change_table[change_player_colour]
                  end
            elseif type(change_player_colour) == "string" then
                  if change_player_colour == "random" then
                        PLAYER0.colour = player_colour_change_table[math.random(0,7)]
                  elseif change_player_colour == "red"
                  or change_player_colour == "BLUE"
                  or change_player_colour == "GREEN"
                  or change_player_colour == "YELLOW"
                  or change_player_colour == "WHITE"
                  or change_player_colour == "PURPLE"
                  or change_player_colour == "BLACK"
                  or change_player_colour == "ORANGE" then
                        PLAYER0.colour = change_player_colour
                  end
            end
            PlayerColour()
            print("Player colour changed to: " .. PLAYER0.colour)
      end

      if change_neutrals_option then
            ChangeOnMapNeutrals()
      end

      if swap_water_and_lava then
            SwapWaterAndLava()
      end

      if remove_neutral_rooms then
            RemoveNeutralRooms()
      end
end



return CommandsMain