addEvent("dpGarage.enter", true)
addEventHandler("dpGarage.enter", resourceRoot, function ()
	if client:getData("state") then
		triggerClientEvent(client, "dpGarage.enter", resourceRoot, false, "garage_enter_failed")
		return
	end
	client:setData("state", "garage")
	-- Сохранение состояния игрка на момент входа в гараж
	local playerState = {}
	playerState.position = client.position
	playerState.rotation = client.rotation
	playerState.interior = client.interior
	playerState.dimension = client.dimension
	client:setData("dpGarage.enterState", playerState)
	-- Выкинуть игрока из машины
	if client.vehicle then
		-- Отправить машину игрока в гараж, если игрок является водителем и владельцем
		if client.vehicle.controller == client and client.vehicle:getData("owner_id") == client:getData("_id") then
			-- TODO: Отправить машину в гараж
			-- exports.dpCore:vehicleToGarage(client.vehicle)
		end
		client:removeFromVehicle()
	end
	-- Перенос игрока в уникальный dimension
	client.dimension = tonumber(client:getData("_id")) or (math.random(1000, 9999) + 5000) + 4000
	client.frozen = true
	triggerClientEvent(client, "dpGarage.enter", resourceRoot, true)
end)

addEvent("dpGarage.exit", true)
addEventHandler("dpGarage.exit", resourceRoot, function ()
	if client:getData("state") ~= "garage" then
		triggerClientEvent(client, "dpGarage.exit", resourceRoot, false)
		return
	end
	client:setData("state", false)
	-- Восстановление состояния игркоа
	local playerState = client:getData("dpGarage.enterState")
	if type(playerState) ~= "table" then
		playerState = {
			dimension = 0,
			interior = 0
		}
	end
	for k, v in pairs(playerState) do
		client[k] = v
		outputChatBox(k .. " = " .. tostring(v))
	end
	client.frozen = false
	triggerClientEvent(client, "dpGarage.exit", resourceRoot, true)
end)

addEventHandler("onResourceStart", resourceRoot, function ()
	for i, player in ipairs(getElementsByType("player")) do
		-- Сбросить state всех игроков при перезапуске ресурса
		if player:getData("state") == "garage" then
			player:setData("state", false)
		end
	end
end)