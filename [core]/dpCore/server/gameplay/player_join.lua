-- Вход игрока на сервер
addEvent("dpCore.login", false)
addEventHandler("dpCore.login", root, function (success)
	if not success then
		return
	end
	-- Если не выбран персонаж - перекинуть на экран выбора персонажа
	local player = source
	UserVehicles.getVehiclesIds(player:getData("_id"), function(vehicles)
		if type(vehicles) == "table" and #vehicles > 0 then
			PlayerSpawn.spawn(player)
		else
			player.dimension = 1
			triggerClientEvent(player, "dpIntro.start", resourceRoot)
		end
	end)
end)

-- Выбор скина
addEvent("dpSkinSelect.selectedSkin", true)
addEventHandler("dpSkinSelect.selectedSkin", root, function (skin)
	client:setData("tutorialActive", true)
	client:setData("dpCore.state", false)
	client:setData("skin", skin)
	client:spawn(0, 0, 0, 0, skin, 0)
	client.model = skin
	client.dimension = 0

	-- Дать денег и отправить в магазин
	local startMoney = exports.dpShared:getEconomicsProperty("start_money")
	client:setData("money", startMoney)
	triggerClientEvent(client, "dpCarshop.forceEnter", resourceRoot)
end)

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
