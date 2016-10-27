-- Максимальное количество чекпойнтов в дуэли
local DUEL_CHECKPOINTS_COUNT = 15
-- Максимальная длительность дуэли в секундах
local DUEL_DURATION = 300

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

	race:setData("dpDuels.duelInfo", {
		bet = bet
	})

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

addEvent("RaceDuel.finished", false)
addEventHandler("RaceDuel.finished", root, function (playerWinner, timePassed)
	local duelInfo = source:getData("dpDuels.duelInfo")
	if type(duelInfo) ~= "table" then
		return
	end
	source:setData("dpDuels.duelInfo", true)
	if type(duelInfo.bet) ~= "number" then
		duelInfo.bet = 0
	end
	-- Выдача приза победителю
	local prize = duelInfo.bet * 2
	if isElement(playerWinner) then
		exports.dpCore:givePlayerMoney(playerWinner, prize)
	end

	-- Отображение экрана финиша
	local players = exports.dpRaceManager:raceGetAllPlayers(source)
	if type(players) ~= "table" then
		return
	end
	for i, player in ipairs(players) do
		triggerClientEvent(player, "dpDuels.showWinner", resourceRoot, playerWinner, prize, timePassed)
	end
end)

addEventHandler("onResourceStop", resourceRoot, function ()
	for race in ipairs(getElementsByType("race")) do
		if race:getData("dpDuels.duelInfo") then
			exports.dpRaceManager:destroyRace(race)
		end
	end
end)