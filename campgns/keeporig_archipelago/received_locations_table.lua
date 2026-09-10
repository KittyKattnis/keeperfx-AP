ReceivedLocationsTable = {}

-- This should be the local table taking in info from AP. Need to find a way to read and write to this.

function ReceivedLocationsTable.Add(id)
    ReceivedLocationsTable[id] = true
end

function ReceivedLocationsTable.Has(id)
    return ReceivedLocationsTable[id] == true
end

function ReceivedLocationsTable.Count(checks)
    local count = 0
    if checks then
        for _, iteminfo in pairs(checks) do
            if ReceivedLocationsTable.Has(iteminfo.id) then
                count = count + 1
            end
        end
    end
    return count
end

function ReceivedLocationsTable.Total()
    local count = 0
    for key, value in pairs(ReceivedLocationsTable) do
        if type(key) == "number" and type(value) == "boolean" then
            count = count + 1
        end
    end
    return count
end

return ReceivedLocationsTable