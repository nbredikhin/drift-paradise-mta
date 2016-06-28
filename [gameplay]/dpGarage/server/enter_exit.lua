addEvent("dpGarage.enter", true)
addEventHandler("dpGarage.enter", resourceRoot, function ()
	if client:getData("dpCore.state") then
		triggerClientEvent(client, "dpGarage.enter", resourceRoot, false, "garage_enter_failed")
		return
	end
	local playerVehicles = exports.dpCore:getPlayerVehicles(client)
	if type(playerVehicles) ~= "table" or #playerVehicles == 0 then
		triggerClientEvent(client, "dpGarage.enter", resourceRoot, false, "garage_enter_failed")
		return
	end
	client:setData("dpCore.state", "garage")

	-- _id машины, в которой был игрок, когда вошел в гараж (если это его машина)
	local enteredVehicleId
	-- Выкинуть игрока из машины
	if client.vehicle then
		-- Отправить машину игрока в гараж, если игрок является водителем и владельцем
		if client.vehicle.controller == client and exports.dpCore:isPlayerOwningVehicle(client, client.vehicle) then
			enteredVehicleId = client.vehicle:getData("_id")
			exports.dpCore:returnVehicleToGarage(client.vehicle)
		end
		client:removeFromVehicle()
	end

	-- Перенос игрока в уникальный dimension
	client.position = Vector3(0, 0, 0)
	client.dimension = tonumber(client:getData("_id")) or (math.random(1000, 9999) + 5000) + 4000
	client.frozen = true
	triggerClientEvent(client, "dpGarage.enter", resourceRoot, true, playerVehicles, enteredVehicleId)
	client:setData("activeMap", false)
end)

addEvent("dpGarage.exit", true)
addEventHandler("dpGarage.exit", resourceRoot, function (selectedCarId)
	if client:getData("dpCore.state") ~= "garage" then
		triggerClientEvent(client, "dpGarage.exit", resourceRoot, false)
		return
	end
	client:setData("dpCore.state", false)

	-- Координаты дома
	local houseId = exports.dpHouses:getPlayerHouseId(client)
	if type(houseId) ~= "number" then
		houseId = 0
	end
	local houseLocation = exports.dpHouses:getHouseLocation(houseId)
	if type(houseLocation) ~= "table" or type(houseLocation.garage) ~= "table" then
		client.position = Vector3(0, 0, 10)
	else
		client.position = houseLocation.garage.position
		client.rotation = houseLocation.garage.rotation + Vector3(0, 0, 180)
	end
	client.frozen = false
	client.dimension = 0
	-- Если игрок выбрал машину в гараже
	if selectedCarId then
		local vehicle = exports.dpCore:spawnVehicle(selectedCarId, client.position, client.rotation)
		warpPedIntoVehicle(client, vehicle)
	end
	triggerClientEvent(client, "dpGarage.exit", resourceRoot, true)
end)

addEventHandler("onResourceStart", resourceRoot, function ()
	for i, player in ipairs(getElementsByType("player")) do
		-- Сбросить state всех игроков при перезапуске ресурса
		if player:getData("dpCore.state") == "garage" then
			player:setData("dpCore.state", false)
			player.dimension = 0
		end
	end
end)