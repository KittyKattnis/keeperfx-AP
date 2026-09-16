--Commands to be run and saved/loaded in every level.
CommandsMain = {}

function CommandsMain.MainSetup()
      RunDKScriptCommand("SET_NEXT_LEVEL(1000)")
      Setup()
      SetupTriggers()
end

function Setup()
      QuickMessage("Map: " .. Map.map_number .. " (" .. Map.map_name .. ").", "ARCHIPELAGO_ICON")
      IncreaseLevelCap()
      IncreaseCreatureLimit()
      --IncreaseStartingGold() --Calling this each save and reload keeps adding gold to the player oops.
      HideVariable()
      DisplayVariableWithLabel("PLAYER0","BOXES_REMAIN","ARCHIPELAGO_BIG")
      ActivateItems()
      BoxLocations.DeleteBoxes(Map.map_number)
      BoxLocations.SpawnBoxes(Map.map_number)
      BoxLocations.ActivateBoxes(Map.map_number)
      BoxLocations.IsLevelComplete(Map.map_number)
      BoxLocations.UpdateEnsigns()
end

function SetupTriggers()
      RegisterSpecialActivatedEvent(function (eventData)
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
end

Game.APBoxMessage = 1

function OnItemReceived(itemid)
      print("Received item " .. itemid)
      RunDKScriptCommand("QUICK_INFORMATION(" .. Game.APBoxMessage .. ",\"AP Item Received:\n" .. ChecksTable[itemid].text .. "\",ALL_PLAYERS,ARCHIPELAGO_MESSAGE)") -- have to use this version as the custom icon argument isn't set up in Lua yet
      Game.APBoxMessage = Game.APBoxMessage + 1
      -- only need to do this when new items are received. Need to check setting message number to 100 is ok.
      -- Also if you receive items while outside a level and then join, will it send all of the new ones when you go into a level?
      ReceivedLocations.ReceivedItemCheck(itemid)
      QuickMessage("Total AP Items Received: " .. ReceivedLocationsTable.Total() .. "/" .. ChecksTable.Total() .. ".", "ARCHIPELAGO_ICON")
end

function ActivateItems()
      local receivedItems = GetAPItems()
      for index, itemid in pairs(receivedItems) do
            ReceivedLocations.ReceivedItemCheck(itemid)
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

return CommandsMain