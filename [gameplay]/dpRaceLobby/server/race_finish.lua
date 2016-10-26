local function showPlayerRaceFinish(player, race)
    if not isElement(player) then
        return 
    end 
    local prize = math.random(1, 30) * 500
    local exp = math.random(1, 250) * 50
    local time = math.random(30, 90)
    local score = math.random(90000, 800000)

    local players = exports.dpRaceManager:raceGetAllPlayers(race)    
    for i, p in ipairs(players) do
        triggerClientEvent(p, "RaceLobby.playerFinished", resourceRoot, player, prize, exp, time, score)
    end
    exports.dpRaceManager:raceRemovePlayer(race, player)
    fadeCamera(player, true, 2)
end

addEvent("RaceLobby.playerFinished", false)
addEventHandler("RaceLobby.playerFinished", root, function (player)
    if not isElement(player) then
        return false
    end
    local race = source

    setTimer(fadeCamera, 2000, 1, player, false, 1)
    setTimer(showPlayerRaceFinish, 3000, 1, player, race)
end)