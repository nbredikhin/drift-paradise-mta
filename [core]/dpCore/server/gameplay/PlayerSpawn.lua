PlayerSpawn = {}
local DEBUG_ALWAYS_SPAWN_AT_HOTEL = true

local hotelsPositions = {
	{x = 1787.025, y = -1384.408, z = 15.393}
}

local function getPlayerHotelLocation(player)
	local hotelID = 1
	local pos = hotelsPositions[hotelID]
	return {interior = 0, position = Vector3(pos.x, pos.y, pos.z)}
end

local function getPlayerSpawnLocation(player)
	local playerHasHome = false
	-- Если у игрока нет дома, спавн в отеле
	if not playerHasHome or DEBUG_ALWAYS_SPAWN_AT_HOTEL then
		return getPlayerHotelLocation(player)
	end

	-- Спавн в доме
	local position = 0, 0, 10
	return {interior = 0, position = position}
end

function PlayerSpawn.spawn(player)
	if not isElement(player) then
		return false
	end
	local location = getPlayerSpawnLocation(player)
	player:spawn(location.position)
	player:setCameraTarget()
	player:fadeCamera(true, 3)
	player.model = player:getData("skin")
	return true
end