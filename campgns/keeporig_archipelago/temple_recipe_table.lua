return setmetatable({
    ["CheaperImps#23"] = 11001,
    ["CompleteManufacture#24 24"] = 11002,
    ["CompleteResearch#19 19"] = 11003,
    ["BILE_DEMON#26 26 26"] = 11004,
    ["SORCEROR#19 26"] = 11005,
    ["DARK_MISTRESS#24 26"] = 11006,
    ["HORNY#16 22 20"] = 11007,
    --["WishWell#1"] = 11008 --Wishing well recipe (11008) requires dropping gold, see below.
    ["KillChickens#28"] = 11009,
    ["KillChickens"] = 11010, -- If no creatures, it was a chicken.
    ["SPELL_DISEASE#25 25"] = 11011,
    ["MakeAngry#14"] = 11012,
    ["SPELL_CHICKEN#22 22"] = 11013,
    ["EasterEgg"] = 11014, -- Spider easter-egg, doesn't exist in AP Data.
    ["SKELETON#15 15"] = 11015, -- Good skeleton punishment
    ["TENTACLE#16 26"] = 11016,
    ["HELL_HOUND#19 17"] = 11017,
    ["SPELL_SPEED#19 27"] = 11018,
    ["SPELL_INVISIBILITY#16 19"] = 11019,
    ["SPELL_HEAL#30 26"] = 11020,
    ["SPELL_REBOUND#20 24"] = 11021,
    ["SPELL_ARMOUR#22 24"] = 11022,
    ["SPELL_FLIGHT#18 19"] = 11023,
    ["SPELL_FREEZE#25 26"] = 11024,
    ["SPELL_SLOW#25 18"] = 11025,
    ["MakeVeryAngry"] = -1, -- Doesn't yet exist in AP data.
},{
    __index = function(table, key)
        local wish_amount = key:match("^WishWell#(.*)")
        if wish_amount ~= nil then
            local gold_amount = tonumber(wish_amount) -- Value that triggered in the sacrifice. -IF- you want to do something with it.
            return 11008
        end
        QuickMessage("Unhandled temple recipe (check log)", "ARCHIPELAGO_ICON")
        print("[temple_recipe_table] No value found for: " .. key)
        return -1 
    end
})