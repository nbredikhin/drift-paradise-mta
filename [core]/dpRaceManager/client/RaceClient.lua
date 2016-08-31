RaceClient = {}
RaceClient.isActive = false
RaceClient.raceElement = nil
RaceClient.gamemode = nil

RaceClient.settings = {}
RaceClient.map = {}

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

local function onRemovedFromRace()
	outputDebugString("RaceClient: Client removed from race. Stopping race...")
	RaceClient.stopRace()
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

	-- Создание объектов карты
	if not RaceClient.map.objects then
		RaceClient.map.objects = {}
	end
	for i, o in ipairs(RaceClient.map.objects) do
		createObject(unpack(o)).dimension = localPlayer.dimension
	end

	-- Обработка событий
	addEventHandler("Race.removedFromRace", raceElement, onRemovedFromRace)
	addEventHandler("Race.stateChanged", 	raceElement, onStateChanged)

	local gamemode = RaceGamemode()
	gamemode:addEventHandler("Race.launch", 		raceElement, gamemode.raceLaunched)
	gamemode:addEventHandler("Race.start", 			raceElement, gamemode.raceStarted)
	gamemode:addEventHandler("Race.finish", 		raceElement, gamemode.raceFinished)
	gamemode:addEventHandler("Race.playerFinished", raceElement, gamemode.playerFinished)
	gamemode:addEventHandler("Race.playerAdded", 	raceElement, gamemode.playerAdded)
	gamemode:addEventHandler("Race.playerRemoved", 	raceElement, gamemode.playerRemoved)
	RaceClient.gamemode = gamemode
end

function RaceClient.stopRace()
	if not RaceClient.isActive then
		outputDebugString("RaceClient: Failed to stop race. Race is not active")
		return false
	end
	RaceClient.isActive = false

	removeEventHandler("Race.removedFromRace", RaceClient.raceElement, onRemovedFromRace)
	removeEventHandler("Race.stateChanged", RaceClient.raceElement, onStateChanged)
	RaceClient.gamemode:removeEventHandlers()

	Countdown.stop()
	RaceTimer.stop()
	RaceCheckpoints.stop()

	for i, object in ipairs(resource:getDynamicElementRoot():getChildren("object")) do
		destroyElement(object)
	end

	RaceClient.raceElement = nil
	RaceClient.settings = nil
	RaceClient.map = nil
end	