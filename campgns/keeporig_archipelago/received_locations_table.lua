ReceivedLocationsTable = {}

function ReceivedLocationsTable.Add(id)
    ReceivedLocationsTable[id] = (ReceivedLocationsTable[id] or 0) + 1
end

function ReceivedLocationsTable.Has(id)
    return ReceivedLocationsTable[id] ~= nil
end

function ReceivedLocationsTable.Count(id)
    return ReceivedLocationsTable[id] or 0
end

function ReceivedLocationsTable.Total()
    local count = 0
    for key, value in pairs(ReceivedLocationsTable) do
        if type(key) == "number" and type(value) == "number" then
            count = count + value
        end
    end
    return count
end

return ReceivedLocationsTable