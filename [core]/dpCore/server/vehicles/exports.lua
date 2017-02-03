function spawnVehicle(...)
	return VehicleSpawn.spawn(...)
end

function returnVehicleToGarage(vehicle)
	return VehicleSpawn.returnToGarage(vehicle)
end

function returnPlayerVehiclesToGarage(player)
	if not isElement(player) then
		return false
	end
	local ownerId = player:getData("_id")
	return VehicleSpawn.returnUserVehiclesToGarage(ownerId)
end

function isPlayerOwningVehicle(...)
	return VehicleSpawn.isPlayerOwningVehicle(...)
end

function updateVehicle(...)
	return UserVehicles.updateVehicle(...)
end

function updateVehicleTuning(...)
	return VehicleTuning.updateVehicleTuning(...)
end

function getPlayerVehicles(player)
	if not isElement(player) then
		return false
	end
	local ownerId = player:getData("_id")
	return UserVehicles.getVehicles(ownerId)
end

function getPlayerVehiclesAsync(player, eventName)
	if not isElement(player) then
		return false
	end
	local callerRoot = sourceResourceRoot
	local ownerId = player:getData("_id")
	return UserVehicles.getVehicles(ownerId, function (result)
		triggerEvent(eventName, callerRoot, player, result)
	end)
end

function getPlayerSpawnedVehicles(player)
	return VehicleSpawn.getPlayerSpawnedVehicles(player)
end

function getVehicleById(vehicleId)
	if not vehicleId then
		return
	end
	return UserVehicles.getVehicle(vehicleId)
end

function updatePlayerVehiclesCount(player)
	-- Количество автомобилей игрока
	UserVehicles.getVehiclesIds(player:getData("_id"), function (result)
		if type(result) == "table" then
			player:setData("garage_cars_count", #result)
		end
	end)
end

function getVehicleOwnerAsync(vehicleId, eventName, ...)
	if not vehicleId then
		return
	end
	local args = {...}
	local callerRoot = sourceResourceRoot
	return UserVehicles.getVehicleOwner(vehicleId, function (result)
		triggerEvent(eventName, callerRoot, result[1].owner_id, unpack(args))
	end)
end

function addPlayerVehicle(player, model)
	if not isElement(player) then
		return false
	end
	local result = UserVehicles.addVehicle(player:getData("_id"), model)
	updatePlayerVehiclesCount(player)
	return result
end

-- Удаляет автомобиль из БД
function removePlayerVehicle(player, vehicleId)
	if not isElement(player) then
		return false
	end
	if not vehicleId then
		return false
	end
	-- Удалить автомобиль
	local result = UserVehicles.removeVehicle(vehicleId)
	updatePlayerVehiclesCount(player)
	return not not result
end

function removePlayerVehicleAsync(player, vehicleId, eventName)
	if not isElement(player) then
		return false
	end
	if not vehicleId then
		return false
	end
	local callerRoot = sourceResourceRoot
	-- Удалить автомобиль
	local result = UserVehicles.removeVehicle(vehicleId, function (result)
		updatePlayerVehiclesCount(player)
		triggerEvent(eventName, callerRoot, player, result)
	end)

	return not not result
end
