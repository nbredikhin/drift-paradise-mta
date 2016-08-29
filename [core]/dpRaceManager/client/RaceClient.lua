RaceClient = {}
RaceClient.isActive = false
RaceClient.raceElement = nil
RaceClient.gamemode = nil

addEvent("Race.addedToRace", true)
addEvent("Race.removedFromRace", true)

addEventHandler("Race.addedToRace", root, function ()
	outputDebugString("RaceClient: Client added to race. Starting race...")
	RaceClient.startRace(source)
end)

-- Игрок финишировал
local function onPlayerFinished()
	if source ~= localPlayer then
		return
	end
end

function onRemovedFromRace()
	outputDebugString("RaceClient: Client removed from race. Stopping race...")
	RaceClient.stopRace()
end

function RaceClient.startRace(raceElement)
	if not check("RaceClient.startRace", "raceElement", "element", raceElement) then return false end
	if RaceClient.isActive then
		outputDebugString("RaceClient: Failed to start race. Race is already active")
		return false
	end
	RaceClient.isActive = true
	RaceClient.raceElement = raceElement

	addEventHandler("Race.removedFromRace", raceElement, onRemovedFromRace)

	local gamemode = RaceGamemode()
	gamemode:addEventHandler("Race.launch", raceElement, gamemode.raceLaunched)
	gamemode:addEventHandler("Race.start", raceElement, gamemode.raceStarted)
	gamemode:addEventHandler("Race.finish", raceElement, gamemode.raceFinished)
	gamemode:addEventHandler("Race.playerFinished", raceElement, gamemode.playerFinished)
end

function RaceClient.stopRace()
	if not RaceClient.isActive then
		outputDebugString("RaceClient: Failed to stop race. Race is not active")
		return false
	end
	RaceClient.isActive = false
	RaceClient.raceElement = nil

	removeEventHandler("Race.removedFromRace", raceElement, onRemovedFromRace)
	RaceClient.gamemode:removeEventHandlers()

	Countdown.stop()
end	