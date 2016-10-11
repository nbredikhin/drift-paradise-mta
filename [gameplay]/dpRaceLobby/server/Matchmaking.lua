Matchmaking = {}

local playersInSearch = {}
local playersCheckTimer

local addClientEventHandler = function(event, handler) 
	addEvent(event, true)
	return addEventHandler(event, resourceRoot, handler)
end

addClientEventHandler("dpRaceLobby.startSearch", function ()
	Matchmaking.addPlayer(client)
end)

addClientEventHandler("dpRaceLobby.cancelSearch", function ()
	Matchmaking.removePlayer(client)
end)

local function delayPlayersCheck()
	if isTimer(playersCheckTimer) then
		return
	end
	playersCheckTimer = setTimer(Matchmaking.checkPlayers, GlobalConfig.MATCHMAKING_GAME_CHECK_INTERVAL, 1)
end

function Matchmaking.addPlayer(player)
	if not isElement(player) then
		return false
	end
	if playersInSearch[player] then
		return false
	end
	if not player.vehicle then
		return false
	end
	local vehicleOwner = player.vehicle:getData("owner_id")
	local playerId = player:getData("_id")
	if not vehicleOwner or not playerId or vehicleOwner ~= playerId then
		return false
	end
	local vehicleClass = exports.dpShared:getVehicleClass(player.vehicle.model)

	playersInSearch[player] = {
		class = vehicleClass,
		addedAt = getRealTime().timestamp
	}
	delayPlayersCheck()
	return true
end

function Matchmaking.removePlayer(player)
	if not player then
		return false
	end
	if not playersInSearch[player] then
		return false
	end

	playersInSearch[player] = nil

	return true
end

function Matchmaking.checkPlayers()
	local playersByClass = {{}, {}, {}, {}, {}}

	local playersCount = 0
	for player, info in pairs(playersInSearch) do
		if not playersByClass[info.class] then
			playersByClass[info.class] = {}
		end
		table.insert(playersByClass[info.class], player)
		playersCount = playersCount + 1
	end
	root:setData("MatchmakingSearchingPlayersCount", playersCount)

	for class, players in ipairs(playersByClass) do
		if #players >= GlobalConfig.MATCHMAKING_MIN_PLAYERS then
			table.sort(players, function(player1, player2)
				return player1:getData("xp") < player2:getData("xp")
			end)	

			local count = math.min(#players, GlobalConfig.MATCHMAKING_MAX_PLAYERS)
			local matchPlayers = {}
			outputDebugString("Matchmaking: creating game (player count: " .. tostring(count) .. ")")
			for i = 1, count do 
				local player = players[i]
				Matchmaking.removePlayer(player)
				table.insert(matchPlayers, player)
			end
			RaceManager.raceReady(matchPlayers)
		end
	end
end