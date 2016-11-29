local TEST_RACE_ENABLED = false

addCommandHandler("racetest", function ()
    if not TEST_RACE_ENABLED then
        return
    end
    RaceManager.startRace({
        id = 1, 
        map = "drift-4",
        gamemode = "sprint",
        players = getElementsByType("player"),
        rank = 1,
        readyCount = 1
    })
end)