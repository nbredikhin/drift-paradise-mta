addEvent("dpGarage.saveCar", true)
addEventHandler("dpGarage.saveCar", resourceRoot, function (garageVehicleIndex, tuning, stickers)
	if client:getData("dpCore.state") ~= "garage" then
		triggerClientEvent(client, "dpGarage.saveCar", resourceRoot, false)
		return
	end

	local playerVehicles = exports.dpCore:getPlayerVehicles(client)
	if type(playerVehicles) ~= "table" or #playerVehicles == 0 then
		triggerClientEvent(client, "dpGarage.saveCar", resourceRoot, false)
		return
	end
	local vehicleTable = playerVehicles[garageVehicleIndex]
	if not vehicleTable then
		triggerClientEvent(client, "dpGarage.saveCar", resourceRoot, false)
		return
	end
	exports.dpCore:updateVehicleTuning(vehicleTable._id, tuning, {})
	triggerClientEvent(client, "dpGarage.saveCar", resourceRoot, true)
end)