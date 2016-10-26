local TEST_RACE_ENABLED = true

addEventHandler("onResourceStart", resourceRoot, function ()    
    if not TEST_RACE_ENABLED then
        return false
    end
    local raceMap = exports.dpRaceManager:loadRaceMap("hello-world")
    local raceSettings = {
        separateDimension = true,
        gamemode = "sprint",
        duration = 30
    }
    local race = exports.dpRaceManager:createRace(raceSettings, raceMap)
    if not race then
        return false
    end
    for i, v in ipairs(getElementsByType("player")) do
        exports.dpRaceManager:raceAddPlayer(race, v)
    end
    
    setTimer(function ()
        exports.dpRaceManager:startRace(race)
    end, 3000, 1)
end)