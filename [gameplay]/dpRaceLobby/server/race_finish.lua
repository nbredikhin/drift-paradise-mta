local function showPlayerRaceFinish(player, race, time, rank, score)
    if not isElement(player) then
        return 
    end
    local noPrize = false
    if type(rank) ~= "number" then
        rank = 6
    end    

    local totalPlayers = exports.dpRaceManager:raceGetAllPlayers(race)
    local totalPlayersCount = exports.dpRaceManager:getTotalRaceCount(race)
    local racePrizes = exports.dpShared:getEconomicsProperty("race_prizes")
    if not racePrizes then
        racePrizes = {}
    end
    if not racePrizes[rank] then
        racePrizes[rank] = {}
    end
    local finishedPlayers = exports.dpRaceManager:raceGetFinishedPlayers(race) or 0
    local currentPlayers = exports.dpRaceManager:raceGetPlayers(race) or 0
    if (not finishedPlayers or #finishedPlayers == 0) and (not currentPlayers or #currentPlayers == 0) then
        rank = 6
    end

    local mul = math.max(math.min(1, totalPlayersCount / 5))
    local prize = racePrizes[rank].money
    if not prize then
        prize = 0
    end
    prize = math.ceil(prize * mul)
    local exp = racePrizes[rank].xp
    if not exp then
        exp = 0
    end

    exports.dpCore:givePlayerMoney(player, prize)
    exports.dpCore:givePlayerXP(player, exp)

    for i, p in ipairs(totalPlayers) do
        triggerClientEvent(p, "RaceLobby.playerFinished", resourceRoot, player, prize, exp, rank, time, score)
    end
    fadeCamera(player, true, 1)
    exports.dpRaceManager:raceRemovePlayer(race, player)
end

addEvent("RaceLobby.playerFinished", false)
addEventHandler("RaceLobby.playerFinished", root, function (player, time, rank, score)
    if not isElement(player) then
        return false
    end
    local race = source
    if not time then
        time = 0
    else
        time = time / 1000
    end
    fadeCamera(player, false, 1)
    setTimer(showPlayerRaceFinish, 1000, 1, player, race, time, rank, score)
end)