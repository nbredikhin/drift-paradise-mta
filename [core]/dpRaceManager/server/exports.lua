-- Создание гонки. 
-- table settings - настройки гонки (см. Race.lua)
-- возвращает id гонки
function createRace(settings)
	local race = Race(settings)
	if not race then
		return false
	end
	return raceManager:addRace(race)
end

-- Полностью удаляет гонку
-- number id - id гонки
-- возвращает boolean - результат выполнения
function removeRace(id)
	local race = raceManager:getRaceById(id)
	if not race then
		return false
	end
	return raceManager:removeRace(race)
end

-- Начать гонку
-- number id - id гонки
-- возвращает boolean - результат выполнения
function startRace(id)
	local race = raceManager:getRaceById(id)
	if not race then
		return false
	end
	return race:start()
end

-- Загрузить карту в гонку
-- number id - id гонки
-- string mapName - название карты
-- возвращает boolean - результат выполнения
function raceLoadMap(id, mapName)
	local race = raceManager:getRaceById(id)
	if not race then
		return false
	end
	return race:loadMap(mapName)
end

-- Добавить нескольких игроков в гонку
-- number id 		- id гонки
-- table players 	- массив игроков, которых нужно добавить в гонку
-- возвращает boolean - результат выполнения
function raceAddPlayers(id, players)
	local race = raceManager:getRaceById(id)
	if not race then
		return false
	end
	return race:addPlayers(players)
end

-- Добавить одного игрока в гонку
-- number id 		- id гонки
-- element player 	- игрок, которого нужно добавить в гонку
-- возвращает boolean - результат выполнения
function raceAddPlayer(id, player)
	local race = raceManager:getRaceById(id)
	if not race then
		return false
	end
	return race:addPlayer(player)
end

-- Находится ли игрок в какой-либо гонке
-- element player - игрок, для которого нужно проверить нахождение в гонке
-- возвращает boolean - находится ли игрок в гонке
function isPlayerInRace(player)
	if not isElement(player) then
		return false
	end
	return not not player:getData("race_id")
end

-- Возвращает id гонки, в которой находится игрок
-- element player - игрок
-- возвращает number - id гонки
function getPlayerRace(player)
	if not isElement(player) then
		return false
	end
	return player:getData("race_id")
end