RaceManager = newclass("RaceManager")
addEvent("leaveRace", true)
addEvent("finishRace", true)
addEvent("updateRank", true)

function RaceManager:init()
	self.races = {}

	self:addEventHandler("onVehicleStartExit", root)
	self:addEventHandler("onPlayerQuit", root)

	self:addClientEventHandler("leaveRace")
	self:addClientEventHandler("finishRace")
	self:addClientEventHandler("updateRank")
end

function RaceManager:addEventHandler(eventName, attachTo)
	local raceManager = self
	addEventHandler(eventName, attachTo, function (...)
		raceManager:handleEvent(eventName, source, ...)
	end)
end

function RaceManager:addClientEventHandler(eventName)
	local raceManager = self
	addEventHandler(eventName, resourceRoot, function (...)
		raceManager:handleClientEvent(eventName, client, ...)
	end)
end

-- Добавить гонку в менеджер гонок и присвоить гонке уникальный id
-- Возвращает id, присвоенный гонке или false в случае неудачи
function RaceManager:addRace(race)
	if type(race) ~= "table" or not race:class() or race:class():name() ~= "Race" then
		outputDebugString("RaceManager: Bad argument #1 for 'addRace'. Expected 'Race', got '" .. tostring(race) .. "'")
		return false
	end

	-- Поиск свободного места в массиве гонок
	local added = false
	for i = 1, #self.races do
		if not self.races[i] then
			-- Найдено место, добавить гонку
			self.races[i] = race
			race.id = i
			added = true
		end 
	end
	-- Если не найдено место, добавить в конец
	if not added then
		table.insert(self.races, race)
		race.id = #self.races
	end	

	race.raceManager = self
	race:onAdded()
	return race.id
end

function RaceManager:getRaceById(id)
	if type(id) ~= "number" then
		return false
	end
	for i, race in ipairs(self.races) do
		if race.id == id then
			return race
		end
	end
	return false
end

-- Удалить гонку из менеджера гонок
function RaceManager:removeRace(race)
	for i, r in ipairs(self.races) do
		if r == race then
			self.races[i] = nil
			outputDebugString("Race removed: " .. tostring(race.id))
			return true
		end
	end
	-- Гонка не найдена
	return false
end

-- Перенаправление эвентов в гонки
function RaceManager:handleEvent(eventName, source, ...)
	if type(eventName) ~= "string" then
		return false
	end
	for i, race in ipairs(self.races) do
		local eventHandler = race[eventName .. "Handler"]
		if type(eventHandler) == "function" then
			eventHandler(race, source, ...)
		end
	end
	return true
end

function RaceManager:handleClientEvent(eventName, client, ...)
	if type(eventName) ~= "string" then
		return false
	end
	local raceId = client:getData("race_id")
	if type(raceId) ~= "number" then
		return 
	end
	local race = self:getRaceById(raceId)
	if not race then
		client:setData("race_id", false)
		return
	end

	local eventHandler = race[eventName .. "Handler"]
	if type(eventHandler) == "function" then
		eventHandler(race, client, ...)
	end	
end
