-- Максимальное количество чекпойнтов в дуэли
local DUEL_CHECKPOINTS_COUNT = 5
-- Максимальная длительность дуэли в секундах
local DUEL_DURATION = 180

function startDuel(player1, player2, bet)
	if not isElement(player1) or not isElement(player2) then
		outputDebugString("Duel: no player")
		return
	end
	if player1:getData("dpCore.state") or player2:getData("dpCore.state") then
		return
	end
	if not bet then
		outputDebugString("Duel: no bet")
		return
	end
	-- TODO: Проверить расстояние между игроками

	local race = exports.dpRaceManager:createRace({
		-- Не спавнить игроков на спавнпойнтах, оставить их на своих позициях
		noSpawnpoints = true,
		-- Не нужен отдельный dimension
		separateDimension = false,
		-- Не затемнять камеру при входе в дуэль
		fadeCameraOnJoin = false,
		onePlayerFinish = true,
		duration = DUEL_DURATION,

		money = {
			bet * 2, 
			0
		}
	})
	if not race then
		return false
	end
	-- Генерация случайной трассы
	local checkpoints = PathGenerator.generateCheckpointsForPlayer(player1, DUEL_CHECKPOINTS_COUNT)
	exports.dpRaceManager:raceSetMap(race, {	
		checkpoints = checkpoints,
		separateDimension = false,
		ignoreSpawnpoints = true
	})
	-- Добавить игроков в гонку
	exports.dpRaceManager:raceAddPlayers(race, {player1, player2})

	setTimer(function () 
		exports.dpRaceManager:startRace(race)
	end, 3000, 1)
end

addCommandHandler("duel", function (player)
	outputDebugString("da")
	if not player.vehicle then
		exports.dpChat:output("general", "No vehicle")
		return false
	end
	local players = getElementsByType("player")
	startDuel(players[1], players[1], 100)
end)

