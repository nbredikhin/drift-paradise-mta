Matchmaking = {}
local ROOM_TIME_NOPLAYERS = 20
local ROOM_TIME_ENOUGH_PLAYERS = 10
local rooms = {}
local players = {}
local playersCount = {} 

local function findRoom(rank, gamemode)
	for i, room in ipairs(rooms) do
		if room.rank == rank and room.gamemode == gamemode then
			return room
		end
	end
	return false
end

local function createRoom(rank, gamemode)
	local room = {
		rank = rank,
		gamemode = gamemode,
		time = ROOM_TIME_NOPLAYERS,
		players = {}
	}
	table.insert(rooms, room)
	return room
end

local function removeRoom(room)
	if not room then
		return
	end
	for i, r in ipairs(rooms) do
		if r == room then
			table.remove(rooms, i)
			return true
		end
	end
	return false
end

local function getRoomPlayers(room)
	if not room then
		return false
	end
	local players = {}
	for player in pairs(room.players) do
		table.insert(players, player)
	end
	return players
end

local function updateRoom(room)
	if not room then
		return
	end
	room.time = room.time - 1
	--outputDebugString("Room time: " .. tostring(room.time))	
	--outputDebugString("Players count: " .. tostring(#getRoomPlayers(room)))
	if room.time <= 0 then		
		local playersList = getRoomPlayers(room)
		if #playersList < GlobalConfig.MATCHMAKING_MIN_PLAYERS then
			room.time = ROOM_TIME_NOPLAYERS
		else
			for i, p in ipairs(playersList) do
				Matchmaking.removePlayer(p)
			end
			RaceManager.raceReady(playersList, room.gamemode, room.rank)
			removeRoom(room)
		end
	end
end

function Matchmaking.addPlayer(player, gamemode)
	if not isElement(player) then
		return false
	end
	if type(gamemode) ~= "string" then
		return false
	end
	if not player.vehicle then
		return false
	end
	if players[player] then
		return false
	end
	local vehicleOwner = player.vehicle:getData("owner_id")
	local playerId = player:getData("_id")
	if not vehicleOwner or not playerId or vehicleOwner ~= playerId then
		return false
	end
	local rank = exports.dpShared:getVehicleClass(player.vehicle.model)

	local room = findRoom(rank, gamemode)
	if not room then
		room = createRoom(rank, gamemode)
	end
	room.players[player] = true
	players[player] = room
	local roomPlayers = getRoomPlayers(room)
	if #roomPlayers >= GlobalConfig.MATCHMAKING_MIN_PLAYERS and #roomPlayers < GlobalConfig.MATCHMAKING_MAX_PLAYERS then
		if room.time > ROOM_TIME_ENOUGH_PLAYERS then
			room.time = ROOM_TIME_ENOUGH_PLAYERS
		end
	elseif #roomPlayers >= GlobalConfig.MATCHMAKING_MAX_PLAYERS then
		room.time = 0
		updateRoom(room)
	end

	if not playersCount[room.gamemode] then
		playersCount[room.gamemode] = 0
	end
	playersCount[room.gamemode] = playersCount[room.gamemode] + 1
	return true
end

function Matchmaking.removePlayer(player)
	if not player then
		return false
	end
	if not players[player] then
		return false
	end

	local room = players[player]
	if room then
		room.players[player] = nil
	end
	players[player] = nil
	local roomPlayers = getRoomPlayers(room)
	if #roomPlayers < GlobalConfig.MATCHMAKING_MIN_PLAYERS and #roomPlayers > 0 then
		room.time = ROOM_TIME_NOPLAYERS
	elseif #roomPlayers <= 0 then
		removeRoom(room)
	end

	if not playersCount[room.gamemode] then
		playersCount[room.gamemode] = 0
	end
	playersCount[room.gamemode] = playersCount[room.gamemode] - 1	
	return true
end

setTimer(function ()
	for i, room in ipairs(rooms) do
		updateRoom(room)
	end

	--outputDebugString("Rooms count: " .. tostring(#rooms))
end, 1000, 0)

local addClientEventHandler = function(event, handler) 
	addEvent(event, true)
	return addEventHandler(event, resourceRoot, handler)
end

addClientEventHandler("dpRaceLobby.startSearch", function (gamemode)
	Matchmaking.addPlayer(client, gamemode)
end)

addClientEventHandler("dpRaceLobby.cancelSearch", function ()
	Matchmaking.removePlayer(client)
end)

addEventHandler("onPlayerQuit", root, function ()
	Matchmaking.removePlayer(source)
end)

addEvent("dpRaceLobby.countPlayers", true)
addEventHandler("dpRaceLobby.countPlayers", resourceRoot, function (gamemode)
	local count = playersCount[gamemode]
	if not count then
		count = 0
	end
	triggerClientEvent(client, "dpRaceLobby.countPlayers", resourceRoot, count)
end)