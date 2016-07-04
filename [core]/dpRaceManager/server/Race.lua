--- Класс гонки
-- @module dpRaceManager.Race
-- @author Wherry

local DEFAULT_RACE_DURATION = 300

Race = newclass("Race")

function Race:init()
	self.state = "no_map"
	self.players = {}
	self.settings = {
		duration = 10
	}
	self.dimension = 0
	self.gameplay = RaceGameplay(self)
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
	if player:getData("race_id") then
		outputDebugString("Player '" .. tostring(player.name) .. "' is already in other race")
		return false
	end
	table.insert(self.players, player)
	player:setData("race_id", self.id)
	self.gameplay:onPlayerJoin(player)
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
	-- Добавление игроков из списка в гонку
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
	-- Если игрок не находится в гонке
	if not player:getData("race_id") then
		outputDebugString("Race:removePlayer - player is not in race")
		return false
	end
	-- Если игрок находится в другой гонке
	if player:getData("race_id") ~= self.id then
		outputDebugString("Race:removePlayer - player is in another race")
		return false
	end

	-- Удалить игрока
	for i, p in ipairs(self.players) do
		if p == player then
			self.gameplay:onPlayerLeave(player)
			player:removeData("race_id")
			table.remove(self.players, i)

			if #self.players == 0 then
				self.raceManager:removeRace(self)
			end	
			return true
		end
	end
	return false
end

--- Запуск гонки
function Race:start()
	self.gameplay:onRaceStart()

	local duration = self.settings.duration
	if type(self.settings.duration) ~= "number" then
		duration = DEFAULT_RACE_DURATION
	end

	local race = self
	self.durationTimer = setTimer(function()
		race:onTimeout()
	end, duration * 1000, 1)

	race.state = "running"
end

function Race:playerFinish(player)
	if not isElement(player) or player.type ~= "player" then
		return false
	end	
	self:removePlayer(player)
end

-- Когда время вышло
function Race:onTimeout()
	outputDebugString("Race timeout")
	for i, player in ipairs(self.players) do
		self:playerFinish(player)
	end
end

function Race:onVehicleStartExit(vehicle, player)
	self:playerFinish(player)
end