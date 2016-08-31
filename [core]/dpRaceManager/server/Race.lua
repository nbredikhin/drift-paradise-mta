raceRoot = Element("race-root", "raceRoot")
local races = {}

-- Возможные состояния гонки
local RaceState = {
	waiting 	= "waiting",
	running 	= "running",
	ended 		= "ended"		
}

local function isRaceState(state)
	if not state then return false end
	return not not RaceState[state]
end 

function getPlayerRace(player)
	if player.parent.type == "race" then
		return races[player.parent.id]
	end
end

function getRaceByElement(element)
	if not isElement(element) then
		outputDebugString("getRaceByElement: bad race element '" .. tostring(element) .. "'")
		return false
	end
	if element.type ~= "race" then
		outputDebugString("getRaceByElement: bad race element '" .. tostring(element.type) .. "'")
		return false
	end
	return races[element.id]
end

-- Удалить игрока при уничтожении автомобиля
addEventHandler("onElementDestroy", root, function ()
	if source.type ~= "vehicle" then return end

	local player = source.controller
	if not isElement(player) then return end

	local race = getPlayerRace(player)
	if not race then return end
	
	race:removePlayer(player)
end)

-- Запретить выход игроков, находящихся в гонке, из автомобиля
addEventHandler("onVehicleStartExit", root, function (player)
	local race = getPlayerRace(player)
	if not race then return end
	cancelEvent()
end)

---------------------------------------------------------------
----------------------- Создание гонки ------------------------
---------------------------------------------------------------

local RACE_LOG_SERVER = true
local RACE_LOG_DEBUG = true
local RACE_LOG_FORMAT = "Race [%s]: %s"

local raceGamemodes = {
	default = RaceDefault,
	drift = RaceDrift,
	drag = RaceDrag,
	duel = RaceDuel
}

local RACE_SETTINGS = {
	separateDimension = false,
	gamemode = "default"
}

local RACE_MAP = {
	duration = 300,

	checkpoints = {},
	objects = {},
	spawnpoints = {}
}

Race = newclass "Race"

function Race:init(settings, map)
	-- Создать element гонки и добавить в таблицу гонок
	local id = raceRoot:getChildrenCount() + 1
	self.element = Element("race", "race_" .. tostring(id))
	self.element.parent = raceRoot
	races[self.element.id] = self

	-- Инициализация состояния гонки, загрузка настроек и карты
	self.state = ""
	self.settings 	= exports.dpUtils:extendTable(settings, RACE_SETTINGS)
	self.map 		= exports.dpUtils:extendTable(map, RACE_MAP)

	self.element:setData("Race.settings", self.settings)

	-- Выбор уникального dimension'а в зависимости от настроек
	if self.settings.separateDimension then
		self.dimension = id + 120000
	else
		self.dimension = 0
	end

	-- Маркер финиша
	local x, y, z = unpack(self.map.checkpoints[#self.map.checkpoints])
	if x and y and z then
		self.finishMarker = createMarker(x, y, z - 1, "cylinder", 7, 0, 0, 0, 0)
		self.finishMarker.dimension = self.dimension
		self.finishMarker.parent = self.element
	end

	-- Корректное удаление игрока из гонки при выходе с сервера
	addEventHandler("onPlayerQuit", self.element, function ()
		self:removePlayer(source)
	end)
	-- Удалить игрока при взрыве автомобиля
	addEventHandler("onVehicleExplode", self.element, function ()
		local player = vehicle:getData("Race.player")
		self:removePlayer(player)
	end)
	addEventHandler("onPlayerVehicleExit", self.element, function ()
		outputDebugString("Vehicle exit")
		self:removePlayer(source)
	end)
	addEventHandler("onMarkerHit", self.finishMarker, function (element)
		if element.type ~= "vehicle" then
			return
		end
		local player = element.controller
		if not isElement(player) then
			return
		end
		if player.parent == self.element then
			self:playerFinish(player)
		end
	end)

	self:setState(RaceState.waiting)

	local gamemodeClass = raceGamemodes[self.settings.gamemode]
	if not gamemodeClass then
		self:log("Failed to create race. Gamemode '" .. tostring(self.settings.gamemode) .. "' does not exist")
		self:destroy()
		return false
	end
	self.gamemode = gamemodeClass(self)
	self:log("Race created. Race ID: '" .. tostring(self.element.id) .. "'")
end

function Race:destroy()
	-- Гонка уже удалена
	if not isElement(self.element) then
		self:log("Failed to destroy race. It's already destroyed.")
		return false
	end
	self.isBeingDestroyed = true
	-- Принудительно финишировать гонку
	if self:getState() == RaceState.running then
		self:finish()
	end
	-- Удалить всех игроков из гонки
	for _, player in ipairs(self:getPlayers()) do
		self:removePlayer(player)
	end
	if isElement(self.finishMarker) then
		destroyElement(self.finishMarker)
	end
	-- Удалить саму гонку
	races[self.element.id] = nil
	self:log("Race destroyed")
	destroyElement(self.element)
	self.isBeingDestroyed = false
end

---------------------------------------------------------------
----------------------- Состояние гонки -----------------------
---------------------------------------------------------------

function Race:setState(state)
	if not check("Race:setState", "state", "string", state) then return false end
	if not isRaceState(state) then
		self:log("Failed to change race state. '" .. tostring(state) .."' is not a valid race state.")
		return false
	end

	self.state = state
	self.element:setData("Race.state", state)
	triggerClientEvent(self.element, "Race.stateChanged", self.element, self.state)
	return true
end

function Race:getState()
	return self.state
end

---------------------------------------------------------------
----------------------- Игроки в гонке ------------------------
---------------------------------------------------------------

function Race:addPlayer(player)
	if not check("Race:addPlayer", "player", "player", player) then return false end
	if not player:getData("_id") then
		self:log("Failed to add player. Player is not logged in")
		return false
	end
	-- Игрок не должен находиться в гонке
	if player.parent.type == "race" then
		self:log("Failed to add player. Player is in other race")
		return false
	end	
	-- Игрок должен быть в автомобиле
	if not player.vehicle then
		self:log("Failed to add player. Player must be in a vehicle")
		return false
	end
	-- Игрок должен быть за рулем
	if player.vehicle.controller ~= player then
		self:log("Failed to add player. Player must driving the vehicle")
		return false
	end
	-- В автомобиле должен быть только один игрок
	if exports.dpUtils:getVehicleOccupantsCount(player.vehicle) > 1 then
		self:log("Failed to add player. Player must be the only vehicle occupant")
		return false
	end

	player.vehicle.dimension = self.dimension
	player.vehicle.frozen = true
	player.vehicle:setData("Race.player", player)
	player.vehicle.parent = player

	player.parent = self.element
	player.dimension = self.dimension
	player:setData("Race.vehicle", player.vehicle)

	triggerClientEvent(player, "Race.addedToRace", self.element, self.settings, self.map)
	triggerClientEvent(self.element, "Race.playerAdded", player)

	self.gamemode:spawnPlayer(player)
	self:log("Player added: '" .. tostring(player.name) .. "'")
	return true
end

function Race:removePlayer(player)
	if not check("Race:removePlayer", "player", "player", player) then return false end
	-- Игрок должен находиться в этой гонке
	if player.parent.id ~= self.element.id then
		self:log("Failed to remove player. Player is not in this race")
		return false
	end

	-- На момент удаления игрок может быть не в машине
	local vehicle = player.vehicle
	if not vehicle then
		vehicle = player:getData("Race.vehicle")
	end
	if isElement(vehicle) then 
		vehicle.dimension = 0
		vehicle.frozen = false
		vehicle:removeData("Race.player")
		vehicle.parent = root
	end

	player.parent = root
	player.dimension = 0
	player:removeData("Race.finished")

	triggerClientEvent(player, "Race.removedFromRace", self.element)
	triggerClientEvent(self.element, "Race.playerRemoved", player)
	self:log("Player removed: '" .. tostring(player.name) .. "'")

	-- Удалить гонку при удалении всех игроков
	if not self.isBeingDestroyed and self:getState() ~= RaceState.waiting and #self:getPlayers() == 0 then
		self:destroy()
	end
	return true
end

function Race:getPlayers()
	return self.element:getChildren("player")
end

---------------------------------------------------------------
----------------------- Геймплей гонки ------------------------
---------------------------------------------------------------

local COUNTDOWN_DELAY = 3000

-- Запуск countdown'а
function Race:launch()
	-- Гонка не должна быть запущена
	if self:getState() ~= RaceState.waiting then
		self:log("Failed to launch race. It's already running or ended")
		return false
	end

	triggerClientEvent(self.element, "Race.launch", self.element)
	self.countdownTimer = setTimer(function() self:start() end, COUNTDOWN_DELAY, 1)
	self:log("Starting race...")
	return true
end

-- Старт гонки
function Race:start()
	-- Гонка не должна быть запущена
	if self:getState() ~= RaceState.waiting then
		self:log("Failed to start race. It's already running or ended")
		return false
	end	
	-- Гонка не должна быть без игроков
	if #self:getPlayers() == 0 then
		self:log("Failed to start race. No players in race")
		return false
	end
	-- Не был запущен countdown
	if not isTimer(self.countdownTimer) then
		self:log("Race must be started with Race:launch()")
		return false
	end
	
	killTimer(self.countdownTimer)
	self:setState(RaceState.running)
	self.durationTimer = setTimer(function() self:finish(true) end, self.map.duration * 1000, 1)
	triggerClientEvent(self.element, "Race.start", self.element)

	for _, player in ipairs(self:getPlayers()) do
		player.vehicle.frozen = false
	end

	self.gamemode:raceStarted()
	self:log("Race started")
	return true
end

-- Завершение гонки
function Race:finish(timeout)
	-- Гонка должна быть запущена
	if self:getState() ~= RaceState.running then
		self:log("Failed to finish race. Race is not running")
		return false
	end	

	self:setState(RaceState.ended)
	triggerClientEvent(self.element, "Race.finish", self.element)
	self.gamemode:raceFinished(timeout)
	self:log("Race finished")
	return true
end

function Race:playerFinish(player)
	if not check("Race:playerFinish", "player", "player", player) then return false end
	-- Игрок должен находиться в этой гонке
	if player.parent.id ~= self.element.id then
		self:log("Failed to finish player. Player is not in this race")
		return false
	end
	return self.gamemode:playerFinished(player)
end


---------------------------------------------------------------
--------------------------- Прочее ----------------------------
---------------------------------------------------------------

function Race:log(message)
	local id = "destroyed"
	if isElement(self.element) then
		id = self.element.id
	end
	local outputString = string.format(RACE_LOG_FORMAT, id, tostring(message))
	if RACE_LOG_SERVER then
		outputServerLog(outputString)
	end
	if RACE_LOG_DEBUG then
		outputDebugString(outputString)
	end
	return true
end