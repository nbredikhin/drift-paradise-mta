local carshopPosition = Vector3 { x = 1203.585, y = -1733.989, z = 14 } 

addEvent("dpCarshop.enter", true)
addEventHandler("dpCarshop.enter", resourceRoot, function ()
	if client:getData("dpCore.state") or not client:getData("serverId") then
		triggerClientEvent(client, "dpCarshop.enter", resourceRoot, false, "garage_enter_failed")
		return
	end
	client:setData("dpCore.state", "carshop")
	client.position = Vector3(1230.2, -1788.7, 130.156)
	client.dimension = (tonumber(client:getData("serverId")) or (math.random(1000, 9999) + 5000)) + 10000
	client.frozen = true
	triggerClientEvent(client, "dpCarshop.enter", resourceRoot, true)
	client:setData("activeMap", false)	
end)

addEvent("dpCarshop.exit", true)
addEventHandler("dpCarshop.exit", resourceRoot, function (selectedCarId)
	if client:getData("dpCore.state") ~= "carshop" then
		triggerClientEvent(client, "dpCarshop.exit", resourceRoot, false)
		return
	end
	client:setData("dpCore.state", false)

	client.position = carshopPosition
	client.rotation = Vector3(0, 0, 0)
	client.frozen = false
	client.dimension = 0

	triggerClientEvent(client, "dpCarshop.exit", resourceRoot, true)	
end)

addEventHandler("onResourceStart", resourceRoot, function ()
	for i, player in ipairs(getElementsByType("player")) do
		-- Сбросить state всех игроков при перезапуске ресурса
		if player:getData("dpCore.state") == "carshop" then
			player:setData("dpCore.state", false)
			player.dimension = 0
		end
	end
end)