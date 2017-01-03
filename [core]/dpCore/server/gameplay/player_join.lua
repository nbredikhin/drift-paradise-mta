local function handlePlayerFirstSpawn(player)
	if not isElement(player) then
		return
	end

	player:setData("tutorialActive", false)
	player:setData("skin", 0)
	player:setData("doCore.state", false)
	player.model = 0	

	local startVehicleName = exports.dpShared:getGameplaySetting("start_vehicle")
	if not startVehicleName then
		return
	end
	local startVehicleModel = exports.dpShared:getVehicleModelFromName(startVehicleName)
	UserVehicles.addVehicle(player:getData("_id"), startVehicleModel, 
		function()
			if isElement(player) then
				PlayerSpawn.spawn(player)
			end
		end)
end

-- Вход игрока на сервер
addEvent("dpCore.login", false)
addEventHandler("dpCore.login", root, function (success)
	if not success then
		return
	end
	local player = source
	UserVehicles.getVehiclesIds(player:getData("_id"), function(vehicles)
		if type(vehicles) == "table" and #vehicles > 0 then
			PlayerSpawn.spawn(player)
		else
			handlePlayerFirstSpawn(player)
		end
	end)
end)

-- -- Выбор скина
-- addEvent("dpSkinSelect.selectedSkin", true)
-- addEventHandler("dpSkinSelect.selectedSkin", root, function (skin)
-- 	client:setData("tutorialActive", true)
-- 	client:setData("dpCore.state", false)
-- 	client:setData("skin", skin)
-- 	client:spawn(0, 0, 0, 0, skin, 0)
-- 	client.model = skin
-- 	client.dimension = 0

-- 	-- Дать денег и отправить в магазин
-- 	local startMoney = exports.dpShared:getEconomicsProperty("start_money")
-- 	client:setData("money", startMoney)
-- 	triggerClientEvent(client, "dpCarshop.forceEnter", resourceRoot)
-- end)

addEvent("dpCore.selfKick", true)
addEventHandler("dpCore.selfKick", root, function ()
	if client.type == "player" then
		client:kick("You have been disconnected")
	end
end)

addEventHandler("onPlayerChangeNick", root, function (oldNick, newNick, changedByPlayer)
	if not changedByPlayer then
		return
	end
	exports.dpLogger:log("nicknames", ("Player %s changed nickname to %s"):format(tostring(oldNick), tostring(newNick)), true)
end)
