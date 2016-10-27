local TEST_RACE_ENABLED = false

addEventHandler("onResourceStart", resourceRoot, function ()    
    RaceManager.startRace({
        id = 1, 
        map = "hello-world",
        gamemode = "drift",
        players = {getRandomPlayer()},
        rank = 1,
        readyCount = 1
    })
end)