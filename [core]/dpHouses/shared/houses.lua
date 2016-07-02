local DEBUG_ALWAYS_SPAWN_AT_HOTEL = true

local defaultHouse = {
	garage = {
		position = Vector3(1823.487, -1411.959, 13.602),
		rotation = Vector3(0, 0, 270),
	},
	position = Vector3 {x = 1787.025, y = -1384.408, z = 15.393},
	rotation = Vector3(0, 0, 90),
	dimension = 0,
	interior = 0
}

function hasPlayerHouse(player)
	return not not player:getData("house_id")
end

function getHouseDimension(houseId)
	if type(houseId) ~= "number" then
		return false
	end
	return 50000 + houseId
end

function getPlayerHouseLocation(player)
	if not isElement(player) then
		return false
	end
	if not hasPlayerHouse(player) then
		return defaultHouse
	end
	local houseData = player:getData("house_data")
	local houseId = player:getData("house_id")
	if not houseId or type(houseData) ~= "table" then
		return false
	end
	return {
		garage = {
			position = Vector3(unpack(houseData.garage)),
			rotation = Vector3(0, 0, houseData.garage_rotation)
		},
		position = Vector3(unpack(houseData.spawn)),
		rotation = Vector3(0, 0, houseData.spawn_rotation),
		dimension = getHouseDimension(houseId),
		interior = houseData.interior
	}
end