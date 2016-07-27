-- Максимальное количество чекпойнтов в дуэли
local DUEL_CHECKPOINTS_COUNT = 30
-- Максимальная длительность дуэли в секундах
local DUEL_DURATION = 300

function startDuel(player1, player2)
	-- TODO: Проверить расстояние между игроками

	local race = exports.dpRaceManager:createRace({
		-- Не спавнить игроков на спавнпойнтах, оставить их на своих позициях
		noSpawnpoints = true,
		-- Не нужен отдельный dimension
		separateDimension = false,
		-- Не затемнять камеру при входе в дуэль
		fadeCameraOnJoin = false
	})
	if not race then
		exports.dpChat:output("general", "Не удалось запустить дуэль: невозможно создать гонку")
		return false
	end
	-- Генерация случайной трассы
	local checkpoints = PathGenerator.generateCheckpointsForPlayer(player1, DUEL_CHECKPOINTS_COUNT)
	exports.dpRaceManager:raceLoadMap(race, {
		duration = DUEL_DURATION,
		checkpoints = checkpoints
	})
	-- Добавить игроков в гонку
	exports.dpRaceManager:raceAddPlayers(race, {player1, player2})

	setTimer(function () 
		exports.dpRaceManager:startRace(race)
	end, 3000, 1)
end

-- addCommandHandler("duel", function (player)
-- 	if not player.vehicle then
-- 		exports.dpChat:output("general", "No vehicle")
-- 		return false
-- 	end
-- 	exports.dpChat:output("general", "Создание дуэли...")
-- 	startDuel(player)
-- end)