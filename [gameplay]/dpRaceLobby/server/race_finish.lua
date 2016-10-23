local function showPlayerRaceFinish(player, race)
    if not isElement(player) then
        return 
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

    fadeCamera(player, false, 2)
    setTimer(showPlayerRaceFinish, 3000, 1, player, race)
end)