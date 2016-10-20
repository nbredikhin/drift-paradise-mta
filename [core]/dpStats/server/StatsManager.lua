StatsManager = {}

local statsSources = {}

local function getStats(name)
    local path = "data/" .. tostring(name) .. ".json"
    if not fileExists(path) then
        return {}
    end
    local file = fileOpen(path)
    data = fromJSON(tostring(file:read(file.size)))
    file:close()
    return data
end

local function putStatsValue(name, value, maxCount)
    local path = "data/" .. tostring(name) .. ".json"
    local data = {}
    if fileExists(path) then
        data = getStats(name)
        fileDelete(path)
    end
    local file = fileCreate(path)
    if type(data) ~= "table" then
        data = {}
    end
    table.insert(data, value)
    while #data > maxCount do
        table.remove(data, 1)
    end
    file:write(toJSON(data))
    return file:close()
end

function StatsManager.registerSource(name, interval, historyLength, callback)
    if type(name) ~= "string" then
        outputDebugString("StatsManager.registerSource: name must be string")
        return false
    end
    if type(interval) ~= "number" then
        outputDebugString("StatsManager.registerSource: interval must be number")
        return false
    end
    if type(historyLength) ~= "number" then
        outputDebugString("StatsManager.registerSource: historyLength must be number")
        return false
    end    
    if type(callback) ~= "function" then
        outputDebugString("StatsManager.registerSource: callback must be function")
        return false
    end
    if statsSources[name] then
        outputDebugString(string.format("StatsManager.registerSource: source '%s' is already registered", name))
        return false
    end

    setTimer(function ()
        local value = callback()
        if not value then
            outputDebugString("StatsManager: callback must return value")
            return
        end
        putStatsValue(name, value, historyLength)
    end, interval, 0)
end

addEvent("dpStats.requireStats", true)
addEventHandler("dpStats.requireStats", root, function (name)
    triggerClientEvent(client, "dpStats.stats", root, name, getStats(name))
end)