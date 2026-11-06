return setmetatable({
    ["CheaperImps#23"] = 11001,
    ["CompleteManufacture#24 24"] = 11002,
    ["CompleteResearch#19 19"] = 11003,
    ["BILE_DEMON#26 26 26"] = 11004,
    ["SORCEROR#19 26"] = 11005,
    ["DARK_MISTRESS#24 26"] = 11006,
    ["HORNY#16 22 20"] = 11007,
    ["MakeAngry#14"] = 11008,
    ["KillChickens"] = 11009, -- If no creatures, it was a chicken.
    ["KillChickens#28"] = 11009,
    ["SPELL_DISEASE#25 25"] = 11010,
    ["SPELL_CHICKEN#22 22"] = 11011,
    ["TENTACLE#16 26"] = 11012,
    ["HELL_HOUND#19 17"] = 11013,
    ["SPELL_SPEED#19 27"] = 11014,
    ["SPELL_INVISIBILITY#16 19"] = 11015,
    ["SPELL_HEAL#30 26"] = 11016,
    ["SPELL_REBOUND#20 24"] = 11017,
    ["SPELL_ARMOUR#22 24"] = 11018,
    ["SPELL_FLIGHT#18 19"] = 11019,
    ["SPELL_FREEZE#25 26"] = 11020,
    ["SPELL_SLOW#25 18"] = 11021,
    ["SKELETON#15 15"] = -1, -- Good skeleton punishment
    ["MakeVeryAngry"] = -1, -- Doesn't yet exist in AP data.
    ["EasterEgg"] = -1, -- Spider easter-egg, doesn't exist in AP Data.
},{
    __index = function(table, key)
        local wish_amount = key:match("^WishWell#(.*)")
        if wish_amount ~= nil then
            local gold_amount = tonumber(wish_amount) -- Value that triggered in the sacrifice. -IF- you want to do something with it.
            return -1 -- Doesn't have an associated location yet.
        end
        QuickMessage("Unhandled temple recipe (check log)", "ARCHIPELAGO_ICON")
        print("[temple_recipe_table] No value found for: " .. key)
        return -1 
    end
})