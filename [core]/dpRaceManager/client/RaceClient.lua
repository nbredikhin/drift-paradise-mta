RaceClient = {}
RaceClient.isActive = false
RaceClient.raceElement = nil
RaceClient.gamemode = nil

RaceClient.settings = {}
RaceClient.map = {}

local raceDimension = 0

local UPDATE_INTERVAL = 1000
local updateTimer

addEvent("Race.addedToRace", true)
addEvent("Race.stateChanged", true)
addEvent("Race.removedFromRace", true)

addEventHandler("Race.addedToRace", root, function (settings, map)
	outputDebugString("RaceClient: Client added to race. Starting race...")
	RaceClient.startRace(source, settings, map)
end)

local function onStateChanged(state)
	-- dunno
end

local function update()
	RaceClient.gamemode:updatePosition()
end

local function onRemovedFromRace()
	outputDebugString("RaceClient: Client removed from race. Stopping race...")
	RaceClient.stopRace()
end

function RaceClient.checkpointHit(checkpointId)
	if not RaceClient.isActive then
		return false
	end
	RaceClient.gamemode:checkpointHit(checkpointId)
end

function RaceClient.clientFinished()
	if not RaceClient.isActive then
		return false
	end
	RaceClient.gamemode:clientFinished()
end

function RaceClient.leaveRace()
	if not RaceClient.isActive then
		return false
	end
	triggerServerEvent("Race.clientLeave", RaceClient.raceElement)
end

function RaceClient.startRace(raceElement, settings, map)
	if not check("RaceClient.startRace", "raceElement", "element", raceElement) then return false end
	if not check("RaceClient.startRace", "settings", "table", settings) then return false end
	if not check("RaceClient.startRace", "map", "table", map) then return false end
	if RaceClient.isActive then
		outputDebugString("RaceClient: Failed to start race. Race is already active")
		return false
	end
	RaceClient.isActive = true
	RaceClient.raceElement = raceElement
	RaceClient.settings = settings
	RaceClient.map = map

	RaceCheckpoints.start(RaceClient.map.checkpoints)

	raceDimension = localPlayer.dimension

	-- Создание объектов карты
	if not RaceClient.map.objects then
		RaceClient.map.objects = {}
	end
	for i, o in ipairs(RaceClient.map.objects) do
		createObject(unpack(o)).dimension = raceDimension
	end
	-- Перенос маппинга в dimension гонки
	if raceDimension ~= 0 then
		for i, object in ipairs(getElementsByType("object")) do
			if object.dimension == 0 then
				object.dimension = raceDimension
			end 
		end
	end

	-- Обработка событий
	addEventHandler("Race.removedFromRace", RaceClient.raceElement, onRemovedFromRace)
	addEventHandler("Race.stateChanged", 	RaceClient.raceElement, onStateChanged)
	addEventHandler("onClientElementDestroy", RaceClient.raceElement, RaceClient.stopRace)

	local gamemode = RaceGamemode()
	gamemode:addEventHandler("Race.launch", 		RaceClient.raceElement, gamemode.raceLaunched)
	gamemode:addEventHandler("Race.start", 			RaceClient.raceElement, gamemode.raceStarted)
	gamemode:addEventHandler("Race.finish", 		RaceClient.raceElement, gamemode.raceFinished)
	gamemode:addEventHandler("Race.playerFinished", RaceClient.raceElement, gamemode.playerFinished)
	gamemode:addEventHandler("Race.playerAdded", 	RaceClient.raceElement, gamemode.playerAdded)
	gamemode:addEventHandler("Race.playerRemoved", 	RaceClient.raceElement, gamemode.playerRemoved)
	RaceClient.gamemode = gamemode

	updateTimer = setTimer(update, UPDATE_INTERVAL, 0)

	-- Скрыть интерфейс
	local guiToHide = { "dpMainPanel", "dpGiftsPanel", "dpTabPanel", "dpWorldMap" }
	for i, name in ipairs(guiToHide) do
		if exports[name].setVisible then
			exports[name]:setVisible(false)
		end
	end
	localPlayer:setData("activeUI", "raceUI")
	bindKey("F1", "down", QuitPrompt.toggle)
	bindKey("f", "down", QuitPrompt.toggle)
	outputDebugString("Client race started")
end

function RaceClient.getPlayers()
	if not RaceClient.isActive then
		outputDebugString("RaceClient.getPlayers: Race is not active")
		return false
	end
	if not isElement(RaceClient.raceElement) then
		return false
	end
	return RaceClient.raceElement:getChildren("player")
end

function RaceClient.stopRace()
	if not RaceClient.isActive then
		outputDebugString("RaceClient: Failed to stop race. Race is not active")
		return false
	end
	RaceClient.isActive = false

	removeEventHandler("Race.removedFromRace", RaceClient.raceElement, onRemovedFromRace)
	removeEventHandler("Race.stateChanged", RaceClient.raceElement, onStateChanged)
	removeEventHandler("onClientElementDestroy", RaceClient.raceElement, RaceClient.stopRace)
	RaceClient.gamemode:removeEventHandlers()

	Countdown.stop()
	RaceTimer.stop()
	RaceCheckpoints.stop()

	for i, object in ipairs(resource:getDynamicElementRoot():getChildren("object")) do
		destroyElement(object)
	end
	-- Перенос маппинга обратно в нулевой dimension
	if raceDimension ~= 0 then
		for i, object in ipairs(getElementsByType("object")) do
			if object.dimension == raceDimension then
				object.dimension = 0
			end 
		end
	end

	RaceClient.raceElement = nil
	RaceClient.settings = nil
	RaceClient.map = nil
	raceDimension = 0

	if isTimer(updateTimer) then
		killTimer(updateTimer)
	end
	
	-- Интерфейс
	localPlayer:setData("activeUI", false)

	unbindKey("F1", "down", QuitPrompt.toggle)
	unbindKey("f", "down", QuitPrompt.toggle)
	
	outputDebugString("Client race stopped")
end	