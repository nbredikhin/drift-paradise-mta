addEvent("onOwnerReceived", false)
addEventHandler("onOwnerReceived", resourceRoot, function (owner_id, player, vehicleId, tuning, stickers)
	if player:getData("_id") ~= owner_id then
		triggerClientEvent(player, "dpGarage.saveCar", resourceRoot, false)
		return
	end

	exports.dpCore:updateVehicleTuning(vehicleId, tuning, stickers)
end)

addEvent("dpGarage.saveCar", true)
addEventHandler("dpGarage.saveCar", resourceRoot, function (vehicleId, tuning, stickers)
	if client:getData("dpCore.state") ~= "garage" then
		triggerClientEvent(client, "dpGarage.saveCar", resourceRoot, false)
		return
	end
	exports.dpCore:getVehicleOwnerAsync(vehicleId, "onOwnerReceived", client, vehicleId, tuning, stickers)
end)

addEvent("dpGarage.buy", true)
addEventHandler("dpGarage.buy", resourceRoot, function(price, level)
	if type(level) ~= "number" or type(price) ~= "number" then
		triggerClientEvent(client, "dpGarage.buy", resourceRoot, false)
	end

	if level > client:getData("level") then
		triggerClientEvent(client, "dpGarage.buy", resourceRoot, false)
		return
	end
	local money = client:getData("money")
	if type(money) ~= "number" or money < price then
		triggerClientEvent(client, "dpGarage.buy", resourceRoot, false)
		return
	end
	client:setData("money", money - price)

	triggerClientEvent(client, "dpGarage.buy", resourceRoot, true)
end)