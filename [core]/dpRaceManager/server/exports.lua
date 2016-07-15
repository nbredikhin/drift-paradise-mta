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
-- возвращает boolean - результат выполнения
function raceLoadMap(id, map)
	local race = raceManager:getRaceById(id)
	if not race then
		return false
	end
	return race:loadMap(map)
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