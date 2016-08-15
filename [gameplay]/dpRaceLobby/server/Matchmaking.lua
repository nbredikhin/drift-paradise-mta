Matchmaking = {}

local pendingPlayersList = {}
local mapCheckTimers = {}
local pendingPlayersCount = 0

setTimer(function()
	local count = 0
	local players = {}
	for mapName, players in pairs(pendingPlayersList) do
		for p in pairs(players) do
			if not players[p] then
				players[p] = true
				count = count + 1
			end
		end
	end	
	root:setData("MatchmakingSearchingPlayersCount", count)
end, 15000, 0)

local function removePendingPlayer(player)
	for mapName, players in pairs(pendingPlayersList) do
		for p in pairs(players) do
			if p == player then
				pendingPlayersList[mapName][p] = nil
			end
		end
	end
end

function Matchmaking.performMapCheck(mapName, rank)
	--outputDebugString("performMapCheck: " .. tostring(mapName) .. " " .. tostring(rank))
	if not mapName or not rank then
		return false
	end
	if not pendingPlayersList[mapName] then
		return false
	end

	local players = {}
	for player, info in pairs(pendingPlayersList[mapName]) do
		if info.rank == rank then
			table.insert(players, player)
		end
	end
	if #players < GlobalConfig.MATCHMAKING_MIN_PLAYERS then
		--outputDebugString("Map check failed: Not enough players")
		return
	end
	table.sort(players, function(player1, player2)
		return player1:getData("xp") < player2:getData("xp")
	end)	
	local racePlayers = {}
	for i, player in ipairs(players) do
		table.insert(racePlayers, player)
		removePendingPlayer(player)
		if #racePlayers >= GlobalConfig.MATCHMAKING_MAX_PLAYERS then
			break
		end		
	end

	RaceManager.raceReady(mapName, racePlayers)

	if #players >= GlobalConfig.MATCHMAKING_MIN_PLAYERS then
		Matchmaking.scheduleMapCheck(mapName, rank)
	end	
end

function Matchmaking.scheduleMapCheck(mapName, rank)
	if not mapName or not rank then
		return false
	end
	local key = tostring(mapName) .. "_" .. tostring(rank)
	if isTimer(mapCheckTimers[key]) then
		killTimer(mapCheckTimers[key])
	end
	mapCheckTimers[key] = setTimer(
		Matchmaking.performMapCheck, 
		GlobalConfig.MATCHMAKING_GAME_CHECK_INTERVAL, 
		1, 
		mapName, 
		rank
	)
	--outputDebugString("scheduleMapCheck: " .. tostring(mapName))
end

local function addPlayerToMap(player, mapName)
	if not isElement(player) then
		return false
	end
	local rank = "someRank" -- TODO: Получить ранг машины

	if not pendingPlayersList[mapName] then
		pendingPlayersList[mapName] = {}
	end
	pendingPlayersList[mapName][player] = {
		rank = rank
	}
	Matchmaking.scheduleMapCheck(mapName, rank)
	--outputDebugString("addPlayerToMap: " .. tostring(mapName))
end

local function addPendingPlayer(player, mapsList)	
	if not isElement(player) then
		return false
	end
	if not player:getData("xp") then
		return false
	end
	if type(mapsList) ~= "table" or #mapsList == 0 then
		--outputDebugString("addPendingPlayer: Expected 'table', got '" .. type(mapsList) .. "'")
		return false
	end
	for i, mapName in ipairs(mapsList) do
		if type(mapName) == "string" then
			addPlayerToMap(player, mapName)
		end
	end
	return true
end

addEvent("dpRaceLobby.startSearch", true)
addEventHandler("dpRaceLobby.startSearch", resourceRoot, function (mapsList)
	--outputDebugString(type(mapsList) .. " " .. tostring(#mapsList))
	addPendingPlayer(client, mapsList)
end)

addEvent("dpRaceLobby.cancelSearch", true)
addEventHandler("dpRaceLobby.cancelSearch", resourceRoot, function ()
	removePendingPlayer(client)
end)