-- Начальные скины
local START_SKINS = {15, 46, 96}

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

		local startMoney = exports.dpShared:getEconomicsProperty("start_money")
		source:setData("money", startMoney)
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
			local startVehicles = {}
			local startVehiclesNames = exports.dpShared:getEconomicsProperty("start_vehicles")
			if not startVehiclesNames then 
				startVehiclesNames = {}
			end
			for i, name in ipairs(startVehiclesNames) do
				local model = exports.dpShared:getVehicleModelFromName(name)
				if model then
					table.insert(startVehicles, model)
				end
			end
			triggerClientEvent(player, "dpVehicleSelect.start", resourceRoot, startVehicles)
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
	local startVehiclesNames = exports.dpShared:getEconomicsProperty("start_vehicles")
	local name = startVehiclesNames[selectedVehicle]
	local model = exports.dpShared:getVehicleModelFromName(name)
	
	UserVehicles.addVehicle(client:getData("_id"), model, function(success)
		PlayerSpawn.spawn(player)
	end)
end)

addEvent("dpCore.selfKick", true)
addEventHandler("dpCore.selfKick", root, function ()
	if client.type == "player" then
		client:kick("You have been disconnected")
	end
end)