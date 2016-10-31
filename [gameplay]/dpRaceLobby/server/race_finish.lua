local PRIZE_INITIAL = 2000
local PRIZE_PLAYER_ADD = 1000

local CLASS_MUL = 0.9
local LEVEL_MUL = 2

local EXP_INITIAL = 100
local EXP_PLAYER_ADD = 50

local function getVehicleClassMul(vehicleClass)
    return 1 + (vehicleClass - 1) / 5 * CLASS_MUL
end

local function getLevelMul(player)
    local level = player:getData("level")
    if not level then
        level = 1
    end
    level = level - 1
    return 1 + level / 99 * LEVEL_MUL
end

local function showPlayerRaceFinish(player, race, time, rank, score)
    if not isElement(player) then
        return 
    end 

    local raceInfo = race:getData("dpRaceLobby.raceInfo")
    if type(raceInfo) ~= "table" then
        raceInfo = { rank = 1 }
    end

    local players = exports.dpRaceManager:raceGetAllPlayers(race)
    local rankMul = 0
    if rank then
        rankMul = math.max(0, 1 - (rank - 1) / 3)
    else
        rank = 4
    end
    local mul = rankMul * getVehicleClassMul(raceInfo.rank) * getLevelMul(player)
    if score and score == 0 then
        mul = 0
    end
    local prize = math.floor((PRIZE_INITIAL + (#players * PRIZE_PLAYER_ADD)) * mul / 250) * 250
    local exp = math.floor((EXP_INITIAL + (#players * EXP_PLAYER_ADD)) * mul / 50) * 50

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