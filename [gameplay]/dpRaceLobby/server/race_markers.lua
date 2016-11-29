local MAX_MARKERS_COUNT = 7
local RESPAWN_TIME = 60

local SAFE_ZONE_SIZE = 15

local activeMarkers = {}
local gamemodesList = {
    "sprint",
    "drift"
}

function createMapMarker(map)
    local position = exports.dpRaceManager:getMapStartPosition(map.name)
    if not position then
        return
    end
    local marker = exports.dpMarkers:createMarker("race", position + Vector3(0, 0, -0.5), 180)
    marker:setData("dpMarkers.restrictElement", "vehicle")
    local safeZoneVector = Vector3(SAFE_ZONE_SIZE, SAFE_ZONE_SIZE, 0)
    local colshape = exports.dpSafeZones:createSafeZone(position - safeZoneVector, position + safeZoneVector)
    local blip = createBlip(0, 0, 0, 33)
    blip:attach(marker)
    blip:setData("text", "race_type_" .. map.gamemode) 
    marker:setData("RaceMarker.map", map.name)

    table.insert(activeMarkers, {marker, blip, colshape})
end

function clearRaceMarkers()
    for i, elements in ipairs(activeMarkers) do
        for j, e in ipairs(elements) do
            if isElement(e) then
                destroyElement(e)
            end
        end
    end
    activeMarkers = {}
end

function respawnRaceMarkers()
    local mapsByGamemode = {}
    local totalMapCount = 0
    for i, gamemode in ipairs(gamemodesList) do
        mapsByGamemode[gamemode] = {}
        local mapsList = exports.dpRaceManager:getMapsList(gamemode)
        if mapsList then
            for mapName, mapInfo in pairs(mapsList) do
                mapInfo.name = mapName
                table.insert(mapsByGamemode[gamemode], mapInfo)
                totalMapCount = totalMapCount + 1
            end
        end
    end

    if totalMapCount == 0 then
        outputDebugString("Failed to create race markers: no maps")
        return false
    end

    -- Удаление старых маркеров
    clearRaceMarkers()
    
    local needMapsCount = math.min(totalMapCount, MAX_MARKERS_COUNT)
    outputDebugString("RaceMarkers: Spawning " .. tostring(needMapsCount) .. " markers")
    local mapsCount = 0
    local gamemodeIndex = math.random(1, #gamemodesList)
    local mapsList = {}
    while mapsCount < needMapsCount do
        local gamemode = gamemodesList[gamemodeIndex]
        -- Выбрать следующий режим
        gamemodeIndex = gamemodeIndex + 1
        if gamemodeIndex > #gamemodesList then
            gamemodeIndex = 1
        end
        -- Если остались карты - выбрать карту
        if #mapsByGamemode[gamemode] > 0 then
            local index = 1
            if #mapsByGamemode[gamemode] > 1 then 
                index = math.random(1, #mapsByGamemode[gamemode])
            end
            local map = table.remove(mapsByGamemode[gamemode], index)
            table.insert(mapsList, map)
            mapsCount = mapsCount + 1
        end
    end

    for i, map in ipairs(mapsList) do
        createMapMarker(map)
    end 
end

addEventHandler("onResourceStart", resourceRoot, respawnRaceMarkers)
addEventHandler("onResourceStop", resourceRoot, clearRaceMarkers)

-- Автоматический респавн
setTimer(respawnRaceMarkers, RESPAWN_TIME * 1000 * 60, 0)