-- Начальные скины
local START_SKINS = {15, 46, 96}
local START_VEHICLES = {411, 602, 558}

-- Вход игрока на сервер
addEvent("dpCore.login", false)
addEventHandler("dpCore.login", root, function (success)
	if not success then
		return
	end
	-- Если не выбран персонаж - перекинуть на экран выбора персонажа
	if source:getData("skin") == 0 then
		triggerClientEvent(source, "dpSkinSelect.start", resourceRoot, START_SKINS)
		source:setData("dpCore.state", "skinSelect")
	else
		PlayerSpawn.spawn(source)
	end
end)

-- Выбор скина
addEvent("dpSkinSelect.selected", true)
addEventHandler("dpSkinSelect.selected", root, function (skin)
	if not client or client:getData("dpCore.state") ~= "skinSelect" then
		return false
	end	
	client:setData("dpCore.state", false)
	if not skin then
		skin = 1
	end
	client:setData("skin", START_SKINS[skin])
	client.model = START_SKINS[skin]

	-- Переход к выбору автомобиля
	local player = client
	UserVehicles.getVehiclesIds(client:getData("_id"), function(vehicles)
		if type(vehicles) == "table" and #vehicles > 0 then
			PlayerSpawn.spawn(player)
		else
			triggerClientEvent(player, "dpVehicleSelect.start", resourceRoot, START_VEHICLES)
			player:setData("dpCore.state", "vehicleSelect")
		end
	end)
end)

-- Выбор стартового автомобиля
addEvent("dpVehicleSelect.selected", true)
addEventHandler("dpVehicleSelect.selected", root, function (selectedVehicle)
	if not client or client:getData("dpCore.state") ~= "vehicleSelect" then
		return false
	end
	client:setData("dpCore.state", false)
	if type(selectedVehicle) ~= "number" then
		selectedVehicle = 1
	end
	local player = client
	UserVehicles.addVehicle(client:getData("_id"), START_VEHICLES[selectedVehicle], function(success)
		PlayerSpawn.spawn(player)
	end)
end)

addEvent("dpCore.selfKick", true)
addEventHandler("dpCore.selfKick", root, function ()
	if client.type == "player" then
		client:kick("You have been disconnected")
	end
end)