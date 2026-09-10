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
      IncreaseStartingGold()
      HideVariable()    
      DisplayVariableWithLabel("PLAYER0","BOXES_REMAIN","ARCHIPELAGO_MESSAGE")
      ActivateItems()
      BoxLocations.DeleteBoxes(Map.map_number)
      BoxLocations.SpawnBoxes(Map.map_number)
      BoxLocations.ActivateBoxes(Map.map_number)
end

function SetupTriggers()
      RegisterSpecialActivatedEvent(function (eventData)
            local activated_box = eventData.SpecialBoxId
            print(activated_box)
            SendLocation(activated_box)
            SentLocations.Add(activated_box)
            print("=== SentLocations ===")
            for key, value in pairs(SentLocations) do
                  print(tostring(key) .. " = " .. tostring(value))
            end
            print("=== GetAPCheckedLocations ===")
            local checked = GetAPCheckedLocations() or {}
            for index, id in pairs(checked) do
                  print(tostring(index) .. " = " .. tostring(id))
            end
      end)
    RegisterOnConditionEvent(function() SendLocation(10000+Map.map_number) end, function() return (PLAYER0.victory_state == 1) end)
end

function OnItemReceived(itemid)
      print("Received item " .. itemid)
      RunDKScriptCommand("QUICK_INFORMATION(100,\"AP Item Received:\n" .. ChecksTable[itemid].text .. "\",ALL_PLAYERS,ARCHIPELAGO_MESSAGE)") -- have to use this version as the custom icon argument isn't set up in Lua yet
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
      QuickMessage("Total AP Items Received: " .. ReceivedLocationsTable.Total() .. "/" .. ChecksTable.Total() .. ".", "ARCHIPELAGO_ICON")
end

return CommandsMain