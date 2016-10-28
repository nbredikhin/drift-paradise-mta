local TEST_RACE_ENABLED = false

addEventHandler("onResourceStart", resourceRoot, function ()    
    if not TEST_RACE_ENABLED then
        return
    end
    RaceManager.startRace({
        id = 1, 
        map = "hello-world",
        gamemode = "drift",
        players = getElementsByType("player"),
        rank = 1,
        readyCount = 1
    })
end)