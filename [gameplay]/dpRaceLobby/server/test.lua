local TEST_RACE_ENABLED = true

addCommandHandler("racetest", function ()
    if not TEST_RACE_ENABLED then
        return
    end
    RaceManager.startRace({
        id = 1, 
        map = "sprint-2",
        gamemode = "sprint",
        players = getElementsByType("player"),
        rank = 1,
        readyCount = 1
    })
end)