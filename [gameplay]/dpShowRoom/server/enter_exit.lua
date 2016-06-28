local carshopPosition = Vector3 { x = 1203.585, y = -1733.989, z = 13.57 } 

addEvent("dpShowRoom.enter", true)
addEventHandler("dpShowRoom.enter", resourceRoot, function ()
	if client:getData("dpCore.state") then
		triggerClientEvent(client, "dpShowRoom.enter", resourceRoot, false, "garage_enter_failed")
		return
	end
	client:setData("dpCore.state", "showroom")
	client.position = Vector3(0, 0, -5)
	client.dimension = tonumber(client:getData("_id")) or (math.random(1000, 9999) + 5000) + 10000
	client.frozen = true
	triggerClientEvent(client, "dpShowRoom.enter", resourceRoot, true)
	client:setData("activeMap", false)	
end)

addEvent("dpShowRoom.exit", true)
addEventHandler("dpShowRoom.exit", resourceRoot, function ()
	if client:getData("dpCore.state") ~= "showroom" then
		triggerClientEvent(client, "dpShowRoom.exit", resourceRoot, false)
		return
	end
	client:setData("dpCore.state", false)

	client.position = carshopPosition
	client.rotation = Vector3(0, 0, 0)
	client.frozen = false
	client.dimension = 0

	triggerClientEvent(client, "dpShowRoom.exit", resourceRoot, true)	
end)

addEventHandler("onResourceStart", resourceRoot, function ()
	for i, player in ipairs(getElementsByType("player")) do
		-- Сбросить state всех игроков при перезапуске ресурса
		if player:getData("dpCore.state") == "showroom" then
			player:setData("dpCore.state", false)
			player.dimension = 0
		end
	end
end)