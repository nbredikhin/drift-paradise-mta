addEvent("dpCarshop.buyVehicle", true)
addEventHandler("dpCarshop.buyVehicle", resourceRoot, function (model)
	if type(model) ~= "number" then
		triggerClientEvent(client, "dpCarshop.buyVehicle", resourceRoot, false)
		return
	end

	local level = client:getData("level")
	local money = client:getData("money")
	if not level or not money then
		triggerClientEvent(client, "dpCarshop.buyVehicle", resourceRoot, false)
		return
	end

	local vehicleName = exports.dpShared:getVehicleNameFromModel(model)
	local priceInfo = exports.dpShared:getVehiclePrices(vehicleName)
	if type(priceInfo) ~= "table" then
		triggerClientEvent(client, "dpCarshop.buyVehicle", resourceRoot, false)
		return
	end
	if not priceInfo[2] then
		priceInfo[2] = 1
	end
	if priceInfo[2] > level then
		-- Слишком маленький уровень
		triggerClientEvent(client, "dpCarshop.buyVehicle", resourceRoot, false)
		return
	end
	if priceInfo[1] > money then
		triggerClientEvent(client, "dpCarshop.buyVehicle", resourceRoot, false)
		-- Недостаточно денег
		return
	end
	if exports.dpCore:addPlayerVehicle(client, model) then
		client:setData("money", money - priceInfo[1])
		triggerClientEvent(client, "dpCarshop.buyVehicle", resourceRoot, true)
	else
		triggerClientEvent(client, "dpCarshop.buyVehicle", resourceRoot, false)
	end
end)