local function showPlayerRaceFinish(player, race, time, rank, score)
    if not isElement(player) then
        outputDebugString("dpRaceLobby: showPlayerRaceFinish - no player")
        fadeCamera(player, true, 1)
        return 
    end
    if not isElement(race) then
        outputDebugString("dpRaceLobby: showPlayerRaceFinish - no race")
        fadeCamera(player, true, 1)
        return 
    end
    if not rank or type(rank) ~= "number" then
        outputDebugString("dpRaceLobby: showPlayerRaceFinish - bad raknk '" .. tostring(rank) .. "'. Now 6")
        rank = 6
    end    

    local totalPlayers = exports.dpRaceManager:raceGetAllPlayers(race)
    if not totalPlayers then
        outputDebugString("dpRaceLobby: failed to get players list")
        return      
    end
    local totalPlayersCount = exports.dpRaceManager:raceGetTotalPlayersCount(race)
    if not totalPlayersCount then
        totalPlayersCount = 0
    end
    local racePrizes = exports.dpShared:getEconomicsProperty("race_prizes")
    if not racePrizes then
        racePrizes = {}
    end
    if not racePrizes[rank] then
        racePrizes[rank] = {}
    end
    local finishedPlayers = exports.dpRaceManager:raceGetFinishedPlayers(race)
    if type(finishedPlayers) ~= "table" then
        finishedPlayers = {}
    end
    local currentPlayers = exports.dpRaceManager:raceGetPlayers(race)
    if type(currentPlayers) ~= "table" then
        currentPlayers = {}
    end
    if #finishedPlayers == 0 and #currentPlayers == 0 then
        rank = 6
    end

    local rankMul = math.max(math.min(1, totalPlayersCount / 5))
    if type(racePrizes[rank]) ~= "table" then
        racePrizes[rank] = {}
    end
    local prize = racePrizes[rank].money
    if type(prize) ~= "number" then
        outputDebugString("dpRaceLobby: showPlayerRaceFinish - no prize")
        prize = 0
    end
    prize = math.ceil(prize * rankMul)
    local exp = racePrizes[rank].xp
    if not exp then
        exp = 0
    end

    exports.dpCore:givePlayerMoney(player, prize)
    exports.dpCore:givePlayerXP(player, exp)

    exports.dpRaceManager:raceRemovePlayer(race, player)
    for i, p in ipairs(totalPlayers) do
        triggerClientEvent(p, "RaceLobby.playerFinished", resourceRoot, player, prize, exp, rank, time, score)
    end
    fadeCamera(player, true, 1)
end

addEvent("RaceLobby.playerFinished", false)
addEventHandler("RaceLobby.playerFinished", root, function (player, time, rank, score)
    if not isElement(player) then
        outputDebugString("RaceLobby.playerFinished - bad player")
        return false
    end
    if type(time) ~= "number" then
        time = 0
    else
        time = time / 1000
    end
    fadeCamera(player, false, 1)

    local race = source
    setTimer(showPlayerRaceFinish, 1000, 1, player, race, time, rank, score)
    outputDebugString("dpRaceLobby: player finished " .. tostring(player.name))
end)