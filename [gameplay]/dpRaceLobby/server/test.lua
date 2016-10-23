local TEST_RACE_ENABLED = false

addEventHandler("onResourceStart", resourceRoot, function ()    
    if not TEST_RACE_ENABLED then
        return false
    end
    local raceMap = exports.dpRaceManager:loadRaceMap("hello-world")
    local raceSettings = {
        separateDimension = true,
        gamemode = "drift",
        duration = 50
    }
    local race = exports.dpRaceManager:createRace(raceSettings, raceMap)
    if not race then
        return false
    end
    exports.dpRaceManager:raceAddPlayer(race, getRandomPlayer())
    setTimer(function ()
        exports.dpRaceManager:startRace(race)
    end, 3000, 1)
end)