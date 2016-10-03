-- Максимальное количество чекпойнтов в дуэли
local DUEL_CHECKPOINTS_COUNT = 1
-- Максимальная длительность дуэли в секундах
local DUEL_DURATION = 180

local activeDuels = {}

local function getVehicleSpawnpoint(vehicle)
	if not isElement(vehicle) then
		return false
	end
	local x, y, z = getElementPosition(vehicle)
	local rx, ry, rz = getElementRotation(vehicle)
	return {x, y, z, rx, ry, rz}
end

function startDuel(player1, player2, bet)
	if not isElement(player1) or not isElement(player2) then
		outputDebugString("Duel: no player")
		return
	end
	if not player1.vehicle or not player2.vehicle then
		outputDebugString("Duel: no vehicle")
		return false
	end	
	if player1:getData("dpCore.state") or player2:getData("dpCore.state") then
		return
	end
	if not bet then
		outputDebugString("Duel: no bet")
		return
	end
	-- TODO: Проверить расстояние между игроками

	-- Генерация случайной трассы
	local checkpoints = PathGenerator.generateCheckpointsForPlayer(player1, DUEL_CHECKPOINTS_COUNT)
	if not checkpoints then
		return false
	end
	-- Спавны
	local spawnpoints = {
		getVehicleSpawnpoint(player1.vehicle),
		getVehicleSpawnpoint(player2.vehicle)
	}
	-- Создание карты и настройки
	local raceMap = exports.dpRaceManager:createRaceMap(checkpoints, spawnpoints)
	if not raceMap then
		outputDebugString("No race map")
		return false
	end
	local raceSettings = {
		separateDimension = false,
		gamemode = "duel",
		duration = DUEL_DURATION
	}
	local race = exports.dpRaceManager:createRace(raceSettings, raceMap)
	if not race then
		return false
	end
	-- Добавить игроков в гонку
	exports.dpRaceManager:raceAddPlayer(race, player1)
	exports.dpRaceManager:raceAddPlayer(race, player2)

	activeDuels[race] = {
		players = {player1, player2},
		bet = bet
	}

	setTimer(function () 
		exports.dpRaceManager:startRace(race)
	end, 3000, 1)
end

addCommandHandler("duel", function (player)
	if not player.vehicle then
		exports.dpChat:output("general", "No vehicle")
		return false
	end
	local players = getElementsByType("player")
	startDuel(players[1], players[1], 100)
end)

addEvent("RaceDuel.duelFinished", false)
addEventHandler("RaceDuel.duelFinished", root, function (player, timePassed)
	if not isElement(player) then
		return false
	end
	local duel = activeDuels[source]
	if not duel then
		outputDebugString("Duel finished, but not active")
		return false
	end
	exports.dpCore:givePlayerMoney(player, duel.bet * 2)
	exports.dpVehicles:unforceVehicleHandling(player.vehicle)
	for i, p in ipairs(duel.players) do
		if isElement(p) then
			exports.dpVehicles:unforceVehicleHandling(p.vehicle)
			triggerClientEvent(p, "dpDuels.showWinner", resourceRoot, player, duel.bet * 2, timePassed)
		end
	end
end)

addEvent("dpRaceManager.raceDestroyed", false)
addEventHandler("dpRaceManager.raceDestroyed", root, function()
	if activeDuels[source] then
		triggerClientEvent("dpDuels.showWinner", resourceRoot, false)
		for i, player in ipairs(activeDuels[source].players) do
			if isElement(player) then
				exports.dpVehicles:unforceVehicleHandling(player.vehicle)
				triggerClientEvent(player, "dpDuels.showWinner", resourceRoot, false)
			end
		end
	end
end)

addEventHandler("onResourceStop", resourceRoot, function ()
	for duel in pairs(activeDuels) do
		exports.dpRaceManager:destroyRace(duel)
	end
end)