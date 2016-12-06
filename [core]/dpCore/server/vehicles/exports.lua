function spawnVehicle(...)
	return VehicleSpawn.spawn(...)
end

function returnVehicleToGarage(vehicle)
	return VehicleSpawn.returnToGarage(vehicle)
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
