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
	exports.dpCore:updateVehicleTuning(vehicleTable._id, tuning, stickers)
end)

addEvent("dpGarage.buy", true)
addEventHandler("dpGarage.buy", resourceRoot, function(price, level)
	if type(level) ~= "number" or type(price) ~= "number" then
		triggerClientEvent("dpGarage.buy", resourceRoot, false)
	end

	if level > client:getData("level") then
		triggerClientEvent("dpGarage.buy", resourceRoot, false)
		return
	end
	local money = client:getData("money")
	if type(money) ~= "number" or money < price then
		triggerClientEvent("dpGarage.buy", resourceRoot, false)
		return 
	end
	client:setData("money", money - price)

	triggerClientEvent("dpGarage.buy", resourceRoot, true)
end)