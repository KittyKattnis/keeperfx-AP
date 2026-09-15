SentLocations = {}

function SentLocations.Add(id)
    SentLocations[id] = true
end

function SentLocations.Has(id)
    local sentLocations = GetAPCheckedLocations() or {}
    return sentLocations[id] ~= nil -- True if it's got an assigned value. Otherwise, false because it's not yet put into that table.
end

function SentLocations.Count(mapBoxIDs)
    local found = 0
    if mapBoxIDs then
        for _, id in pairs(mapBoxIDs) do
            if SentLocations.Has(id) then
                found = found + 1
            end
        end
    end
    return found
end

return SentLocations