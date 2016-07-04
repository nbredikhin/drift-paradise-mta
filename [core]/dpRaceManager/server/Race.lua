--- Класс гонки
-- @module dpRaceManager.Race
-- @author Wherry

Race = newclass("Race")

function Race:init()
	self.state = "no_map"
	self.players = {}
	self.settings = {}
end

--- Загрузка карты в гонку
-- @tparam table map гонка
function Race:loadMap(map)
	if type(map) ~= "table" then
		return
	end
	race.state = "waiting"
	return true
end

--- Добавление игрока в гонку
function Race:addPlayer(player)
	if not isElement(player) or player.type ~= "player" then
		return false
	end
	table.insert(self.players, player)
	return true
end

--- Проверка на нахождение игрока в гонке
function Race:isPlayerIn(player)
	if not isElement(player) or player.type ~= "player" then
		return false
	end	
	for i, p in ipairs(self.players) do
		if p == player then
			return true, i
		end
	end
	return false
end

--- Добавление нескольких игроков в гонку
function Race:addPlayers(playersTable)
	if type(playersTable) ~= "table" then
		return false
	end

	for i, player in ipairs(playersTable) do
		self:addPlayer(player)
	end
	return true
end

--- Удаление игрока из гонки
function Race:removePlayer(player)
	if not isElement(player) or player.type ~= "player" then
		return false
	end

	for i, p in ipairs(self.players) do
		if p == player then
			table.remove(self.players, i)
			return true
		end
	end
	return false
end