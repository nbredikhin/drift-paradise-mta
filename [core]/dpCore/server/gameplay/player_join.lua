-- Начальные скины
local START_SKINS = {15, 46, 96, 124}
local START_VEHICLES = {411, 429, 600}

-- Вход игрока на сервер
addEvent("dpCore.login", false)
addEventHandler("dpCore.login", root, function (success)
	if not success then
		return
	end
	-- Если не выбран персонаж - перекинуть на экран выбора персонажа
	if source:getData("skin") == 0 then
		triggerClientEvent(source, "dpSkinSelect.start", resourceRoot, START_SKINS)
		source:setData("state", "skinSelect")
	else
		PlayerSpawn.spawn(source)
	end
end)

addEvent("dpSkinSelect.selected", true)
addEventHandler("dpSkinSelect.selected", root, function (skin)
	if not client or client:getData("state") ~= "skinSelect" then
		return false
	end	
	client:setData("state", "")
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
			player:setData("state", "vehicleSelect")
		end
	end)
end)

addEvent("dpVehicleSelect.selected", true)
addEventHandler("dpVehicleSelect.selected", root, function (selectedVehicle)
	if not client or client:getData("state") ~= "vehicleSelect" then
		return false
	end
	client:setData("state", "")
	if type(selectedVehicle) ~= "number" then
		selectedVehicle = 1
	end
	local player = client
	UserVehicles.addVehicle(client:getData("_id"), START_VEHICLES[selectedVehicle], function(success)
		PlayerSpawn.spawn(player)
	end)
end)