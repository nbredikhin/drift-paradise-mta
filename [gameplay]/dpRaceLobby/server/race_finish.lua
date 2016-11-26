local PRIZE_INITIAL = 2000
local PRIZE_PLAYER_ADD = 1000

local EXP_INITIAL = 100
local EXP_PLAYER_ADD = 50

local function showPlayerRaceFinish(player, race, time, rank, score)
    if not isElement(player) then
        return 
    end
    local noPrize = false
    if type(rank) ~= "number" then
        rank = 6
    end    
    local raceInfo = race:getData("dpRaceLobby.raceInfo")
    if type(raceInfo) ~= "table" then
        raceInfo = { rank = 1 }
    end

    local players = exports.dpRaceManager:raceGetAllPlayers(race)
    local racePrizes = exports.dpShared:getEconomicsProperty("race_prizes")
    if not racePrizes then
        racePrizes = {}
    end
    if not racePrizes[rank] then
        racePrizes[rank] = {}
    end
    local finishedPlayers = exports.dpRaceManager:raceGetFinishedPlayers(race) or 0
    local currentPlayers = exports.dpRaceManager:raceGetPlayers(race) or 0
    if #finishedPlayers == 0 and #currentPlayers == 0 then
        rank = 6
    end

    local prize = racePrizes[rank].money
    if not prize then
        prize = 0
    end
    local exp = racePrizes[rank].xp
    if not exp then
        exp = 0
    end

    exports.dpCore:givePlayerMoney(player, prize)
    exports.dpCore:givePlayerXP(player, exp)

    for i, p in ipairs(players) do
        triggerClientEvent(p, "RaceLobby.playerFinished", resourceRoot, player, prize, exp, rank, time, score)
    end
    exports.dpRaceManager:raceRemovePlayer(race, player)
    fadeCamera(player, true, 1)
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