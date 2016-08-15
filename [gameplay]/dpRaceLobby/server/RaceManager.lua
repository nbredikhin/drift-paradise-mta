RaceManager = {}

local pendingRaces = {}
local racesCounter = 1

local function removePendingRace(id)
	if type(id) ~= "number" then
		return false
	end
	for i = 1, #pendingRaces do
		if pendingRaces[i].id == id then
			table.remove(pendingRaces, i)
			return true
		end
	end
	return false
end

local function getPendingRace(id)
	if type(id) ~= "number" then
		return false
	end
	for i = 1, #pendingRaces do
		if pendingRaces[i].id == id then
			return pendingRaces[i]
		end
	end
	return false
end

local function cancelPendingRace(id, cancelPlayer)
	if type(id) ~= "number" then
		return false
	end
	local race = getPendingRace(id)
	if not race then
		return false
	end
	for i, player in ipairs(race.players) do
		if isElement(player) then
			player:setData("MatchmakingRaceId", false)
			triggerClientEvent(player, "dpRaceLobby.raceCancelled", resourceRoot, cancelPlayer)
		end
	end
	removePendingRace(id)
	return true
end

function RaceManager.raceReady(mapName, playersList)
	local raceId = racesCounter
	table.insert(pendingRaces, {
		id = raceId, 
		map = mapName, 
		players = playersList,
		readyCount = 0
	})
	racesCounter = racesCounter + 1
	setTimer(cancelPendingRace, GlobalConfig.PENDING_RACE_TIMEOUT, 1, raceId)

	for i, player in ipairs(playersList) do
		player:setData("MatchmakingRaceId", raceId)
		triggerClientEvent(player, "dpRaceLobby.raceFound", resourceRoot)
	end	
end

function RaceManager.startRace(race)
	for i, player in ipairs(race.players) do
		player:setData("MatchmakingRaceId", false)
		triggerClientEvent(player, "dpRaceLobby.raceStart", resourceRoot)
	end

	-- TODO: Создать гонку
	outputConsole("RACE START:")
	for i, p in ipairs(race.players) do
		outputConsole(tostring(i) .. ". " .. tostring(p.name))
	end
end

addEvent("dpRaceLobby.cancelSearch", true)
addEventHandler("dpRaceLobby.cancelSearch", resourceRoot, function ()
	cancelPendingRace(client:getData("MatchmakingRaceId"), client)
end)

addEvent("dpRaceLobby.acceptRace", true)
addEventHandler("dpRaceLobby.acceptRace", resourceRoot, function ()
	local race = getPendingRace(client:getData("MatchmakingRaceId"))
	if not race then
		return 
	end
	race.readyCount = race.readyCount + 1
	if race.readyCount >= #race.players then
		RaceManager.startRace(race)
	else
		for i, player in ipairs(race.players) do 
			if isElement(player) then
				triggerClientEvent(player, "dpRaceLobby.updateReadyCount", resourceRoot, race.readyCount, #race.players)
			end
		end		
	end
end)