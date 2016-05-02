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

function getPlayerVehicles(player)
	if not isElement(player) then
		return false
	end
	local ownerId = player:getData("_id")
	return UserVehicles.getVehicles(ownerId)
end

function getVehicleById(vehicleId)
	if not vehicleId then
		return 
	end
	return UserVehicles.getVehicle(vehicleId)
end

function addPlayerVehicle(player, model)
	if not isElement(player) then
		return false
	end	
	return UserVehicles.addVehicle(player:getData("_id"), model)
end